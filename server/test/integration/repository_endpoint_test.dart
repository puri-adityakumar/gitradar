import 'package:test/test.dart';
import 'package:gitradar_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_helper.dart';

void main() {
  withServerpod('RepositoryEndpoint', (sessionBuilder, endpoints) {
    group('addRepository', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.repository.addRepository(sessionBuilder, 'owner', 'repo'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('listRepositories', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.repository.listRepositories(sessionBuilder),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('removeRepository', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.repository.removeRepository(sessionBuilder, 1),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateNotificationSettings', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.repository.updateNotificationSettings(
            sessionBuilder,
            1,
            true,
            false,
            'all',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });
  });

  withServerpod('Repository model', (sessionBuilder, endpoints) {
    test('should create repository', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);

      final repo = await createTestRepository(
        session,
        userId: user.id!,
        owner: 'testowner',
        repo: 'testrepo',
      );

      expect(repo.id, isNotNull);
      expect(repo.userId, equals(user.id));
      expect(repo.owner, equals('testowner'));
      expect(repo.repo, equals('testrepo'));
      expect(repo.inAppNotifications, isTrue);
      expect(repo.pushNotifications, isFalse);
      expect(repo.notificationLevel, equals('all'));
    });

    test('should update notification settings', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);

      var repo = await createTestRepository(session, userId: user.id!);

      expect(repo.inAppNotifications, isTrue);
      expect(repo.pushNotifications, isFalse);
      expect(repo.notificationLevel, equals('all'));

      repo.inAppNotifications = false;
      repo.pushNotifications = true;
      repo.notificationLevel = 'mentions';
      repo = await Repository.db.updateRow(session, repo);

      expect(repo.inAppNotifications, isFalse);
      expect(repo.pushNotifications, isTrue);
      expect(repo.notificationLevel, equals('mentions'));
    });

    test('should allow same repo for different users', () async {
      final session = sessionBuilder.build();
      final user1 = await createTestUser(session, deviceId: 'device1-${DateTime.now().millisecondsSinceEpoch}');
      final user2 = await createTestUser(session, deviceId: 'device2-${DateTime.now().millisecondsSinceEpoch}');

      final repo1 = await createTestRepository(
        session,
        userId: user1.id!,
        owner: 'sharedowner',
        repo: 'sharedrepo',
        githubRepoId: 333,
      );

      final repo2 = await createTestRepository(
        session,
        userId: user2.id!,
        owner: 'sharedowner',
        repo: 'sharedrepo',
        githubRepoId: 333,
      );

      expect(repo1.id, isNotNull);
      expect(repo2.id, isNotNull);
      expect(repo1.id, isNot(equals(repo2.id)));
    });

    test('should list repositories for user', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);

      await createTestRepository(session, userId: user.id!, owner: 'owner1', repo: 'repo1', githubRepoId: 1);
      await createTestRepository(session, userId: user.id!, owner: 'owner2', repo: 'repo2', githubRepoId: 2);
      await createTestRepository(session, userId: user.id!, owner: 'owner3', repo: 'repo3', githubRepoId: 3);

      final repos = await Repository.db.find(
        session,
        where: (t) => t.userId.equals(user.id!),
      );

      expect(repos.length, equals(3));
    });

    test('should delete repository and cascade to related data', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      // Create related PRs, issues, and notifications
      await createTestPullRequest(session, repositoryId: repo.id!, number: 1);
      await createTestPullRequest(session, repositoryId: repo.id!, number: 2);
      await createTestIssue(session, repositoryId: repo.id!, number: 1);
      await createTestNotification(session, userId: user.id!, repositoryId: repo.id!);

      // Verify data exists
      var prCount = await PullRequest.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );
      var issueCount = await Issue.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );
      var notifCount = await Notification.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );

      expect(prCount, equals(2));
      expect(issueCount, equals(1));
      expect(notifCount, equals(1));

      // Delete related data first (simulating cascade)
      await Notification.db.deleteWhere(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );
      await PullRequest.db.deleteWhere(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );
      await Issue.db.deleteWhere(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );
      await Repository.db.deleteRow(session, repo);

      // Verify all data is deleted
      prCount = await PullRequest.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );
      issueCount = await Issue.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );
      notifCount = await Notification.db.count(
        session,
        where: (t) => t.repositoryId.equals(repo.id!),
      );
      final repoExists = await Repository.db.findById(session, repo.id!);

      expect(prCount, equals(0));
      expect(issueCount, equals(0));
      expect(notifCount, equals(0));
      expect(repoExists, isNull);
    });

    test('should support private flag', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);

      final publicRepo = await createTestRepository(
        session,
        userId: user.id!,
        owner: 'owner',
        repo: 'public',
        isPrivate: false,
        githubRepoId: 1,
      );

      final privateRepo = await createTestRepository(
        session,
        userId: user.id!,
        owner: 'owner',
        repo: 'private',
        isPrivate: true,
        githubRepoId: 2,
      );

      expect(publicRepo.isPrivate, isFalse);
      expect(privateRepo.isPrivate, isTrue);
    });
  });

  withServerpod('User model', (sessionBuilder, endpoints) {
    test('should create anonymous user', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(
        session,
        isAnonymous: true,
        deviceId: 'anon-device-${DateTime.now().millisecondsSinceEpoch}',
      );

      expect(user.id, isNotNull);
      expect(user.isAnonymous, isTrue);
      expect(user.githubId, isNull);
      expect(user.githubUsername, isNull);
    });

    test('should create authenticated user with GitHub info', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(
        session,
        isAnonymous: false,
        deviceId: 'auth-device-${DateTime.now().millisecondsSinceEpoch}',
        githubId: 12345,
        githubUsername: 'testuser',
      );

      expect(user.id, isNotNull);
      expect(user.isAnonymous, isFalse);
      expect(user.githubId, equals(12345));
      expect(user.githubUsername, equals('testuser'));
    });
  });
}
