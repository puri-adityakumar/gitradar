import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'onesignal_service.dart';

/// Service for creating and managing notifications.
class NotificationService {
  final OneSignalService? _oneSignalService;

  NotificationService({OneSignalService? oneSignalService})
      : _oneSignalService = oneSignalService;

  /// Create a notification for a pull request event.
  Future<Notification?> createPrNotification(
    Session session,
    Repository repo,
    PullRequest pr,
    String type,
    User user,
  ) async {
    // Check if notifications are enabled for this repo
    if (!repo.inAppNotifications) {
      return null;
    }

    final title = _getPrNotificationTitle(type, repo);
    final message = _getPrNotificationMessage(type, pr);

    final notification = Notification(
      userId: repo.userId,
      type: type,
      title: title,
      message: message,
      repositoryId: repo.id!,
      pullRequestId: pr.id,
      isRead: false,
      createdAt: DateTime.now(),
    );

    final created = await Notification.db.insertRow(session, notification);

    // Send push notification if enabled
    if (repo.pushNotifications && user.onesignalPlayerId != null) {
      await _sendPushNotification(user.onesignalPlayerId!, title, message);
    }

    return created;
  }

  /// Create a notification for an issue event.
  Future<Notification?> createIssueNotification(
    Session session,
    Repository repo,
    Issue issue,
    String type,
    User user,
  ) async {
    // Check if notifications are enabled for this repo
    if (!repo.inAppNotifications) {
      return null;
    }

    final title = _getIssueNotificationTitle(type, repo);
    final message = _getIssueNotificationMessage(type, issue);

    final notification = Notification(
      userId: repo.userId,
      type: type,
      title: title,
      message: message,
      repositoryId: repo.id!,
      issueId: issue.id,
      isRead: false,
      createdAt: DateTime.now(),
    );

    final created = await Notification.db.insertRow(session, notification);

    // Send push notification if enabled
    if (repo.pushNotifications && user.onesignalPlayerId != null) {
      await _sendPushNotification(user.onesignalPlayerId!, title, message);
    }

    return created;
  }

  /// Get notification title for PR events.
  String _getPrNotificationTitle(String type, Repository repo) {
    final repoName = '${repo.owner}/${repo.repo}';
    switch (type) {
      case 'pr_opened':
        return 'New PR in $repoName';
      case 'pr_updated':
        return 'PR updated in $repoName';
      case 'pr_merged':
        return 'PR merged in $repoName';
      case 'pr_closed':
        return 'PR closed in $repoName';
      default:
        return 'PR activity in $repoName';
    }
  }

  /// Get notification message for PR events.
  String _getPrNotificationMessage(String type, PullRequest pr) {
    final prTitle = pr.title;
    final prNumber = pr.number;
    switch (type) {
      case 'pr_opened':
        return '#$prNumber $prTitle was opened';
      case 'pr_updated':
        return '#$prNumber $prTitle was updated';
      case 'pr_merged':
        return '#$prNumber $prTitle was merged';
      case 'pr_closed':
        return '#$prNumber $prTitle was closed';
      default:
        return '#$prNumber $prTitle';
    }
  }

  /// Get notification title for issue events.
  String _getIssueNotificationTitle(String type, Repository repo) {
    final repoName = '${repo.owner}/${repo.repo}';
    switch (type) {
      case 'issue_opened':
        return 'New issue in $repoName';
      case 'issue_updated':
        return 'Issue updated in $repoName';
      case 'issue_closed':
        return 'Issue closed in $repoName';
      default:
        return 'Issue activity in $repoName';
    }
  }

  /// Get notification message for issue events.
  String _getIssueNotificationMessage(String type, Issue issue) {
    final issueTitle = issue.title;
    final issueNumber = issue.number;
    switch (type) {
      case 'issue_opened':
        return '#$issueNumber $issueTitle was opened';
      case 'issue_updated':
        return '#$issueNumber $issueTitle was updated';
      case 'issue_closed':
        return '#$issueNumber $issueTitle was closed';
      default:
        return '#$issueNumber $issueTitle';
    }
  }

  /// Send push notification via OneSignal.
  Future<void> _sendPushNotification(
    String playerId,
    String title,
    String message,
  ) async {
    if (_oneSignalService == null) {
      return;
    }
    await _oneSignalService!.sendPushNotification(playerId, title, message);
  }
}

/// Notification types for pull requests.
class PrNotificationType {
  static const String opened = 'pr_opened';
  static const String updated = 'pr_updated';
  static const String merged = 'pr_merged';
  static const String closed = 'pr_closed';
}

/// Notification types for issues.
class IssueNotificationType {
  static const String opened = 'issue_opened';
  static const String updated = 'issue_updated';
  static const String closed = 'issue_closed';
}
