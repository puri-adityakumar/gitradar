import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;

import '../generated/protocol.dart';
import '../services/encryption_service.dart';
import '../services/sync_service.dart';
import '../util/session_util.dart';

/// Endpoint for managing watched GitHub repositories.
/// Supports both authenticated (with PAT) and anonymous users.
/// Anonymous users can only track public repositories.
class RepositoryEndpoint extends Endpoint {
  static const _maxRepositoriesPerUser = 10;

  /// Add a repository to the user's watchlist.
  /// Anonymous users can only add public repositories.
  Future<Repository> addRepository(
    Session session,
    String owner,
    String repo,
  ) async {
    final userId = SessionUtil.requireUserId(session);

    // Check repository limit
    final currentCount = await Repository.db.count(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (currentCount >= _maxRepositoriesPerUser) {
      throw Exception(
          'Maximum repository limit reached ($_maxRepositoriesPerUser)');
    }

    // Check for duplicate
    final existing = await Repository.db.findFirstRow(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.owner.equals(owner) &
          t.repo.equals(repo),
    );

    if (existing != null) {
      throw Exception('Repository already being watched');
    }

    // Get user to check if they have PAT
    final user = await User.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }

    final hasPat = user.encryptedPat != null && !user.isAnonymous;

    // Build headers based on whether user has PAT
    final headers = <String, String>{
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'GitRadar',
    };

    if (hasPat) {
      final pat = EncryptionService.decrypt(user.encryptedPat!);
      headers['Authorization'] = 'Bearer $pat';
    }

    // Validate repository exists on GitHub
    final response = await http.get(
      Uri.parse('https://api.github.com/repos/$owner/$repo'),
      headers: headers,
    );

    if (response.statusCode == 404) {
      throw ApiException(message: 'Repository not found on GitHub', code: 'NOT_FOUND');
    }

    if (response.statusCode == 403 || response.statusCode == 429) {
      throw ApiException(
        message: 'GitHub rate limit exceeded. Please add a GitHub PAT in settings for higher limits (5000 req/hr vs 60 req/hr).',
        code: 'RATE_LIMIT',
      );
    }

    if (response.statusCode != 200) {
      throw ApiException(
        message: 'Failed to validate repository (GitHub returned ${response.statusCode})',
        code: 'GITHUB_ERROR',
      );
    }

    final repoData = jsonDecode(response.body) as Map<String, dynamic>;
    final githubRepoId = repoData['id'] as int;
    final isPrivate = repoData['private'] as bool;

    // Anonymous users cannot add private repositories
    if (isPrivate && !hasPat) {
      throw Exception(
          'Private repositories require a GitHub PAT. Add your PAT in settings to track private repos.');
    }

    final now = DateTime.now();

    return await Repository.db.insertRow(
      session,
      Repository(
        userId: userId,
        owner: owner,
        repo: repo,
        githubRepoId: githubRepoId,
        isPrivate: isPrivate,
        inAppNotifications: true,
        pushNotifications: false,
        notificationLevel: 'all',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  /// List all repositories for the current user.
  Future<List<Repository>> listRepositories(Session session) async {
    final userId = SessionUtil.requireUserId(session);

    return await Repository.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Remove a repository from the user's watchlist.
  /// Also deletes associated PRs, Issues, and Notifications.
  Future<void> removeRepository(Session session, int repositoryId) async {
    final userId = SessionUtil.requireUserId(session);

    final repository = await Repository.db.findById(session, repositoryId);
    if (repository == null) {
      throw Exception('Repository not found');
    }

    if (repository.userId != userId) {
      throw Exception('Not authorized to delete this repository');
    }

    // Delete associated data in order (due to foreign keys)
    await Notification.db.deleteWhere(
      session,
      where: (t) => t.repositoryId.equals(repositoryId),
    );

    await PullRequest.db.deleteWhere(
      session,
      where: (t) => t.repositoryId.equals(repositoryId),
    );

    await Issue.db.deleteWhere(
      session,
      where: (t) => t.repositoryId.equals(repositoryId),
    );

    await Repository.db.deleteRow(session, repository);
  }

  /// Update notification settings for a repository.
  Future<Repository> updateNotificationSettings(
    Session session,
    int repositoryId,
    bool inAppNotifications,
    bool pushNotifications,
    String notificationLevel,
  ) async {
    final userId = SessionUtil.requireUserId(session);

    final repository = await Repository.db.findById(session, repositoryId);
    if (repository == null) {
      throw Exception('Repository not found');
    }

    if (repository.userId != userId) {
      throw Exception('Not authorized to modify this repository');
    }

    // Validate notification level
    if (!['all', 'mentions', 'none'].contains(notificationLevel)) {
      throw Exception('Invalid notification level');
    }

    repository.inAppNotifications = inAppNotifications;
    repository.pushNotifications = pushNotifications;
    repository.notificationLevel = notificationLevel;
    repository.updatedAt = DateTime.now();

    return await Repository.db.updateRow(session, repository);
  }

  /// Check if a repository can be accessed by the user.
  /// Returns repository info if accessible, throws if not.
  Future<Map<String, dynamic>> checkRepositoryAccess(
    Session session,
    String owner,
    String repo,
  ) async {
    final userId = SessionUtil.getUserId(session);

    // Build headers
    final headers = <String, String>{
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'GitRadar',
    };

    if (userId != null) {
      final user = await User.db.findById(session, userId);
      if (user != null && user.encryptedPat != null) {
        final pat = EncryptionService.decrypt(user.encryptedPat!);
        headers['Authorization'] = 'Bearer $pat';
      }
    }

    final response = await http.get(
      Uri.parse('https://api.github.com/repos/$owner/$repo'),
      headers: headers,
    );

    if (response.statusCode == 404) {
      throw Exception('Repository not found');
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to check repository');
    }

    final repoData = jsonDecode(response.body) as Map<String, dynamic>;
    final isPrivate = repoData['private'] as bool;

    return {
      'id': repoData['id'],
      'name': repoData['name'],
      'full_name': repoData['full_name'],
      'private': isPrivate,
      'description': repoData['description'],
      'requires_pat': isPrivate,
    };
  }

  /// Manually trigger sync for all user's repositories.
  /// Returns a list of sync results with statistics.
  Future<List<SyncResult>> syncRepositories(Session session) async {
    final userId = SessionUtil.requireUserId(session);

    final user = await User.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }

    final repos = await Repository.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (repos.isEmpty) {
      return [];
    }

    final syncService = SyncService();
    final results = <SyncResult>[];

    for (final repo in repos) {
      try {
        final result = await syncService.syncRepository(session, repo, user);
        results.add(result);
      } catch (e) {
        session.log(
          'Failed to sync repo ${repo.owner}/${repo.repo}: $e',
          level: LogLevel.error,
        );
      }
    }

    return results;
  }
}
