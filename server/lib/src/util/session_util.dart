import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Utility for handling custom PAT-based authentication.
/// Since we don't use Serverpod's auth module, we handle auth via
/// the Serverpod authentication system.
///
/// In Serverpod 3, authentication is handled through:
/// 1. Client sends auth token via `authentication` in the MethodCall
/// 2. Server's authenticationHandler validates and sets session.authenticated
///
/// For MVP with custom PAT auth, we use session.authenticated.userIdentifier
/// which should be set by the custom auth handler.
class SessionUtil {
  /// Get the authenticated user ID from the session.
  /// Returns null if not authenticated.
  ///
  /// The userIdentifier is set by the server's authenticationHandler
  /// when the client sends a valid auth token.
  static int? getUserId(Session session) {
    // Try to get from Serverpod's authentication system
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier != null) {
      return int.tryParse(userIdentifier);
    }
    return null;
  }

  /// Get the authenticated user ID, throwing if not authenticated.
  static int requireUserId(Session session) {
    final userId = getUserId(session);
    if (userId == null) {
      throw Exception('Not authenticated. Please login first.');
    }
    return userId;
  }

  /// Get the full User object for the authenticated session.
  /// Returns null if not authenticated or user not found.
  static Future<User?> getUser(Session session) async {
    final userId = getUserId(session);
    if (userId == null) return null;
    return await User.db.findById(session, userId);
  }

  /// Get the full User object, throwing if not authenticated.
  static Future<User> requireUser(Session session) async {
    final userId = requireUserId(session);
    final user = await User.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }
    return user;
  }
}
