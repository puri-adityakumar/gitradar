import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';

import '../../core/client.dart';

/// Notifications provider.
final notificationsProvider = FutureProvider.autoDispose<PaginatedNotifications>((ref) async {
  final client = ref.watch(clientProvider);
  return await client.notification.listNotifications(null);
});

/// Unread count provider.
final unreadCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final client = ref.watch(clientProvider);
  return await client.notification.getUnreadCount();
});

/// Mark notification as read provider.
final markNotificationReadProvider = Provider.autoDispose<Future<void> Function(int)>((ref) {
  return (int notificationId) async {
    final client = ref.read(clientProvider);
    await client.notification.markRead(notificationId);
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadCountProvider);
  };
});

/// Mark all notifications as read provider.
final markAllReadProvider = Provider.autoDispose<Future<void> Function()>((ref) {
  return () async {
    final client = ref.read(clientProvider);
    await client.notification.markAllRead();
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadCountProvider);
  };
});
