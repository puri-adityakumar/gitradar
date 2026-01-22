import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'encryption_service.dart';
import 'github_api_service.dart';
import 'notification_service.dart';

/// Service for syncing GitHub data (PRs and Issues) for repositories.
class SyncService {
  final NotificationService _notificationService;

  /// Maximum number of PRs/Issues to store per repository (MVP limit).
  static const int maxItemsPerRepo = 50;

  SyncService({NotificationService? notificationService})
      : _notificationService = notificationService ?? NotificationService();

  /// Sync a single repository for a user.
  /// Returns a SyncResult with statistics about the sync.
  Future<SyncResult> syncRepository(
    Session session,
    Repository repo,
    User user,
  ) async {
    session.log('Starting sync for ${repo.owner}/${repo.repo}',
        level: LogLevel.info);

    // Get decrypted PAT if available
    String? pat;
    if (!user.isAnonymous && user.encryptedPat != null) {
      try {
        pat = EncryptionService.decrypt(user.encryptedPat!);
      } catch (e) {
        session.log('Failed to decrypt PAT: $e', level: LogLevel.warning);
      }
    }

    final api = GitHubApiService(pat: pat);

    var newPrs = 0;
    var updatedPrs = 0;
    var newIssues = 0;
    var updatedIssues = 0;
    var notificationsCreated = 0;

    try {
      // Sync pull requests
      final prResult = await _syncPullRequests(session, repo, api, user);
      newPrs = prResult['new'] ?? 0;
      updatedPrs = prResult['updated'] ?? 0;
      notificationsCreated += prResult['notifications'] ?? 0;

      // Sync issues
      final issueResult = await _syncIssues(session, repo, api, user);
      newIssues = issueResult['new'] ?? 0;
      updatedIssues = issueResult['updated'] ?? 0;
      notificationsCreated += issueResult['notifications'] ?? 0;

      // Update repository sync timestamp
      repo.lastSyncedAt = DateTime.now();
      await Repository.db.updateRow(session, repo);

      session.log(
        'Sync completed for ${repo.owner}/${repo.repo}: '
        '$newPrs new PRs, $updatedPrs updated PRs, '
        '$newIssues new issues, $updatedIssues updated issues',
        level: LogLevel.info,
      );
    } catch (e) {
      session.log('Sync failed for ${repo.owner}/${repo.repo}: $e',
          level: LogLevel.error);
      rethrow;
    } finally {
      api.dispose();
    }

    return SyncResult(
      repositoryId: repo.id!,
      newPullRequests: newPrs,
      updatedPullRequests: updatedPrs,
      newIssues: newIssues,
      updatedIssues: updatedIssues,
      notificationsCreated: notificationsCreated,
      syncedAt: DateTime.now(),
    );
  }

  /// Sync pull requests for a repository.
  Future<Map<String, int>> _syncPullRequests(
    Session session,
    Repository repo,
    GitHubApiService api,
    User user,
  ) async {
    var newCount = 0;
    var updatedCount = 0;
    var notificationCount = 0;

    try {
      final prs = await api.getPullRequests(
        repo.owner,
        repo.repo,
        since: repo.lastPrCursor,
      );

      DateTime? latestUpdate;

      for (final prData in prs) {
        final result = await _upsertPullRequest(session, repo, prData, user);
        if (result['isNew'] == true) {
          newCount++;
        } else if (result['isUpdated'] == true) {
          updatedCount++;
        }
        if (result['notificationCreated'] == true) {
          notificationCount++;
        }

        // Track latest update time for cursor
        final updatedAt = DateTime.parse(prData['updated_at'] as String);
        if (latestUpdate == null || updatedAt.isAfter(latestUpdate)) {
          latestUpdate = updatedAt;
        }
      }

      // Update cursor
      if (latestUpdate != null) {
        repo.lastPrCursor = latestUpdate;
        await Repository.db.updateRow(session, repo);
      }

      // Enforce max items limit
      await _enforceMaxPullRequests(session, repo.id!);
    } catch (e) {
      session.log('Failed to sync PRs for ${repo.owner}/${repo.repo}: $e',
          level: LogLevel.warning);
    }

    return {
      'new': newCount,
      'updated': updatedCount,
      'notifications': notificationCount,
    };
  }

