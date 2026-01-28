import 'package:test/test.dart';
import 'package:gitradar_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_helper.dart';

void main() {
  withServerpod('ActivityEndpoint', (sessionBuilder, endpoints) {
    group('listPullRequests', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.activity.listPullRequests(sessionBuilder, null, null),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('listIssues', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.activity.listIssues(sessionBuilder, null, null),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('markAsRead', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.activity.markAsRead(sessionBuilder, 'pr', 1),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getCounts', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.activity.getCounts(sessionBuilder),
          throwsA(isA<Exception>()),
        );
      });
    });
  });

  withServerpod('PullRequest model', (sessionBuilder, endpoints) {
    test('should create pull request', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      final pr = await createTestPullRequest(
        session,
        repositoryId: repo.id!,
        number: 1,
      );

      expect(pr.id, isNotNull);
      expect(pr.repositoryId, equals(repo.id));
      expect(pr.number, equals(1));
      expect(pr.isRead, isFalse);
    });

    test('should update isRead flag', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      var pr = await createTestPullRequest(
        session,
        repositoryId: repo.id!,
        number: 1,
      );

      expect(pr.isRead, isFalse);

      pr.isRead = true;
      pr = await PullRequest.db.updateRow(session, pr);

      expect(pr.isRead, isTrue);
    });

    test('should filter by state', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      // Create PRs with different states
      await createTestPullRequest(
        session,
        repositoryId: repo.id!,
        number: 1,
        state: 'open',
      );
      await createTestPullRequest(
        session,
        repositoryId: repo.id!,
        number: 2,
        state: 'open',
      );
      await createTestPullRequest(
        session,
        repositoryId: repo.id!,
        number: 3,
        state: 'closed',
      );

      final openPrs = await PullRequest.db.find(
        session,
        where: (t) => t.repositoryId.equals(repo.id!) & t.state.equals('open'),
      );

      final closedPrs = await PullRequest.db.find(
        session,
        where: (t) => t.repositoryId.equals(repo.id!) & t.state.equals('closed'),
      );

      expect(openPrs.length, equals(2));
      expect(closedPrs.length, equals(1));
    });

    test('should support pagination with cursor', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      // Create 5 PRs
      for (var i = 1; i <= 5; i++) {
        await createTestPullRequest(
          session,
          repositoryId: repo.id!,
          number: i,
          githubId: i,
        );
      }

      // Get first 2
      final firstPage = await PullRequest.db.find(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
        orderBy: (t) => t.id,
        orderDescending: true,
        limit: 2,
      );

      expect(firstPage.length, equals(2));

      // Get next 2 using cursor
      final cursor = firstPage.last.id!;
      final secondPage = await PullRequest.db.find(
        session,
        where: (t) => t.repositoryId.equals(repo.id!) & (t.id < cursor),
        orderBy: (t) => t.id,
        orderDescending: true,
        limit: 2,
      );

      expect(secondPage.length, equals(2));
      expect(secondPage.first.id, lessThan(cursor));
    });
  });

  withServerpod('Issue model', (sessionBuilder, endpoints) {
    test('should create issue', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      final issue = await createTestIssue(
        session,
        repositoryId: repo.id!,
        number: 1,
      );

      expect(issue.id, isNotNull);
      expect(issue.repositoryId, equals(repo.id));
      expect(issue.number, equals(1));
      expect(issue.isRead, isFalse);
    });

    test('should update isRead flag', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      var issue = await createTestIssue(
        session,
        repositoryId: repo.id!,
        number: 1,
      );

      expect(issue.isRead, isFalse);

      issue.isRead = true;
      issue = await Issue.db.updateRow(session, issue);

      expect(issue.isRead, isTrue);
    });

    test('should filter by state', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      // Create issues with different states
      await createTestIssue(
        session,
        repositoryId: repo.id!,
        number: 1,
        state: 'open',
      );
      await createTestIssue(
        session,
        repositoryId: repo.id!,
        number: 2,
        state: 'open',
      );
      await createTestIssue(
        session,
        repositoryId: repo.id!,
        number: 3,
        state: 'closed',
      );

      final openIssues = await Issue.db.find(
        session,
        where: (t) => t.repositoryId.equals(repo.id!) & t.state.equals('open'),
      );

      final closedIssues = await Issue.db.find(
        session,
        where: (t) => t.repositoryId.equals(repo.id!) & t.state.equals('closed'),
      );

      expect(openIssues.length, equals(2));
      expect(closedIssues.length, equals(1));
    });

    test('should count open issues', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      // Create 3 open and 2 closed issues
      await createTestIssue(session, repositoryId: repo.id!, number: 1, state: 'open');
      await createTestIssue(session, repositoryId: repo.id!, number: 2, state: 'open');
      await createTestIssue(session, repositoryId: repo.id!, number: 3, state: 'open');
      await createTestIssue(session, repositoryId: repo.id!, number: 4, state: 'closed');
      await createTestIssue(session, repositoryId: repo.id!, number: 5, state: 'closed');

      final openCount = await Issue.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!) & t.state.equals('open'),
      );

      expect(openCount, equals(3));
    });
  });

  withServerpod('ActivityCounts', (sessionBuilder, endpoints) {
    test('should count PRs, issues, and notifications', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      // Create 2 open PRs, 1 closed PR
      await createTestPullRequest(session, repositoryId: repo.id!, number: 1, state: 'open');
      await createTestPullRequest(session, repositoryId: repo.id!, number: 2, state: 'open');
      await createTestPullRequest(session, repositoryId: repo.id!, number: 3, state: 'closed');

      // Create 3 open issues, 1 closed issue
      await createTestIssue(session, repositoryId: repo.id!, number: 1, state: 'open');
      await createTestIssue(session, repositoryId: repo.id!, number: 2, state: 'open');
      await createTestIssue(session, repositoryId: repo.id!, number: 3, state: 'open');
      await createTestIssue(session, repositoryId: repo.id!, number: 4, state: 'closed');

      // Create 2 unread notifications, 1 read
      await createTestNotification(session, userId: user.id!, repositoryId: repo.id!, isRead: false);
      await createTestNotification(session, userId: user.id!, repositoryId: repo.id!, isRead: false);
      await createTestNotification(session, userId: user.id!, repositoryId: repo.id!, isRead: true);

      // Count PRs
      final openPrs = await PullRequest.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!) & t.state.equals('open'),
      );
      expect(openPrs, equals(2));

      // Count issues
      final openIssues = await Issue.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!) & t.state.equals('open'),
      );
      expect(openIssues, equals(3));

      // Count unread notifications
      final unreadNotifications = await Notification.db.count(
        session,
        where: (t) => t.userId.equals(user.id!) & t.isRead.equals(false),
      );
      expect(unreadNotifications, equals(2));
    });
  });
}
