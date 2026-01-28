import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';

import '../../core/client.dart';

/// Activity counts provider.
final activityCountsProvider = FutureProvider.autoDispose<ActivityCounts>((ref) async {
  final client = ref.watch(clientProvider);
  return await client.activity.getCounts();
});

/// Pull requests provider.
final pullRequestsProvider = FutureProvider.autoDispose<PaginatedPullRequests>((ref) async {
  final client = ref.watch(clientProvider);
  return await client.activity.listPullRequests(null, null);
});

/// Issues provider.
final issuesProvider = FutureProvider.autoDispose<PaginatedIssues>((ref) async {
  final client = ref.watch(clientProvider);
  return await client.activity.listIssues(null, null);
});

/// Mark as read provider.
final markAsReadProvider = Provider.autoDispose<Future<void> Function(String, int)>((ref) {
  return (String entityType, int entityId) async {
    final client = ref.read(clientProvider);
    await client.activity.markAsRead(entityType, entityId);

    // Refresh the appropriate list
    if (entityType == 'pr') {
      ref.invalidate(pullRequestsProvider);
    } else {
      ref.invalidate(issuesProvider);
    }
    ref.invalidate(activityCountsProvider);
  };
});
