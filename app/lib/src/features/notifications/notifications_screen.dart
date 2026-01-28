import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart' as client;
import 'package:timeago/timeago.dart' as timeago;

import '../../core/theme.dart';
import '../../shared/widgets/empty_widget.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import 'notifications_provider.dart';

/// Notifications screen.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          unreadCountAsync.whenData((count) {
            if (count > 0) {
              return TextButton(
                onPressed: () => _markAllRead(context, ref),
                child: const Text('Mark all read'),
              );
            }
            return const SizedBox.shrink();
          }).value ?? const SizedBox.shrink(),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const LoadingWidget(message: 'Loading notifications...'),
        error: (error, stack) => ErrorDisplay(
          message: 'Failed to load notifications:\n$error',
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (result) {
          if (result.items.isEmpty) {
            return const EmptyWidget(
              icon: Icons.notifications_none,
              title: 'No notifications',
              subtitle: 'Notifications about your tracked repositories will appear here.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificationsProvider);
              await ref.read(notificationsProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: result.items.length,
              itemBuilder: (context, index) => _NotificationCard(
                notification: result.items[index],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _markAllRead(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(markAllReadProvider)();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}

class _NotificationCard extends ConsumerWidget {
  final client.Notification notification;

  const _NotificationCard({required this.notification});

  IconData get _icon {
    switch (notification.type) {
      case 'pr_opened':
        return Icons.merge_type;
      case 'pr_closed':
        return Icons.merge_type;
      case 'pr_merged':
        return Icons.merge;
      case 'issue_opened':
        return Icons.bug_report;
      case 'issue_closed':
        return Icons.bug_report;
      default:
        return Icons.notifications;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case 'pr_opened':
      case 'issue_opened':
        return AppTheme.accentColor;
      case 'pr_merged':
        return AppTheme.prMergedColor;
      case 'pr_closed':
      case 'issue_closed':
        return AppTheme.prClosedColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: notification.isRead ? null : AppTheme.primaryColor.withOpacity(0.05),
      child: InkWell(
        onTap: () => _markAsRead(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_icon, size: 20, color: _iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeago.format(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _markAsRead(BuildContext context, WidgetRef ref) async {
    if (notification.isRead) return;

    try {
      await ref.read(markNotificationReadProvider)(notification.id!);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark as read: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}
