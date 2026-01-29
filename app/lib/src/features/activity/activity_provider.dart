import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';

import '../../core/client.dart';

/// Selected repository filter state (null = show all).
final selectedRepositoryProvider = StateProvider.autoDispose<int?>((ref) => null);

/// Activity counts provider.
final activityCountsProvider = FutureProvider.autoDispose<ActivityCounts>((ref) async {
  final client = ref.watch(clientProvider);
  return await client.activity.getCounts();
});

/// Pull requests provider with filter support.
final pullRequestsProvider = FutureProvider.autoDispose<PaginatedPullRequests>((ref) async {
  final client = ref.watch(clientProvider);
  final selectedRepoId = ref.watch(selectedRepositoryProvider);

  final filter = selectedRepoId != null
      ? PullRequestFilter(repositoryId: selectedRepoId)
      : null;

  return await client.activity.listPullRequests(filter, null);
});

/// Issues provider with filter support.
final issuesProvider = FutureProvider.autoDispose<PaginatedIssues>((ref) async {
  final client = ref.watch(clientProvider);
  final selectedRepoId = ref.watch(selectedRepositoryProvider);

  final filter = selectedRepoId != null
      ? IssueFilter(repositoryId: selectedRepoId)
      : null;

  return await client.activity.listIssues(filter, null);
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
