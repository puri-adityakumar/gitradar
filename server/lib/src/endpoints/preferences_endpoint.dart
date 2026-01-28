import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../util/session_util.dart';

/// Endpoint for managing user preferences.
class PreferencesEndpoint extends Endpoint {
  /// Get user preferences.
  /// Creates default preferences if none exist.
  Future<UserPreferences> getPreferences(Session session) async {
    final userId = SessionUtil.requireUserId(session);

    var preferences = await UserPreferences.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (preferences == null) {
      // Create default preferences
      final now = DateTime.now();
      preferences = await UserPreferences.db.insertRow(
        session,
        UserPreferences(
          userId: userId,
          themeMode: 'system',
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    return preferences;
  }

  /// Update user preferences.
  Future<UserPreferences> updatePreferences(
    Session session,
    String themeMode,
  ) async {
    final userId = SessionUtil.requireUserId(session);

    // Validate theme mode
    if (!['light', 'dark', 'system'].contains(themeMode)) {
      throw Exception('Invalid theme mode. Use "light", "dark", or "system"');
    }

    var preferences = await UserPreferences.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );

    final now = DateTime.now();

    if (preferences == null) {
      // Create with the specified theme
      preferences = await UserPreferences.db.insertRow(
        session,
        UserPreferences(
          userId: userId,
          themeMode: themeMode,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      // Update existing
      preferences.themeMode = themeMode;
      preferences.updatedAt = now;
      preferences = await UserPreferences.db.updateRow(session, preferences);
    }

    return preferences;
  }
}
