import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/session_util.dart';

/// Endpoint for viewing pull requests and issues across all watched repositories.
class ActivityEndpoint extends Endpoint {
  static const _pageSize = 20;

  /// List pull requests with optional filtering and cursor-based pagination.
  Future<PaginatedPullRequests> listPullRequests(
    Session session,
    PullRequestFilter? filter,
    String? cursor,
  ) async {
    final userId = SessionUtil.requireUserId(session);

    // Get user's repository IDs
    final repositories = await Repository.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (repositories.isEmpty) {
      return PaginatedPullRequests(
        items: [],
        nextCursor: null,
        hasMore: false,
      );
    }

    final repoIds = repositories.map((r) => r.id!).toList();

    // Build query conditions
    var whereClause = PullRequest.t.repositoryId.inSet(repoIds.toSet());

    if (filter != null) {
      if (filter.repositoryId != null) {
        whereClause = whereClause & PullRequest.t.repositoryId.equals(filter.repositoryId!);
      }
      if (filter.state != null) {
        whereClause = whereClause & PullRequest.t.state.equals(filter.state!);
      }
      if (filter.isRead != null) {
        whereClause = whereClause & PullRequest.t.isRead.equals(filter.isRead!);
      }
    }

    // Cursor-based pagination
    if (cursor != null) {
      final cursorId = int.tryParse(cursor);
      if (cursorId != null) {
        whereClause = whereClause & (PullRequest.t.id < cursorId);
      }
    }

    final items = await PullRequest.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.githubUpdatedAt,
      orderDescending: true,
      limit: _pageSize + 1, // Fetch one extra to check if there's more
    );

    final hasMore = items.length > _pageSize;
    final resultItems = hasMore ? items.sublist(0, _pageSize) : items;
    final nextCursor = hasMore && resultItems.isNotEmpty
        ? resultItems.last.id.toString()
        : null;

    return PaginatedPullRequests(
      items: resultItems,
      nextCursor: nextCursor,
      hasMore: hasMore,
    );
  }

  /// List issues with optional filtering and cursor-based pagination.
  Future<PaginatedIssues> listIssues(
    Session session,
    IssueFilter? filter,
    String? cursor,
  ) async {
    final userId = SessionUtil.requireUserId(session);

    // Get user's repository IDs
    final repositories = await Repository.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (repositories.isEmpty) {
      return PaginatedIssues(
        items: [],
        nextCursor: null,
        hasMore: false,
      );
    }

    final repoIds = repositories.map((r) => r.id!).toList();

    // Build query conditions
    var whereClause = Issue.t.repositoryId.inSet(repoIds.toSet());

    if (filter != null) {
      if (filter.repositoryId != null) {
        whereClause = whereClause & Issue.t.repositoryId.equals(filter.repositoryId!);
      }
      if (filter.state != null) {
        whereClause = whereClause & Issue.t.state.equals(filter.state!);
      }
      if (filter.isRead != null) {
        whereClause = whereClause & Issue.t.isRead.equals(filter.isRead!);
      }
    }

    // Cursor-based pagination
    if (cursor != null) {
      final cursorId = int.tryParse(cursor);
      if (cursorId != null) {
        whereClause = whereClause & (Issue.t.id < cursorId);
      }
    }

    final items = await Issue.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.githubUpdatedAt,
      orderDescending: true,
      limit: _pageSize + 1,
    );

    final hasMore = items.length > _pageSize;
    final resultItems = hasMore ? items.sublist(0, _pageSize) : items;
    final nextCursor = hasMore && resultItems.isNotEmpty
        ? resultItems.last.id.toString()
        : null;

    return PaginatedIssues(
      items: resultItems,
      nextCursor: nextCursor,
      hasMore: hasMore,
    );
  }

  /// Mark a pull request or issue as read.
  Future<void> markAsRead(
    Session session,
    String entityType,
    int entityId,
  ) async {
    final userId = SessionUtil.requireUserId(session);

    if (entityType == 'pr') {
      final pr = await PullRequest.db.findById(session, entityId);
      if (pr == null) {
        throw Exception('Pull request not found');
      }

      // Verify ownership through repository
      final repo = await Repository.db.findById(session, pr.repositoryId);
      if (repo == null || repo.userId != userId) {
        throw Exception('Not authorized');
      }

      pr.isRead = true;
      pr.updatedAt = DateTime.now();
      await PullRequest.db.updateRow(session, pr);
    } else if (entityType == 'issue') {
      final issue = await Issue.db.findById(session, entityId);
      if (issue == null) {
        throw Exception('Issue not found');
      }

      // Verify ownership through repository
      final repo = await Repository.db.findById(session, issue.repositoryId);
      if (repo == null || repo.userId != userId) {
        throw Exception('Not authorized');
      }

      issue.isRead = true;
      issue.updatedAt = DateTime.now();
      await Issue.db.updateRow(session, issue);
    } else {
      throw Exception('Invalid entity type. Use "pr" or "issue"');
    }
  }

  /// Get counts of open PRs, open issues, and unread notifications.
  Future<ActivityCounts> getCounts(Session session) async {
    final userId = SessionUtil.requireUserId(session);

    // Get user's repository IDs
    final repositories = await Repository.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (repositories.isEmpty) {
      return ActivityCounts(
        openPullRequests: 0,
        openIssues: 0,
        unreadNotifications: 0,
      );
    }

    final repoIds = repositories.map((r) => r.id!).toList();

    final openPrs = await PullRequest.db.count(
      session,
      where: (t) => t.repositoryId.inSet(repoIds.toSet()) & t.state.equals('open'),
    );

    final openIssues = await Issue.db.count(
      session,
      where: (t) => t.repositoryId.inSet(repoIds.toSet()) & t.state.equals('open'),
    );

    final unreadNotifications = await Notification.db.count(
      session,
      where: (t) => t.userId.equals(userId) & t.isRead.equals(false),
    );

    return ActivityCounts(
      openPullRequests: openPrs,
      openIssues: openIssues,
      unreadNotifications: unreadNotifications,
    );
  }
}
