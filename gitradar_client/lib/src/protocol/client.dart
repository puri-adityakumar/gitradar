/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:gitradar_client/src/protocol/paginated_pull_requests.dart'
    as _i3;
import 'package:gitradar_client/src/protocol/pull_request_filter.dart' as _i4;
import 'package:gitradar_client/src/protocol/paginated_issues.dart' as _i5;
import 'package:gitradar_client/src/protocol/issue_filter.dart' as _i6;
import 'package:gitradar_client/src/protocol/activity_counts.dart' as _i7;
import 'package:gitradar_client/src/protocol/auth_response.dart' as _i8;
import 'package:gitradar_client/src/protocol/user.dart' as _i9;
import 'package:gitradar_client/src/protocol/paginated_notifications.dart'
    as _i10;
import 'package:gitradar_client/src/protocol/user_preferences.dart' as _i11;
import 'package:gitradar_client/src/protocol/repository.dart' as _i12;
import 'protocol.dart' as _i13;

/// Endpoint for viewing pull requests and issues across all watched repositories.
/// {@category Endpoint}
class EndpointActivity extends _i1.EndpointRef {
  EndpointActivity(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'activity';

  /// List pull requests with optional filtering and cursor-based pagination.
  _i2.Future<_i3.PaginatedPullRequests> listPullRequests(
    _i4.PullRequestFilter? filter,
    String? cursor,
  ) => caller.callServerEndpoint<_i3.PaginatedPullRequests>(
    'activity',
    'listPullRequests',
    {
      'filter': filter,
      'cursor': cursor,
    },
  );

  /// List issues with optional filtering and cursor-based pagination.
  _i2.Future<_i5.PaginatedIssues> listIssues(
    _i6.IssueFilter? filter,
    String? cursor,
  ) => caller.callServerEndpoint<_i5.PaginatedIssues>(
    'activity',
    'listIssues',
    {
      'filter': filter,
      'cursor': cursor,
    },
  );

  /// Mark a pull request or issue as read.
  _i2.Future<void> markAsRead(
    String entityType,
    int entityId,
  ) => caller.callServerEndpoint<void>(
    'activity',
    'markAsRead',
    {
      'entityType': entityType,
      'entityId': entityId,
    },
  );

  /// Get counts of open PRs, open issues, and unread notifications.
  _i2.Future<_i7.ActivityCounts> getCounts() =>
      caller.callServerEndpoint<_i7.ActivityCounts>(
        'activity',
        'getCounts',
        {},
      );
}

/// Authentication endpoint using GitHub PAT (optional).
/// Supports both authenticated (with PAT) and anonymous (public repos only) modes.
/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Validates PAT against GitHub API, creates/updates user, returns session token.
  /// Use this for full access (private repos, higher rate limits).
  _i2.Future<_i8.AuthResponse> login(String githubPat) =>
      caller.callServerEndpoint<_i8.AuthResponse>(
        'auth',
        'login',
        {'githubPat': githubPat},
      );

  /// Creates an anonymous user for tracking public repos only.
  /// Rate limit: 60 requests/hour (vs 5000/hour with PAT).
  /// Can be upgraded to full account later by calling login() with PAT.
  _i2.Future<_i8.AuthResponse> loginAnonymous(String deviceId) =>
      caller.callServerEndpoint<_i8.AuthResponse>(
        'auth',
        'loginAnonymous',
        {'deviceId': deviceId},
      );

  /// Upgrades an anonymous user to authenticated by adding GitHub PAT.
  _i2.Future<_i8.AuthResponse> upgradeWithPat(String githubPat) =>
      caller.callServerEndpoint<_i8.AuthResponse>(
        'auth',
        'upgradeWithPat',
        {'githubPat': githubPat},
      );

  /// Validates current session and refreshes user data from GitHub.
  /// Only works for authenticated (non-anonymous) users.
  _i2.Future<_i9.User> validateSession() => caller.callServerEndpoint<_i9.User>(
    'auth',
    'validateSession',
    {},
  );

  /// Logs out user by invalidating session.
  _i2.Future<void> logout() => caller.callServerEndpoint<void>(
    'auth',
    'logout',
    {},
  );

  /// Registers OneSignal player ID for push notifications.
  _i2.Future<void> registerPushToken(String onesignalPlayerId) =>
      caller.callServerEndpoint<void>(
        'auth',
        'registerPushToken',
        {'onesignalPlayerId': onesignalPlayerId},
      );

