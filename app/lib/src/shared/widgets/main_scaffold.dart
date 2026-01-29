import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants.dart';
import '../../features/notifications/notifications_provider.dart';

/// Main scaffold with bottom navigation bar.
class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RoutePaths.repositories)) return 0;
    if (location.startsWith(RoutePaths.activity)) return 1;
    if (location.startsWith(RoutePaths.notifications)) return 2;
    if (location.startsWith(RoutePaths.settings)) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RoutePaths.repositories);
        break;
      case 1:
        context.go(RoutePaths.activity);
        break;
      case 2:
        context.go(RoutePaths.notifications);
        break;
      case 3:
        context.go(RoutePaths.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCountAsync = ref.watch(unreadCountProvider);
    final unreadCount = unreadCountAsync.valueOrNull ?? 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(context, index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined),
            activeIcon: Icon(Icons.folder),
            label: 'Repos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.timeline_outlined),
            activeIcon: Icon(Icons.timeline),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text(unreadCount > 9 ? '9+' : '$unreadCount'),
              child: const Icon(Icons.notifications_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text(unreadCount > 9 ? '9+' : '$unreadCount'),
              child: const Icon(Icons.notifications),
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
