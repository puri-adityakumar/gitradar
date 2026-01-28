import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gitradar_client/gitradar_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/client.dart';
import '../../core/constants.dart';

/// Theme mode provider.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeNotifier(this._prefs) : super(_loadThemeMode(_prefs));

  static ThemeMode _loadThemeMode(SharedPreferences prefs) {
    final value = prefs.getString(StorageKeys.themeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(StorageKeys.themeMode, value);

    // Also sync to server if logged in
    // try {
    //   await _client.preferences.updatePreferences(value);
    // } catch (_) {}
  }
}

/// User preferences provider.
final userPreferencesProvider = FutureProvider.autoDispose<UserPreferences>((ref) async {
  final client = ref.watch(clientProvider);
  return await client.preferences.getPreferences();
});
