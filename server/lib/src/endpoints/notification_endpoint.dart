import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Endpoint for managing in-app notifications.
class NotificationEndpoint extends Endpoint {
  static const _pageSize = 20;

  /// List notifications with cursor-based pagination.
  /// Returns newest first.
  Future<PaginatedNotifications> listNotifications(
    Session session,
    String? cursor,
  ) async {
    final userId = session.auth?.userId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    var whereClause = Notification.t.userId.equals(userId);

    // Cursor-based pagination
    if (cursor != null) {
      final cursorId = int.tryParse(cursor);
      if (cursorId != null) {
        whereClause = whereClause & Notification.t.id.lessThan(cursorId);
      }
    }

    final items = await Notification.db.find(
      session,
      where: (t) => whereClause,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: _pageSize + 1,
    );

    final hasMore = items.length > _pageSize;
    final resultItems = hasMore ? items.sublist(0, _pageSize) : items;
    final nextCursor = hasMore && resultItems.isNotEmpty
        ? resultItems.last.id.toString()
        : null;

    return PaginatedNotifications(
      items: resultItems,
      nextCursor: nextCursor,
      hasMore: hasMore,
    );
  }

  /// Mark a single notification as read.
  Future<void> markRead(Session session, int notificationId) async {
    final userId = session.auth?.userId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final notification = await Notification.db.findById(session, notificationId);
    if (notification == null) {
      throw Exception('Notification not found');
    }

    if (notification.userId != userId) {
      throw Exception('Not authorized');
    }

    notification.isRead = true;
    await Notification.db.updateRow(session, notification);
  }

  /// Mark all notifications as read for the current user.
  Future<void> markAllRead(Session session) async {
    final userId = session.auth?.userId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    // Get all unread notifications for this user
    final unreadNotifications = await Notification.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isRead.equals(false),
    );

    // Mark each as read
    for (final notification in unreadNotifications) {
      notification.isRead = true;
      await Notification.db.updateRow(session, notification);
    }
  }

  /// Get count of unread notifications.
  Future<int> getUnreadCount(Session session) async {
    final userId = session.auth?.userId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    return await Notification.db.count(
      session,
      where: (t) => t.userId.equals(userId) & t.isRead.equals(false),
    );
  }
}
