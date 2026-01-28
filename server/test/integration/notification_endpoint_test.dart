import 'package:test/test.dart';
import 'package:gitradar_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_helper.dart';

void main() {
  withServerpod('NotificationEndpoint', (sessionBuilder, endpoints) {
    group('listNotifications', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.notification.listNotifications(sessionBuilder, null),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('markRead', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.notification.markRead(sessionBuilder, 1),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('markAllRead', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.notification.markAllRead(sessionBuilder),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getUnreadCount', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.notification.getUnreadCount(sessionBuilder),
          throwsA(isA<Exception>()),
        );
      });
    });
  });

  withServerpod('Notification model', (sessionBuilder, endpoints) {
    test('should create notification', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      final notification = await createTestNotification(
        session,
        userId: user.id!,
        repositoryId: repo.id!,
      );

      expect(notification.id, isNotNull);
      expect(notification.userId, equals(user.id));
      expect(notification.repositoryId, equals(repo.id));
      expect(notification.isRead, isFalse);
    });

    test('should mark notification as read', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      var notification = await createTestNotification(
        session,
        userId: user.id!,
        repositoryId: repo.id!,
      );

      expect(notification.isRead, isFalse);

      notification.isRead = true;
      notification = await Notification.db.updateRow(session, notification);

      expect(notification.isRead, isTrue);
    });

    test('should count unread notifications', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      // Create 3 unread notifications
      await createTestNotification(session, userId: user.id!, repositoryId: repo.id!);
      await createTestNotification(session, userId: user.id!, repositoryId: repo.id!);
      await createTestNotification(session, userId: user.id!, repositoryId: repo.id!);

      // Create 1 read notification
      await createTestNotification(
        session,
        userId: user.id!,
        repositoryId: repo.id!,
        isRead: true,
      );

      final unreadCount = await Notification.db.count(
        session,
        where: (t) => t.userId.equals(user.id!) & t.isRead.equals(false),
      );

      expect(unreadCount, equals(3));
    });

    test('should support pagination with cursor', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final repo = await createTestRepository(session, userId: user.id!);

      // Create 5 notifications
      for (var i = 0; i < 5; i++) {
        await createTestNotification(
          session,
          userId: user.id!,
          repositoryId: repo.id!,
          title: 'Notification $i',
        );
      }

      // Get first 2
      final firstPage = await Notification.db.find(
        session,
        where: (t) => t.userId.equals(user.id!),
        orderBy: (t) => t.id,
        orderDescending: true,
        limit: 2,
      );

      expect(firstPage.length, equals(2));

      // Get next 2 using cursor
      final cursor = firstPage.last.id!;
      final secondPage = await Notification.db.find(
        session,
        where: (t) => t.userId.equals(user.id!) & (t.id < cursor),
        orderBy: (t) => t.id,
        orderDescending: true,
        limit: 2,
      );

      expect(secondPage.length, equals(2));
      expect(secondPage.first.id, lessThan(cursor));
    });
  });
}
