import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/analytics/presentation/analytics_page.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/sessions/presentation/sessions_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../widgets/app_navigation_shell.dart';

const String _dashboardPath = '/dashboard';
const String _sessionsPath = '/sessions';
const String _analysisPath = '/analysis';
const String _settingsPath = '/settings';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _dashboardNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'dashboard',
);
final _sessionsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'sessions');
final _analysisNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'analysis');
final _settingsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'settings');

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: _dashboardPath,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppNavigationShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: _dashboardPath,
                name: 'dashboard',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: DashboardPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _sessionsNavigatorKey,
            routes: [
              GoRoute(
                path: _sessionsPath,
                name: 'sessions',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SessionsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _analysisNavigatorKey,
            routes: [
              GoRoute(
                path: _analysisPath,
                name: 'analysis',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: AnalyticsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: _settingsPath,
                name: 'settings',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsPage()),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});
