import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';
import '../features/auth/auth_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/activity/activity_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/repositories/repositories_screen.dart';
import '../features/repositories/add_repository_screen.dart';
import '../features/settings/settings_screen.dart';
import '../shared/widgets/main_scaffold.dart';

/// Shell route keys for maintaining state.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Router provider.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.repositories,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isLoggingIn = state.matchedLocation == RoutePaths.login;

      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return RoutePaths.login;
      }

      // If logged in and on login page, redirect to home
      if (isLoggedIn && isLoggingIn) {
        return RoutePaths.repositories;
      }

      return null;
    },
    routes: [
      // Login (outside shell)
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          // Repositories tab
          GoRoute(
            path: RoutePaths.repositories,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RepositoriesScreen(),
            ),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const AddRepositoryScreen(),
              ),
            ],
          ),

          // Activity tab
          GoRoute(
            path: RoutePaths.activity,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ActivityScreen(),
            ),
          ),

          // Notifications tab
          GoRoute(
            path: RoutePaths.notifications,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NotificationsScreen(),
            ),
          ),

          // Settings tab
          GoRoute(
            path: RoutePaths.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
