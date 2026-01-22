import 'package:serverpod/serverpod.dart';

import '../services/sync_service.dart';

/// Future Call for periodic repository synchronization.
/// Syncs all repositories and reschedules itself for the next interval.
class RepositorySyncFutureCall extends FutureCall<void> {
  /// Sync interval in minutes.
  static const int syncIntervalMinutes = 5;

  @override
  Future<void> invoke(Session session, void object) async {
    session.log('Starting scheduled repository sync', level: LogLevel.info);

    final syncService = SyncService();

    try {
      final results = await syncService.syncAllRepositories(session);

      // Calculate totals
      var totalNewPrs = 0;
      var totalUpdatedPrs = 0;
      var totalNewIssues = 0;
      var totalUpdatedIssues = 0;
      var totalNotifications = 0;

      for (final result in results) {
        totalNewPrs += result.newPullRequests;
        totalUpdatedPrs += result.updatedPullRequests;
        totalNewIssues += result.newIssues;
        totalUpdatedIssues += result.updatedIssues;
        totalNotifications += result.notificationsCreated;
      }

      session.log(
        'Sync completed: ${results.length} repos, '
        '$totalNewPrs new PRs, $totalUpdatedPrs updated PRs, '
        '$totalNewIssues new issues, $totalUpdatedIssues updated issues, '
        '$totalNotifications notifications',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      session.log(
        'Sync failed with error: $e\n$stackTrace',
        level: LogLevel.error,
      );
    }

    // Reschedule for next interval
    await session.futureCallWithDelay(
      'repositorySync',
      null,
      Duration(minutes: syncIntervalMinutes),
    );

    session.log(
      'Next sync scheduled in $syncIntervalMinutes minutes',
      level: LogLevel.info,
    );
  }
}
