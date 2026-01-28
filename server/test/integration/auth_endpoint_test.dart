import 'package:test/test.dart';
import 'package:gitradar_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';
import 'test_helper.dart';

void main() {
  withServerpod('AuthEndpoint', (sessionBuilder, endpoints) {
    group('loginAnonymous', () {
      test('should create new anonymous user with device ID', () async {
        final deviceId = 'test-device-${DateTime.now().millisecondsSinceEpoch}';

        final response = await endpoints.auth.loginAnonymous(sessionBuilder, deviceId);

        expect(response.user, isNotNull);
        expect(response.user.isAnonymous, isTrue);
        expect(response.user.deviceId, equals(deviceId));
        expect(response.sessionToken, isNotEmpty);
      });

      test('should return existing user for same device ID', () async {
        final deviceId = 'test-device-existing-${DateTime.now().millisecondsSinceEpoch}';

        // First login
        final response1 = await endpoints.auth.loginAnonymous(sessionBuilder, deviceId);
        final userId1 = response1.user.id;

        // Second login with same device ID
        final response2 = await endpoints.auth.loginAnonymous(sessionBuilder, deviceId);
        final userId2 = response2.user.id;

        expect(userId2, equals(userId1));
      });

      test('should throw on empty device ID', () async {
        expect(
          () => endpoints.auth.loginAnonymous(sessionBuilder, ''),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('hasPat', () {
      test('should return false for unauthenticated session', () async {
        final result = await endpoints.auth.hasPat(sessionBuilder);
        expect(result, isFalse);
      });
    });

    group('logout', () {
      test('should complete without error', () async {
        // Logout is a no-op for MVP, just verify it doesn't throw
        await endpoints.auth.logout(sessionBuilder);
      });
    });
  });
}
