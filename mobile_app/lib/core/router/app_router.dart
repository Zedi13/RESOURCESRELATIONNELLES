import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/profile_page.dart';
import '../../features/home/presentation/pages/about_page.dart';
import '../../features/home/presentation/pages/help_page.dart';
import '../../features/home/presentation/pages/users_management_page.dart';
import '../../features/resources/presentation/pages/categories_management_page.dart';
import '../../features/resources/presentation/pages/type_relations_management_page.dart';
import '../../features/home/presentation/widgets/main_shell.dart';
import '../../features/resources/domain/entities/resource.dart';
import '../../features/resources/presentation/pages/resources_list_page.dart';
import '../../features/resources/presentation/pages/resource_detail_page.dart';
import '../../features/resources/presentation/pages/create_resource_page.dart';
import '../../features/progression/presentation/pages/progression_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/moderation/presentation/pages/moderation_page.dart';
import '../../features/resources/presentation/pages/admin_resources_page.dart';
import '../../features/sessions/presentation/pages/session_page.dart';

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
                    path: 'new',
                    builder: (context, state) => const CreateResourcePage(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ResourceDetailPage(
                      resourceId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    builder: (context, state) => CreateResourcePage(
                      existingResource: state.extra as Resource?,
                    ),
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
                  GoRoute(
                    path: 'moderation',
                    builder: (context, state) => const ModerationPage(),
                  ),
                  GoRoute(
                    path: 'about',
                    builder: (context, state) => const AboutPage(),
                  ),
                  GoRoute(
                    path: 'help',
                    builder: (context, state) => const HelpPage(),
                  ),
                  GoRoute(
                    path: 'users',
                    builder: (context, state) =>
                        const UsersManagementPage(),
                  ),
                  GoRoute(
                    path: 'categories',
                    builder: (context, state) =>
                        const CategoriesManagementPage(),
                  ),
                  GoRoute(
                    path: 'type-relations',
                    builder: (context, state) =>
                        const TypeRelationsManagementPage(),
                  ),
                  GoRoute(
                    path: 'admin-resources',
                    builder: (context, state) => const AdminResourcesPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/sessions/:code',
        builder: (context, state) => SessionPage(
          code: state.pathParameters['code']!,
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page introuvable : ${state.uri}'),
      ),
    ),
  );
}
