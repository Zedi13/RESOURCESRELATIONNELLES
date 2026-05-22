import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/auth/domain/entities/user.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell shell;

  const MainShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final showAdmin = user?.isAdmin == true || user?.isModerator == true;

    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTap: (index) => shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex,
        ),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'Ressources',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            activeIcon: Icon(Icons.show_chart),
            label: 'Progression',
          ),
          BottomNavigationBarItem(
            icon: showAdmin
                ? const Icon(Icons.manage_accounts_outlined)
                : const Icon(Icons.person_outline),
            activeIcon: showAdmin
                ? const Icon(Icons.manage_accounts)
                : const Icon(Icons.person),
            label: showAdmin ? 'Gestion' : 'Profil',
          ),
        ],
      ),
    );
  }
}
