import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

/// Custom auth key provider that uses SharedPreferences.
class AppAuthKeyProvider implements ClientAuthKeyProvider {
  final SharedPreferences _prefs;

  AppAuthKeyProvider(this._prefs);

  @override
  Future<String?> get authHeaderValue async {
    final token = _prefs.getString(StorageKeys.sessionToken);
    if (token == null) return null;
    return wrapAsBearerAuthHeaderValue(token);
  }
}

/// Serverpod client provider.
final clientProvider = Provider<Client>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final client = Client(ServerConfig.currentUrl)
    ..authKeyProvider = AppAuthKeyProvider(prefs)
    ..connectivityMonitor = FlutterConnectivityMonitor();

  ref.onDispose(() => client.close());

  return client;
});

/// SharedPreferences provider.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

/// Session token provider (reads from SharedPreferences).
final sessionTokenProvider = StateNotifierProvider<SessionTokenNotifier, String?>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SessionTokenNotifier(prefs);
});

/// Manages session token storage.
class SessionTokenNotifier extends StateNotifier<String?> {
  final SharedPreferences _prefs;

  SessionTokenNotifier(this._prefs) : super(_prefs.getString(StorageKeys.sessionToken));

  Future<void> setToken(String token) async {
    state = token;
    await _prefs.setString(StorageKeys.sessionToken, token);
  }

  Future<void> clearToken() async {
    state = null;
    await _prefs.remove(StorageKeys.sessionToken);
  }
}

/// Device ID provider (generates and persists a unique device ID).
final deviceIdProvider = Provider<String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  var deviceId = prefs.getString(StorageKeys.deviceId);

  if (deviceId == null) {
    deviceId = 'device-${DateTime.now().millisecondsSinceEpoch}';
    prefs.setString(StorageKeys.deviceId, deviceId);
  }

  return deviceId;
});
