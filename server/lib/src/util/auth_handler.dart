import 'dart:convert';
import 'package:serverpod/serverpod.dart';

/// Custom authentication handler for GitRadar.
/// Decodes our session token format: base64(userId:timestamp)
Future<AuthenticationInfo?> authenticationHandler(
  Session session,
  String token,
) async {
  try {
    // Our token format is base64(userId:timestamp)
    // The token comes in as "Bearer <token>" format, but Serverpod
    // strips the "Bearer " prefix for us

    final decoded = utf8.decode(base64Decode(token));
    final parts = decoded.split(':');

    if (parts.length != 2) {
      return null;
    }

    final userId = int.tryParse(parts[0]);
    if (userId == null) {
      return null;
    }

    // Return authentication info with user ID
    // The userIdentifier is what session.authenticated?.userIdentifier returns
    // Note: userIdentifier is a String in Serverpod 3.x
    return AuthenticationInfo(
      userId.toString(),  // Convert to String
      <Scope>{},  // No specific scopes for now
      authId: token,  // Use token as authId
    );
  } catch (e) {
    // Invalid token format
    session.log('Auth handler error: $e', level: LogLevel.warning);
    return null;
  }
}
