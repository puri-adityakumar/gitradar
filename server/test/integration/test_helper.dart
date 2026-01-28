import 'package:serverpod/serverpod.dart';
import 'package:gitradar_server/src/generated/protocol.dart';

/// Helper to create a test user in the database.
Future<User> createTestUser(
  Session session, {
  bool isAnonymous = true,
  String? deviceId,
  int? githubId,
  String? githubUsername,
}) async {
  final now = DateTime.now();
  return await User.db.insertRow(
    session,
    User(
      deviceId: deviceId ?? 'test-device-${now.millisecondsSinceEpoch}',
      isAnonymous: isAnonymous,
      githubId: githubId,
      githubUsername: githubUsername,
      createdAt: now,
      updatedAt: now,
    ),
  );
}

/// Helper to create a test repository in the database.
Future<Repository> createTestRepository(
  Session session, {
  required int userId,
  String owner = 'testowner',
  String repo = 'testrepo',
  int githubRepoId = 12345,
  bool isPrivate = false,
}) async {
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

/// Helper to create a test pull request.
Future<PullRequest> createTestPullRequest(
  Session session, {
  required int repositoryId,
  required int number,
  int githubId = 1,
  String state = 'open',
  String title = 'Test PR',
  bool isRead = false,
}) async {
  final now = DateTime.now();
  return await PullRequest.db.insertRow(
    session,
    PullRequest(
      repositoryId: repositoryId,
      githubId: githubId,
      number: number,
      title: title,
      state: state,
      author: 'testuser',
      htmlUrl: 'https://github.com/testowner/testrepo/pull/$number',
      githubCreatedAt: now,
      githubUpdatedAt: now,
      isRead: isRead,
      createdAt: now,
      updatedAt: now,
    ),
  );
}

/// Helper to create a test issue.
Future<Issue> createTestIssue(
  Session session, {
  required int repositoryId,
  required int number,
  int githubId = 1,
  String state = 'open',
  String title = 'Test Issue',
  bool isRead = false,
}) async {
  final now = DateTime.now();
  return await Issue.db.insertRow(
    session,
    Issue(
      repositoryId: repositoryId,
      githubId: githubId,
      number: number,
      title: title,
      state: state,
      author: 'testuser',
      htmlUrl: 'https://github.com/testowner/testrepo/issues/$number',
      githubCreatedAt: now,
      githubUpdatedAt: now,
      isRead: isRead,
      createdAt: now,
      updatedAt: now,
    ),
  );
}

/// Helper to create a test notification.
Future<Notification> createTestNotification(
  Session session, {
  required int userId,
  required int repositoryId,
  String type = 'pr_opened',
  String title = 'Test Notification',
  String message = 'Test message',
  bool isRead = false,
}) async {
  final now = DateTime.now();
  return await Notification.db.insertRow(
    session,
    Notification(
      userId: userId,
      repositoryId: repositoryId,
      type: type,
      title: title,
      message: message,
      isRead: isRead,
      createdAt: now,
    ),
  );
}