  /// Check if user has PAT (can access private repos).
  _i2.Future<bool> hasPat() => caller.callServerEndpoint<bool>(
    'auth',
    'hasPat',
    {},
  );
}

/// Endpoint for managing in-app notifications.
/// {@category Endpoint}
class EndpointNotification extends _i1.EndpointRef {
  EndpointNotification(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  /// List notifications with cursor-based pagination.
  /// Returns newest first.
  _i2.Future<_i10.PaginatedNotifications> listNotifications(String? cursor) =>
      caller.callServerEndpoint<_i10.PaginatedNotifications>(
        'notification',
        'listNotifications',
        {'cursor': cursor},
      );

  /// Mark a single notification as read.
  _i2.Future<void> markRead(int notificationId) =>
      caller.callServerEndpoint<void>(
        'notification',
        'markRead',
        {'notificationId': notificationId},
      );

  /// Mark all notifications as read for the current user.
  _i2.Future<void> markAllRead() => caller.callServerEndpoint<void>(
    'notification',
    'markAllRead',
    {},
  );

  /// Get count of unread notifications.
  _i2.Future<int> getUnreadCount() => caller.callServerEndpoint<int>(
    'notification',
    'getUnreadCount',
    {},
  );
}

/// Endpoint for managing user preferences.
/// {@category Endpoint}
class EndpointPreferences extends _i1.EndpointRef {
  EndpointPreferences(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'preferences';

  /// Get user preferences.
  /// Creates default preferences if none exist.
  _i2.Future<_i11.UserPreferences> getPreferences() =>
      caller.callServerEndpoint<_i11.UserPreferences>(
        'preferences',
        'getPreferences',
        {},
      );

  /// Update user preferences.
  _i2.Future<_i11.UserPreferences> updatePreferences(String themeMode) =>
      caller.callServerEndpoint<_i11.UserPreferences>(
        'preferences',
        'updatePreferences',
        {'themeMode': themeMode},
      );
}

/// Endpoint for managing watched GitHub repositories.
/// Supports both authenticated (with PAT) and anonymous users.
/// Anonymous users can only track public repositories.
/// {@category Endpoint}
class EndpointRepository extends _i1.EndpointRef {
  EndpointRepository(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'repository';

  /// Add a repository to the user's watchlist.
  /// Anonymous users can only add public repositories.
  _i2.Future<_i12.Repository> addRepository(
    String owner,
    String repo,
  ) => caller.callServerEndpoint<_i12.Repository>(
    'repository',
    'addRepository',
    {
      'owner': owner,
      'repo': repo,
    },
  );

  /// List all repositories for the current user.
  _i2.Future<List<_i12.Repository>> listRepositories() =>
      caller.callServerEndpoint<List<_i12.Repository>>(
        'repository',
        'listRepositories',
        {},
      );

  /// Remove a repository from the user's watchlist.
  /// Also deletes associated PRs, Issues, and Notifications.
  _i2.Future<void> removeRepository(int repositoryId) =>
      caller.callServerEndpoint<void>(
        'repository',
        'removeRepository',
        {'repositoryId': repositoryId},
      );

  /// Update notification settings for a repository.
  _i2.Future<_i12.Repository> updateNotificationSettings(
    int repositoryId,
    bool inAppNotifications,
    bool pushNotifications,
    String notificationLevel,
  ) => caller.callServerEndpoint<_i12.Repository>(
    'repository',
    'updateNotificationSettings',
    {
      'repositoryId': repositoryId,
      'inAppNotifications': inAppNotifications,
      'pushNotifications': pushNotifications,
      'notificationLevel': notificationLevel,
    },
  );

  /// Check if a repository can be accessed by the user.
  /// Returns repository info if accessible, throws if not.
  _i2.Future<Map<String, dynamic>> checkRepositoryAccess(
    String owner,
    String repo,
  ) => caller.callServerEndpoint<Map<String, dynamic>>(
    'repository',
    'checkRepositoryAccess',
    {
      'owner': owner,
      'repo': repo,
    },
  );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i13.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    activity = EndpointActivity(this);
    auth = EndpointAuth(this);
    notification = EndpointNotification(this);
    preferences = EndpointPreferences(this);
    repository = EndpointRepository(this);
  }

  late final EndpointActivity activity;

  late final EndpointAuth auth;

  late final EndpointNotification notification;

  late final EndpointPreferences preferences;

  late final EndpointRepository repository;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'activity': activity,
    'auth': auth,
    'notification': notification,
    'preferences': preferences,
    'repository': repository,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
