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
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/activity_endpoint.dart' as _i2;
import '../endpoints/auth_endpoint.dart' as _i3;
import '../endpoints/notification_endpoint.dart' as _i4;
import '../endpoints/preferences_endpoint.dart' as _i5;
import '../endpoints/repository_endpoint.dart' as _i6;
import 'package:gitradar_server/src/generated/pull_request_filter.dart' as _i7;
import 'package:gitradar_server/src/generated/issue_filter.dart' as _i8;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'activity': _i2.ActivityEndpoint()
        ..initialize(
          server,
          'activity',
          null,
        ),
      'auth': _i3.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'notification': _i4.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'preferences': _i5.PreferencesEndpoint()
        ..initialize(
          server,
          'preferences',
          null,
        ),
      'repository': _i6.RepositoryEndpoint()
        ..initialize(
          server,
          'repository',
          null,
        ),
    };
    connectors['activity'] = _i1.EndpointConnector(
      name: 'activity',
      endpoint: endpoints['activity']!,
      methodConnectors: {
        'listPullRequests': _i1.MethodConnector(
          name: 'listPullRequests',
          params: {
            'filter': _i1.ParameterDescription(
              name: 'filter',
              type: _i1.getType<_i7.PullRequestFilter?>(),
              nullable: true,
            ),
            'cursor': _i1.ParameterDescription(
              name: 'cursor',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i2.ActivityEndpoint)
                  .listPullRequests(
                    session,
                    params['filter'],
                    params['cursor'],
                  ),
        ),
        'listIssues': _i1.MethodConnector(
          name: 'listIssues',
          params: {
            'filter': _i1.ParameterDescription(
              name: 'filter',
              type: _i1.getType<_i8.IssueFilter?>(),
              nullable: true,
            ),
            'cursor': _i1.ParameterDescription(
              name: 'cursor',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['activity'] as _i2.ActivityEndpoint).listIssues(
                    session,
                    params['filter'],
                    params['cursor'],
                  ),
        ),
        'markAsRead': _i1.MethodConnector(
          name: 'markAsRead',
          params: {
            'entityType': _i1.ParameterDescription(
              name: 'entityType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'entityId': _i1.ParameterDescription(
              name: 'entityId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['activity'] as _i2.ActivityEndpoint).markAsRead(
                    session,
                    params['entityType'],
                    params['entityId'],
                  ),
        ),
        'getCounts': _i1.MethodConnector(
          name: 'getCounts',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _i2.ActivityEndpoint)
                  .getCounts(session),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'githubPat': _i1.ParameterDescription(
              name: 'githubPat',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i3.AuthEndpoint).login(
                session,
                params['githubPat'],
              ),
        ),
        'loginAnonymous': _i1.MethodConnector(
          name: 'loginAnonymous',
          params: {
            'deviceId': _i1.ParameterDescription(
              name: 'deviceId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i3.AuthEndpoint).loginAnonymous(
                session,
                params['deviceId'],
              ),
        ),
        'upgradeWithPat': _i1.MethodConnector(
          name: 'upgradeWithPat',
          params: {
            'githubPat': _i1.ParameterDescription(
              name: 'githubPat',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i3.AuthEndpoint).upgradeWithPat(
                session,
                params['githubPat'],
              ),
        ),
        'validateSession': _i1.MethodConnector(
          name: 'validateSession',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i3.AuthEndpoint)
                  .validateSession(session),
        ),
        'logout': _i1.MethodConnector(
          name: 'logout',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i3.AuthEndpoint).logout(session),
        ),
        'registerPushToken': _i1.MethodConnector(
          name: 'registerPushToken',
          params: {
            'onesignalPlayerId': _i1.ParameterDescription(
              name: 'onesignalPlayerId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i3.AuthEndpoint).registerPushToken(
                    session,
                    params['onesignalPlayerId'],
                  ),
        ),
        'hasPat': _i1.MethodConnector(
          name: 'hasPat',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i3.AuthEndpoint).hasPat(session),
        ),
      },
    );
    connectors['notification'] = _i1.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'listNotifications': _i1.MethodConnector(
          name: 'listNotifications',
          params: {
            'cursor': _i1.ParameterDescription(
              name: 'cursor',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i4.NotificationEndpoint)
                  .listNotifications(
                    session,
                    params['cursor'],
                  ),
        ),
        'markRead': _i1.MethodConnector(
          name: 'markRead',
          params: {
            'notificationId': _i1.ParameterDescription(
              name: 'notificationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i4.NotificationEndpoint)
                  .markRead(
                    session,
                    params['notificationId'],
                  ),
        ),
        'markAllRead': _i1.MethodConnector(
          name: 'markAllRead',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i4.NotificationEndpoint)
                  .markAllRead(session),
        ),
        'getUnreadCount': _i1.MethodConnector(
          name: 'getUnreadCount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notification'] as _i4.NotificationEndpoint)
                  .getUnreadCount(session),
        ),
      },
    );
    connectors['preferences'] = _i1.EndpointConnector(
      name: 'preferences',
      endpoint: endpoints['preferences']!,
      methodConnectors: {
        'getPreferences': _i1.MethodConnector(
          name: 'getPreferences',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['preferences'] as _i5.PreferencesEndpoint)
                  .getPreferences(session),
        ),
        'updatePreferences': _i1.MethodConnector(
          name: 'updatePreferences',
          params: {
            'themeMode': _i1.ParameterDescription(
              name: 'themeMode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['preferences'] as _i5.PreferencesEndpoint)
                  .updatePreferences(
                    session,
                    params['themeMode'],
                  ),
        ),
      },
    );
    connectors['repository'] = _i1.EndpointConnector(
      name: 'repository',
      endpoint: endpoints['repository']!,
      methodConnectors: {
        'addRepository': _i1.MethodConnector(
          name: 'addRepository',
          params: {
            'owner': _i1.ParameterDescription(
              name: 'owner',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'repo': _i1.ParameterDescription(
              name: 'repo',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i6.RepositoryEndpoint)
                  .addRepository(
                    session,
                    params['owner'],
                    params['repo'],
                  ),
        ),
        'listRepositories': _i1.MethodConnector(
          name: 'listRepositories',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i6.RepositoryEndpoint)
                  .listRepositories(session),
        ),
        'removeRepository': _i1.MethodConnector(
          name: 'removeRepository',
          params: {
            'repositoryId': _i1.ParameterDescription(
              name: 'repositoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i6.RepositoryEndpoint)
                  .removeRepository(
                    session,
                    params['repositoryId'],
                  ),
        ),
        'updateNotificationSettings': _i1.MethodConnector(
          name: 'updateNotificationSettings',
          params: {
            'repositoryId': _i1.ParameterDescription(
              name: 'repositoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'inAppNotifications': _i1.ParameterDescription(
              name: 'inAppNotifications',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'pushNotifications': _i1.ParameterDescription(
              name: 'pushNotifications',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'notificationLevel': _i1.ParameterDescription(
              name: 'notificationLevel',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i6.RepositoryEndpoint)
                  .updateNotificationSettings(
                    session,
                    params['repositoryId'],
                    params['inAppNotifications'],
                    params['pushNotifications'],
                    params['notificationLevel'],
                  ),
        ),
        'checkRepositoryAccess': _i1.MethodConnector(
          name: 'checkRepositoryAccess',
          params: {
            'owner': _i1.ParameterDescription(
              name: 'owner',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'repo': _i1.ParameterDescription(
              name: 'repo',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i6.RepositoryEndpoint)
                  .checkRepositoryAccess(
                    session,
                    params['owner'],
                    params['repo'],
                  ),
        ),
        'syncRepositories': _i1.MethodConnector(
          name: 'syncRepositories',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['repository'] as _i6.RepositoryEndpoint)
                  .syncRepositories(session),
        ),
      },
    );
  }
}