  /// Sync issues for a repository.
  Future<Map<String, int>> _syncIssues(
    Session session,
    Repository repo,
    GitHubApiService api,
    User user,
  ) async {
    var newCount = 0;
    var updatedCount = 0;
    var notificationCount = 0;

    try {
      final issues = await api.getIssues(
        repo.owner,
        repo.repo,
        since: repo.lastIssueCursor,
      );

      DateTime? latestUpdate;

      for (final issueData in issues) {
        final result = await _upsertIssue(session, repo, issueData, user);
        if (result['isNew'] == true) {
          newCount++;
        } else if (result['isUpdated'] == true) {
          updatedCount++;
        }
        if (result['notificationCreated'] == true) {
          notificationCount++;
        }

        // Track latest update time for cursor
        final updatedAt = DateTime.parse(issueData['updated_at'] as String);
        if (latestUpdate == null || updatedAt.isAfter(latestUpdate)) {
          latestUpdate = updatedAt;
        }
      }

      // Update cursor
      if (latestUpdate != null) {
        repo.lastIssueCursor = latestUpdate;
        await Repository.db.updateRow(session, repo);
      }

      // Enforce max items limit
      await _enforceMaxIssues(session, repo.id!);
    } catch (e) {
      session.log('Failed to sync issues for ${repo.owner}/${repo.repo}: $e',
          level: LogLevel.warning);
    }

    return {
      'new': newCount,
      'updated': updatedCount,
      'notifications': notificationCount,
    };
  }

