import 'package:test/test.dart';
import 'package:gitradar_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_helper.dart';

void main() {
  withServerpod('PreferencesEndpoint', (sessionBuilder, endpoints) {
    group('getPreferences', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.preferences.getPreferences(sessionBuilder),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updatePreferences', () {
      test('should throw when not authenticated', () async {
        expect(
          () => endpoints.preferences.updatePreferences(sessionBuilder, 'dark'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });

  withServerpod('UserPreferences model', (sessionBuilder, endpoints) {
    test('should create preferences with default theme', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final now = DateTime.now();

      final prefs = await UserPreferences.db.insertRow(
        session,
        UserPreferences(
          userId: user.id!,
          themeMode: 'system',
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect(prefs.id, isNotNull);
      expect(prefs.themeMode, equals('system'));
      expect(prefs.userId, equals(user.id));
    });

    test('should update theme mode', () async {
      final session = sessionBuilder.build();
      final user = await createTestUser(session);
      final now = DateTime.now();

      var prefs = await UserPreferences.db.insertRow(
        session,
        UserPreferences(
          userId: user.id!,
          themeMode: 'system',
          createdAt: now,
          updatedAt: now,
        ),
      );

      prefs.themeMode = 'dark';
      prefs = await UserPreferences.db.updateRow(session, prefs);

      expect(prefs.themeMode, equals('dark'));
    });
  });
}
