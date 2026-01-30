import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;

import '../generated/protocol.dart';
import '../services/encryption_service.dart';
import '../util/session_util.dart';

/// Authentication endpoint using GitHub PAT (optional).
/// Supports both authenticated (with PAT) and anonymous (public repos only) modes.
class AuthEndpoint extends Endpoint {

  /// Validates PAT against GitHub API, creates/updates user, returns session token.
  /// Use this for full access (private repos, higher rate limits).
  Future<AuthResponse> login(Session session, String githubPat) async {
    // Validate PAT against GitHub API
    final response = await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'Bearer $githubPat',
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'GitRadar',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Invalid GitHub token');
    }

    final githubUser = jsonDecode(response.body) as Map<String, dynamic>;

    final githubId = githubUser['id'] as int;
    final githubUsername = githubUser['login'] as String;
    final displayName = githubUser['name'] as String?;
    final avatarUrl = githubUser['avatar_url'] as String?;

    // Encrypt the PAT for storage
    final encryptedPat = EncryptionService.encrypt(githubPat);

    // Check if user exists (by GitHub ID)
    var existingUser = await User.db.findFirstRow(
      session,
      where: (t) => t.githubId.equals(githubId),
    );

    User user;
    final now = DateTime.now();

    if (existingUser != null) {
      // Update existing user
      existingUser.githubUsername = githubUsername;
      existingUser.displayName = displayName;
      existingUser.avatarUrl = avatarUrl;
      existingUser.encryptedPat = encryptedPat;
      existingUser.isAnonymous = false;
      existingUser.lastValidatedAt = now;
      existingUser.updatedAt = now;

      user = await User.db.updateRow(session, existingUser);
    } else {
      // Create new user
      user = await User.db.insertRow(
        session,
        User(
          githubId: githubId,
          githubUsername: githubUsername,
          displayName: displayName,
          avatarUrl: avatarUrl,
          encryptedPat: encryptedPat,
          isAnonymous: false,
          lastValidatedAt: now,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    // Generate session token
    final sessionToken =
        base64Encode(utf8.encode('${user.id}:${now.millisecondsSinceEpoch}'));

    return AuthResponse(
      sessionToken: sessionToken,
      user: user,
    );
  }

  /// Creates an anonymous user for tracking public repos only.
  /// Rate limit: 60 requests/hour (vs 5000/hour with PAT).
  /// Can be upgraded to full account later by calling login() with PAT.
  Future<AuthResponse> loginAnonymous(Session session, String deviceId) async {
    if (deviceId.isEmpty) {
      throw Exception('Device ID is required for anonymous login');
    }

    // Check if anonymous user already exists for this device
    var existingUser = await User.db.findFirstRow(
      session,
      where: (t) => t.deviceId.equals(deviceId),
    );

    User user;
    final now = DateTime.now();

    if (existingUser != null) {
      // Update last access time
      existingUser.updatedAt = now;
      user = await User.db.updateRow(session, existingUser);
    } else {
      // Create new anonymous user
      user = await User.db.insertRow(
        session,
        User(
          deviceId: deviceId,
          isAnonymous: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    // Generate session token
    final sessionToken =
        base64Encode(utf8.encode('${user.id}:${now.millisecondsSinceEpoch}'));

    return AuthResponse(
      sessionToken: sessionToken,
      user: user,
    );
  }

  /// Upgrades an anonymous user to authenticated by adding GitHub PAT.
  Future<AuthResponse> upgradeWithPat(Session session, String githubPat) async {
    final userId = SessionUtil.requireUserId(session);

    final existingUser = await User.db.findById(session, userId);
    if (existingUser == null) {
      throw Exception('User not found');
    }

    // Validate PAT against GitHub API
    final response = await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'Bearer $githubPat',
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'GitRadar',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Invalid GitHub token');
    }

    final githubUser = jsonDecode(response.body) as Map<String, dynamic>;
    final now = DateTime.now();

    // Encrypt the PAT
    final encryptedPat = EncryptionService.encrypt(githubPat);

    // Update user with GitHub info
    existingUser.githubId = githubUser['id'] as int;
    existingUser.githubUsername = githubUser['login'] as String;
    existingUser.displayName = githubUser['name'] as String?;
    existingUser.avatarUrl = githubUser['avatar_url'] as String?;
    existingUser.encryptedPat = encryptedPat;
    existingUser.isAnonymous = false;
    existingUser.lastValidatedAt = now;
    existingUser.updatedAt = now;

    final user = await User.db.updateRow(session, existingUser);

    final sessionToken =
        base64Encode(utf8.encode('${user.id}:${now.millisecondsSinceEpoch}'));

    return AuthResponse(
      sessionToken: sessionToken,
      user: user,
    );
  }

  /// Validates current session and refreshes user data from GitHub.
  /// Only works for authenticated (non-anonymous) users.
  Future<User> validateSession(Session session) async {
    final userId = SessionUtil.requireUserId(session);

    final user = await User.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }

    // Anonymous users don't need GitHub validation
    if (user.isAnonymous || user.encryptedPat == null) {
      user.updatedAt = DateTime.now();
      return await User.db.updateRow(session, user);
    }

    // Decrypt PAT and re-validate with GitHub
    final pat = EncryptionService.decrypt(user.encryptedPat!);

    final response = await http.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'Bearer $pat',
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'GitRadar',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('GitHub token is no longer valid');
    }

    final githubUser = jsonDecode(response.body) as Map<String, dynamic>;

    // Update user data
    user.githubUsername = githubUser['login'] as String;
    user.displayName = githubUser['name'] as String?;
    user.avatarUrl = githubUser['avatar_url'] as String?;
    user.lastValidatedAt = DateTime.now();
    user.updatedAt = DateTime.now();

    return await User.db.updateRow(session, user);
  }

  /// Logs out user by invalidating session.
  Future<void> logout(Session session) async {
    // In a production app, you would invalidate the session token here
    // For MVP, the client just discards the token
  }

  /// Registers OneSignal player ID for push notifications.
  Future<void> registerPushToken(
      Session session, String onesignalPlayerId) async {
    final userId = SessionUtil.requireUserId(session);

    final user = await User.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }

    user.onesignalPlayerId = onesignalPlayerId;
    user.updatedAt = DateTime.now();

    await User.db.updateRow(session, user);
  }

  /// Check if user has PAT (can access private repos).
  Future<bool> hasPat(Session session) async {
    final userId = SessionUtil.getUserId(session);
    if (userId == null) {
      return false;
    }

    final user = await User.db.findById(session, userId);
    return user?.encryptedPat != null;
  }
}