  /// Upsert a pull request from GitHub API data.
  Future<Map<String, bool>> _upsertPullRequest(
    Session session,
    Repository repo,
    Map<String, dynamic> prData,
    User user,
  ) async {
    final githubId = prData['id'] as int;
    final number = prData['number'] as int;
    final title = prData['title'] as String;
    final body = prData['body'] as String?;
    final author = (prData['user'] as Map<String, dynamic>)['login'] as String;
    final state = prData['state'] as String;
    final htmlUrl = prData['html_url'] as String;
    final githubCreatedAt = DateTime.parse(prData['created_at'] as String);
    final githubUpdatedAt = DateTime.parse(prData['updated_at'] as String);
    final mergedAt = prData['merged_at'] as String?;

    // Determine actual state (merged vs closed)
    final actualState = mergedAt != null ? 'merged' : state;

    // Check if PR already exists
    final existingPr = await PullRequest.db.findFirstRow(
      session,
      where: (t) =>
          t.repositoryId.equals(repo.id!) & t.number.equals(number),
    );

    var isNew = false;
    var isUpdated = false;
    var notificationCreated = false;

    if (existingPr != null) {
      // Check if state or update time changed
      final stateChanged = existingPr.state != actualState;
      final updated = existingPr.githubUpdatedAt.isBefore(githubUpdatedAt);

      if (stateChanged || updated) {
        existingPr.title = title;
        existingPr.body = body;
        existingPr.state = actualState;
        existingPr.githubUpdatedAt = githubUpdatedAt;
        existingPr.updatedAt = DateTime.now();

        final updatedPr = await PullRequest.db.updateRow(session, existingPr);
        isUpdated = true;

        // Create notification for state changes
        if (stateChanged) {
          final notifType = actualState == 'merged'
              ? PrNotificationType.merged
              : actualState == 'closed'
                  ? PrNotificationType.closed
                  : PrNotificationType.updated;
          final notif = await _notificationService.createPrNotification(
            session,
            repo,
            updatedPr,
            notifType,
            user,
          );
          notificationCreated = notif != null;
        }
      }
    } else {
      // Create new PR
      final newPr = await PullRequest.db.insertRow(
        session,
        PullRequest(
          repositoryId: repo.id!,
          githubId: githubId,
          number: number,
          title: title,
          body: body,
          author: author,
          state: actualState,
          htmlUrl: htmlUrl,
          githubCreatedAt: githubCreatedAt,
          githubUpdatedAt: githubUpdatedAt,
          isRead: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      isNew = true;

      // Create notification for new PR (only if repo is not freshly synced)
      if (repo.lastSyncedAt != null) {
        final notif = await _notificationService.createPrNotification(
          session,
          repo,
          newPr,
          PrNotificationType.opened,
          user,
        );
        notificationCreated = notif != null;
      }
    }

    return {
      'isNew': isNew,
      'isUpdated': isUpdated,
      'notificationCreated': notificationCreated,
    };
  }

  /// Upsert an issue from GitHub API data.
  Future<Map<String, bool>> _upsertIssue(
    Session session,
    Repository repo,
    Map<String, dynamic> issueData,
    User user,
  ) async {
    final githubId = issueData['id'] as int;
    final number = issueData['number'] as int;
    final title = issueData['title'] as String;
    final body = issueData['body'] as String?;
    final author =
        (issueData['user'] as Map<String, dynamic>)['login'] as String;
    final state = issueData['state'] as String;
    final htmlUrl = issueData['html_url'] as String;
    final githubCreatedAt = DateTime.parse(issueData['created_at'] as String);
    final githubUpdatedAt = DateTime.parse(issueData['updated_at'] as String);

    // Serialize labels
    String? labelsJson;
    final labels = issueData['labels'] as List<dynamic>?;
    if (labels != null && labels.isNotEmpty) {
      labelsJson = json.encode(
        labels.map((l) => (l as Map<String, dynamic>)['name']).toList(),
      );
    }

    // Check if issue already exists
    final existingIssue = await Issue.db.findFirstRow(
      session,
      where: (t) =>
          t.repositoryId.equals(repo.id!) & t.number.equals(number),
    );

    var isNew = false;
    var isUpdated = false;
    var notificationCreated = false;

    if (existingIssue != null) {
      // Check if state or update time changed
      final stateChanged = existingIssue.state != state;
      final updated = existingIssue.githubUpdatedAt.isBefore(githubUpdatedAt);

      if (stateChanged || updated) {
        existingIssue.title = title;
        existingIssue.body = body;
        existingIssue.state = state;
        existingIssue.labelsJson = labelsJson;
        existingIssue.githubUpdatedAt = githubUpdatedAt;
        existingIssue.updatedAt = DateTime.now();

        final updatedIssue = await Issue.db.updateRow(session, existingIssue);
        isUpdated = true;

        // Create notification for state changes
        if (stateChanged) {
          final notifType = state == 'closed'
              ? IssueNotificationType.closed
              : IssueNotificationType.updated;
          final notif = await _notificationService.createIssueNotification(
            session,
            repo,
            updatedIssue,
            notifType,
            user,
          );
          notificationCreated = notif != null;
        }
      }
    } else {
      // Create new issue
      final newIssue = await Issue.db.insertRow(
        session,
        Issue(
          repositoryId: repo.id!,
          githubId: githubId,
          number: number,
          title: title,
          body: body,
          author: author,
          state: state,
          labelsJson: labelsJson,
          htmlUrl: htmlUrl,
          githubCreatedAt: githubCreatedAt,
          githubUpdatedAt: githubUpdatedAt,
          isRead: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      isNew = true;

      // Create notification for new issue (only if repo is not freshly synced)
      if (repo.lastSyncedAt != null) {
        final notif = await _notificationService.createIssueNotification(
          session,
          repo,
          newIssue,
          IssueNotificationType.opened,
          user,
        );
        notificationCreated = notif != null;
      }
    }

    return {
      'isNew': isNew,
      'isUpdated': isUpdated,
      'notificationCreated': notificationCreated,
    };
  }

  /// Enforce maximum number of PRs per repository.
  /// Deletes oldest PRs if count exceeds limit.
  Future<void> _enforceMaxPullRequests(Session session, int repositoryId) async {
    final count = await PullRequest.db.count(
      session,
      where: (t) => t.repositoryId.equals(repositoryId),
    );

    if (count > maxItemsPerRepo) {
      // Get oldest PRs to delete
      final excess = count - maxItemsPerRepo;
      final oldestPrs = await PullRequest.db.find(
        session,
        where: (t) => t.repositoryId.equals(repositoryId),
        orderBy: (t) => t.githubUpdatedAt,
        limit: excess,
      );

      for (final pr in oldestPrs) {
        await PullRequest.db.deleteRow(session, pr);
      }
    }
  }

  /// Enforce maximum number of issues per repository.
  /// Deletes oldest issues if count exceeds limit.
  Future<void> _enforceMaxIssues(Session session, int repositoryId) async {
    final count = await Issue.db.count(
      session,
      where: (t) => t.repositoryId.equals(repositoryId),
    );

    if (count > maxItemsPerRepo) {
      // Get oldest issues to delete
      final excess = count - maxItemsPerRepo;
      final oldestIssues = await Issue.db.find(
        session,
        where: (t) => t.repositoryId.equals(repositoryId),
        orderBy: (t) => t.githubUpdatedAt,
        limit: excess,
      );

      for (final issue in oldestIssues) {
        await Issue.db.deleteRow(session, issue);
      }
    }
  }

  /// Sync all repositories for all users.
  /// Used by the scheduled future call.
  Future<List<SyncResult>> syncAllRepositories(Session session) async {
    final results = <SyncResult>[];

    // Get all users
    final users = await User.db.find(session);

    for (final user in users) {
      // Get repositories for this user
      final repos = await Repository.db.find(
        session,
        where: (t) => t.userId.equals(user.id!),
      );

      for (final repo in repos) {
        try {
          final result = await syncRepository(session, repo, user);
          results.add(result);
        } catch (e) {
          session.log(
            'Failed to sync repo ${repo.owner}/${repo.repo}: $e',
            level: LogLevel.error,
          );
        }
      }
    }

    return results;
  }
}
