import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/profile_page.dart';
import '../../features/home/presentation/widgets/main_shell.dart';
import '../../features/progression/presentation/pages/progression_page.dart';
import '../../features/resources/presentation/pages/create_resource_page.dart';
import '../../features/resources/presentation/pages/resource_detail_page.dart';
import '../../features/resources/presentation/pages/resources_list_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final loc = state.matchedLocation;

      if (loc == '/splash') return null;

      final isPublic = loc == '/login' || loc == '/register';
      if (!isLoggedIn && !isPublic) return '/login';
      if (isLoggedIn && isPublic) return '/resources';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/resources',
                builder: (context, state) => const ResourcesListPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ResourceDetailPage(
                      resourceId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const CreateResourcePage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progression',
                builder: (context, state) => const ProgressionPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'statistics',
                    builder: (context, state) => const StatisticsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page introuvable : ${state.uri}'),
      ),
    ),
  );
}
