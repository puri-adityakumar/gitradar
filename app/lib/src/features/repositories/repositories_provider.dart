import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';

import '../../core/client.dart';

/// Repositories list provider.
final repositoriesProvider = FutureProvider.autoDispose<List<Repository>>((ref) async {
  final client = ref.watch(clientProvider);
  return await client.repository.listRepositories();
});

/// Add repository state.
class AddRepositoryState {
  final bool isLoading;
  final String? error;
  final Repository? addedRepo;

  const AddRepositoryState({
    this.isLoading = false,
    this.error,
    this.addedRepo,
  });

  AddRepositoryState copyWith({
    bool? isLoading,
    String? error,
    Repository? addedRepo,
  }) {
    return AddRepositoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      addedRepo: addedRepo ?? this.addedRepo,
    );
  }
}

/// Add repository notifier.
final addRepositoryProvider =
    StateNotifierProvider.autoDispose<AddRepositoryNotifier, AddRepositoryState>((ref) {
  return AddRepositoryNotifier(ref);
});

class AddRepositoryNotifier extends StateNotifier<AddRepositoryState> {
  final Ref _ref;

  AddRepositoryNotifier(this._ref) : super(const AddRepositoryState());

  Future<bool> addRepository(String owner, String repo) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final client = _ref.read(clientProvider);
      final addedRepo = await client.repository.addRepository(owner, repo);

      state = AddRepositoryState(addedRepo: addedRepo);

      // Invalidate repositories list to refresh
      _ref.invalidate(repositoriesProvider);

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

/// Delete repository provider.
final deleteRepositoryProvider = Provider.autoDispose<Future<void> Function(int)>((ref) {
  return (int repositoryId) async {
    final client = ref.read(clientProvider);
    await client.repository.removeRepository(repositoryId);
    ref.invalidate(repositoriesProvider);
  };
});

/// Sync state for tracking sync progress.
class SyncState {
  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final String? error;

  const SyncState({
    this.isSyncing = false,
    this.lastSyncedAt,
    this.error,
  });

  SyncState copyWith({
    bool? isSyncing,
    DateTime? lastSyncedAt,
    String? error,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      error: error,
    );
  }
}

/// Sync provider for manual sync functionality.
final syncProvider = StateNotifierProvider.autoDispose<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref);
});

class SyncNotifier extends StateNotifier<SyncState> {
  final Ref _ref;

  SyncNotifier(this._ref) : super(const SyncState());

  Future<void> sync() async {
    if (state.isSyncing) return;

    state = state.copyWith(isSyncing: true, error: null);

    try {
      final client = _ref.read(clientProvider);
      await client.repository.syncRepositories();

      state = SyncState(
        isSyncing: false,
        lastSyncedAt: DateTime.now(),
      );

      // Invalidate all data providers to refresh
      _ref.invalidate(repositoriesProvider);
    } catch (e) {
      state = state.copyWith(isSyncing: false, error: e.toString());
    }
  }
}
