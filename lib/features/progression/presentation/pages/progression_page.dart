import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../resources/presentation/providers/resources_provider.dart';
import '../../../resources/presentation/widgets/resource_card.dart';
import '../../../resources/domain/entities/resource.dart';
import '../providers/progression_provider.dart';

class ProgressionPage extends StatefulWidget {
  const ProgressionPage({super.key});

  @override
  State<ProgressionPage> createState() => _ProgressionPageState();
}

class _ProgressionPageState extends State<ProgressionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ma Progression')),
        body: EmptyState(
          icon: Icons.lock_outline,
          title: 'Connexion requise',
          subtitle: 'Connectez-vous pour suivre votre progression',
          action: ElevatedButton(
            onPressed: () => context.go('/login'),
            child: const Text('Se connecter'),
          ),
        ),
      );
    }

    final progressionProvider = context.watch<ProgressionProvider>();
    final resourcesProvider = context.watch<ResourcesProvider>();
    final progression = progressionProvider.getProgression(user.id);

    final allResources = resourcesProvider.getFilteredResources();
    final favorites = allResources
        .where((r) => progression.favoriteResourceIds.contains(r.id))
        .toList();
    final exploited = allResources
        .where((r) => progression.exploitedResourceIds.contains(r.id))
        .toList();
    final saved = allResources
        .where((r) => progression.savedResourceIds.contains(r.id))
        .toList();
    final myResources = resourcesProvider.getResourcesByAuthor(user.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Ma Progression'),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppTheme.secondary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          tabs: [
            Tab(text: 'Favoris (${favorites.length})'),
            Tab(text: 'Sauvegardés (${saved.length})'),
            Tab(text: 'Exploités (${exploited.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Dashboard stats
          Container(
            color: AppTheme.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Column(
              children: [
                // Welcome
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppTheme.secondary.withOpacity(0.3),
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour, ${user.name.split(' ').first} !',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            user.roleLabel,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: StatBadge(
                        icon: Icons.favorite,
                        value: '${favorites.length}',
                        label: 'Favoris',
                        color: Colors.red.shade300,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatBadge(
                        icon: Icons.check_circle,
                        value: '${exploited.length}',
                        label: 'Exploités',
                        color: AppTheme.success,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatBadge(
                        icon: Icons.bookmark,
                        value: '${saved.length}',
                        label: 'Sauvegardés',
                        color: AppTheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatBadge(
                        icon: Icons.edit_note,
                        value: '${myResources.length}',
                        label: 'Créées',
                        color: AppTheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tabs content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _ResourceList(
                  resources: favorites,
                  emptyIcon: Icons.favorite_outline,
                  emptyTitle: 'Aucun favori',
                  emptySubtitle: 'Ajoutez des ressources à vos favoris',
                  userId: user.id,
                  progressionProvider: progressionProvider,
                  resourcesProvider: resourcesProvider,
                ),
                _ResourceList(
                  resources: saved,
                  emptyIcon: Icons.bookmark_outline,
                  emptyTitle: 'Aucune ressource sauvegardée',
                  emptySubtitle: 'Sauvegardez des ressources pour y revenir',
                  userId: user.id,
                  progressionProvider: progressionProvider,
                  resourcesProvider: resourcesProvider,
                ),
                _ResourceList(
                  resources: exploited,
                  emptyIcon: Icons.check_circle_outline,
                  emptyTitle: 'Aucune ressource exploitée',
                  emptySubtitle: 'Marquez les ressources comme vues',
                  userId: user.id,
                  progressionProvider: progressionProvider,
                  resourcesProvider: resourcesProvider,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceList extends StatelessWidget {
  final List<Resource> resources;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final String userId;
  final ProgressionProvider progressionProvider;
  final ResourcesProvider resourcesProvider;

  const _ResourceList({
    required this.resources,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.userId,
    required this.progressionProvider,
    required this.resourcesProvider,
  });

  @override
  Widget build(BuildContext context) {
    if (resources.isEmpty) {
      return EmptyState(
        icon: Icons.library_books_outlined,
        title: emptyTitle,
        subtitle: emptySubtitle,
        action: ElevatedButton(
          onPressed: () => context.go('/resources'),
          child: const Text('Explorer les ressources'),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final resource = resources[index];
        final category = resourcesProvider.getCategoryById(resource.categoryId);
        return ResourceCard(
          resource: resource,
          category: category,
          isFavorite: progressionProvider.isFavorite(userId, resource.id),
          isExploited: progressionProvider.isExploited(userId, resource.id),
          onTap: () => context.push('/resources/${resource.id}'),
          onFavoriteToggle: () =>
              progressionProvider.toggleFavorite(userId, resource.id),
        );
      },
    );
  }
}
