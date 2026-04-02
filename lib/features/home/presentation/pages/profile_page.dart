import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/auth/domain/entities/user.dart';
import '../../../resources/presentation/providers/resources_provider.dart';
import '../../../resources/presentation/widgets/resource_card.dart';
import '../../../progression/presentation/providers/progression_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: EmptyState(
          icon: Icons.person_outline,
          title: 'Non connecté',
          subtitle: 'Connectez-vous pour accéder à votre profil',
          action: ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Se connecter'),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppTheme.primary,
            title: const Text('Mon Profil'),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.primary, Color(0xFF2D6A9F)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppTheme.secondary.withOpacity(0.3),
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              RoleBadge(
                                label: user.roleLabel,
                                color: _roleColor(user.role),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // My resources
                  _MyResourcesSection(userId: user.id),
                  const SizedBox(height: 24),
                  // Admin section
                  if (user.isAdmin || user.isModerator)
                    _AdminSection(user: user),
                  // Settings
                  const SectionTitle(title: 'Paramètres'),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        label: 'Notifications',
                        trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeColor: AppTheme.primary,
                        ),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.language,
                        label: 'Langue',
                        trailing: const Text('Français',
                            style: TextStyle(
                                color: AppTheme.textSecondary, fontSize: 13)),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Confidentialité & RGPD',
                        onTap: () {
                          _showRgpdDialog(context);
                        },
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.help_outline,
                        label: 'Aide & Support',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.info_outline,
                        label: 'À propos',
                        trailing: const Text('v1.0.0',
                            style: TextStyle(
                                color: AppTheme.textSecondary, fontSize: 12)),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        auth.logout();
                        context.go('/login');
                      },
                      icon: const Icon(Icons.logout, color: AppTheme.error),
                      label: const Text(
                        'Se déconnecter',
                        style: TextStyle(color: AppTheme.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: AppTheme.error.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.citizen:
        return AppTheme.tertiary;
      case UserRole.moderator:
        return AppTheme.warning;
      case UserRole.admin:
        return AppTheme.primary;
      case UserRole.superAdmin:
        return AppTheme.secondary;
    }
  }

  void _showRgpdDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Données personnelles (RGPD)'),
        content: const SingleChildScrollView(
          child: Text(
            'Conformément au RGPD, vos données sont traitées avec votre consentement et uniquement dans le cadre de la plateforme (RE)Sources Relationnelles.\n\n'
            'Vos données ne sont ni vendues ni partagées avec des tiers.\n\n'
            'Vous disposez d\'un droit d\'accès, de rectification, d\'effacement et de portabilité de vos données.\n\n'
            'Pour exercer ces droits, contactez : rgpd@ressources-relationnelles.fr',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

class _MyResourcesSection extends StatelessWidget {
  final String userId;

  const _MyResourcesSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = context.watch<ResourcesProvider>();
    final progressionProvider = context.watch<ProgressionProvider>();
    final myResources = resourcesProvider.getResourcesByAuthor(userId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'Mes ressources',
          trailing: TextButton.icon(
            onPressed: () => context.push('/resources/new'),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Créer', style: TextStyle(fontSize: 13)),
          ),
        ),
        const SizedBox(height: 12),
        if (myResources.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Center(
              child: Text(
                'Vous n\'avez pas encore créé de ressource.\nPartagez vos connaissances !',
                style: TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          ...myResources.map((r) {
            final cat = resourcesProvider.getCategoryById(r.categoryId);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ResourceCard(
                resource: r,
                category: cat,
                isFavorite: progressionProvider.isFavorite(userId, r.id),
                isExploited: progressionProvider.isExploited(userId, r.id),
                onTap: () => context.push('/resources/${r.id}'),
                onFavoriteToggle: () =>
                    progressionProvider.toggleFavorite(userId, r.id),
              ),
            );
          }),
      ],
    );
  }
}

class _AdminSection extends StatelessWidget {
  final user;

  const _AdminSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(title: 'Administration'),
        const SizedBox(height: 12),
        _SettingsCard(
          children: [
            if (user.isAdmin) ...[
              _SettingsTile(
                icon: Icons.bar_chart,
                label: 'Tableau de bord statistiques',
                iconColor: AppTheme.primary,
                onTap: () => context.push('/profile/statistics'),
              ),
              const Divider(height: 1),
            ],
            _SettingsTile(
              icon: Icons.rate_review_outlined,
              label: 'Modération des commentaires',
              iconColor: AppTheme.warning,
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '1 en attente',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              onTap: () {},
            ),
            if (user.isAdmin) ...[
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.people_outline,
                label: 'Gestion des utilisateurs',
                iconColor: AppTheme.tertiary,
                onTap: () {},
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.category_outlined,
                label: 'Gestion du catalogue',
                iconColor: AppTheme.success,
                onTap: () {},
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.textSecondary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 18,
          color: iconColor ?? AppTheme.textSecondary,
        ),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right,
                  color: AppTheme.textSecondary, size: 18)
              : null),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
