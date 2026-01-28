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
