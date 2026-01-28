import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/client.dart';
import '../../core/constants.dart';

/// Authentication state.
class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Auth state provider.
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

/// Auth notifier that manages authentication state.
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState());

  Client get _client => _ref.read(clientProvider);
  SharedPreferences get _prefs => _ref.read(sharedPreferencesProvider);

  /// Initialize auth state from stored session.
  Future<void> initialize() async {
    final userId = _prefs.getInt(StorageKeys.userId);
    if (userId != null) {
      // We have a stored user ID, try to validate session
      try {
        state = state.copyWith(isLoading: true);
        final user = await _client.auth.validateSession();
        state = AuthState(user: user);
      } catch (e) {
        // Session invalid, clear storage
        await _clearStorage();
        state = const AuthState();
      }
    }
  }

  /// Login anonymously with device ID.
  Future<void> loginAnonymous() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final deviceId = _ref.read(deviceIdProvider);
      final response = await _client.auth.loginAnonymous(deviceId);

      // Store session info
      await _prefs.setString(StorageKeys.sessionToken, response.sessionToken);
      await _prefs.setInt(StorageKeys.userId, response.user.id!);

      state = AuthState(user: response.user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Login with GitHub PAT.
  Future<void> loginWithPat(String pat) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _client.auth.login(pat);

      // Store session info
      await _prefs.setString(StorageKeys.sessionToken, response.sessionToken);
      await _prefs.setInt(StorageKeys.userId, response.user.id!);

      state = AuthState(user: response.user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Upgrade anonymous account with PAT.
  Future<void> upgradeWithPat(String pat) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await _client.auth.upgradeWithPat(pat);

      // Update session token
      await _prefs.setString(StorageKeys.sessionToken, response.sessionToken);

      state = AuthState(user: response.user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Logout.
  Future<void> logout() async {
    try {
      await _client.auth.logout();
    } catch (e) {
      // Ignore logout errors
    }

    await _clearStorage();
    state = const AuthState();
  }

  Future<void> _clearStorage() async {
    await _prefs.remove(StorageKeys.sessionToken);
    await _prefs.remove(StorageKeys.userId);
  }
}
