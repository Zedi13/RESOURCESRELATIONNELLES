import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/resource.dart';
import '../../domain/entities/type_relation_entity.dart';
import '../providers/resources_provider.dart';
import '../../../progression/presentation/providers/progression_provider.dart';
import '../widgets/resource_card.dart';

class ResourcesListPage extends StatefulWidget {
  const ResourcesListPage({super.key});

  @override
  State<ResourcesListPage> createState() => _ResourcesListPageState();
}

class _ResourcesListPageState extends State<ResourcesListPage> {
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResourcesProvider>().loadResources();
    });
  }

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = context.watch<ResourcesProvider>();
    final progressionProvider = context.watch<ProgressionProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    final resources = resourcesProvider.getFilteredResources();
    final categories = resourcesProvider.getCategories();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const AppLogoCompact(),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => context.read<ResourcesProvider>().loadResources(),
            tooltip: 'Actualiser',
          ),
          if (user != null)
            IconButton(
              icon: Icon(
                resourcesProvider.hasActiveFilters
                    ? Icons.filter_alt
                    : Icons.filter_alt_outlined,
                color: resourcesProvider.hasActiveFilters
                    ? AppTheme.secondary
                    : Colors.white,
              ),
              onPressed: () => setState(() => _showFilters = !_showFilters),
            ),
        ],
      ),
      floatingActionButton: user != null
          ? FloatingActionButton(
              onPressed: () => context.push('/resources/new'),
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: TextField(
              onChanged: resourcesProvider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Rechercher une ressource...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: resourcesProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => resourcesProvider.setSearchQuery(''),
                      )
                    : null,
              ),
            ),
          ),
          // Category chips
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final isAll = resourcesProvider.selectedCategoryId == null;
                  return FilterChip(
                    label: const Text('Tous'),
                    selected: isAll,
                    onSelected: (_) =>
                        resourcesProvider.setCategoryFilter(null),
                    selectedColor: AppTheme.primary.withOpacity(0.15),
                    checkmarkColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: isAll ? AppTheme.primary : AppTheme.textSecondary,
                      fontWeight:
                          isAll ? FontWeight.w600 : FontWeight.normal,
                    ),
                  );
                }
                final cat = categories[index - 1];
                final isSelected =
                    resourcesProvider.selectedCategoryId == cat.id;
                return FilterChip(
                  label: Text(cat.name),
                  selected: isSelected,
                  onSelected: (_) => resourcesProvider.setCategoryFilter(
                    isSelected ? null : cat.id,
                  ),
                  selectedColor: cat.color.withOpacity(0.15),
                  checkmarkColor: cat.color,
                  labelStyle: TextStyle(
                    color: isSelected ? cat.color : AppTheme.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  avatar: Icon(cat.icon, size: 14, color: cat.color),
                );
              },
            ),
          ),
          // Advanced filters
          if (_showFilters) _buildFilters(resourcesProvider),
          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${resources.length} ressource${resources.length > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (resourcesProvider.hasActiveFilters) ...[
                  const Spacer(),
                  TextButton.icon(
                    onPressed: resourcesProvider.clearFilters,
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('Effacer', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Resources grid
          Expanded(
            child: resourcesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : resources.isEmpty
                ? EmptyState(
                    icon: Icons.search_off,
                    title: 'Aucune ressource trouvée',
                    subtitle:
                        'Essayez de modifier vos critères de recherche',
                    action: OutlinedButton(
                      onPressed: resourcesProvider.clearFilters,
                      child: const Text('Réinitialiser les filtres'),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => context.read<ResourcesProvider>().loadResources(),
                    color: AppTheme.primary,
                    child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: resources.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final resource = resources[index];
                      final category = resourcesProvider.getCategoryById(
                          resource.categoryId);
                      final isFav = user != null &&
                          progressionProvider.isFavorite(
                              user.id, resource.id);
                      final isExploited = user != null &&
                          progressionProvider.isExploited(
                              user.id, resource.id);

                      return ResourceCard(
                        resource: resource,
                        category: category,
                        isFavorite: isFav,
                        isExploited: isExploited,
                        relationTypeLabels: _resolveRelationLabels(
                            resource, resourcesProvider.typeRelations),
                        onTap: () {
                          resourcesProvider.incrementViews(resource.id);
                          context.push('/resources/${resource.id}');
                        },
                        onFavoriteToggle: user != null
                            ? () => progressionProvider.toggleFavorite(
                                user.id, resource.id)
                            : null,
                      );
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }

  /// Résout les labels des types de relation depuis les IDs bruts de l'API.
  /// Fallback sur l'enum si allRelationTypeIds est vide ou types pas encore chargés.
  List<String> _resolveRelationLabels(
      Resource resource, List<TypeRelationEntity> typeRelations) {
    if (resource.allRelationTypeIds.isNotEmpty && typeRelations.isNotEmpty) {
      final labels = typeRelations
          .where((tr) => resource.allRelationTypeIds.contains(tr.id))
          .map((tr) => tr.libelle)
          .toList();
      if (labels.isNotEmpty) return labels;
    }
    return resource.relationTypes.map((rt) => rt.label).toList();
  }

  Widget _buildFilters(ResourcesProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtres avancés',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          // Type filter
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: ResourceType.values.map((type) {
              final selected = provider.selectedType == type;
              return FilterChip(
                label: Text('${type.icon} ${type.label}'),
                selected: selected,
                onSelected: (_) =>
                    provider.setTypeFilter(selected ? null : type),
                selectedColor: AppTheme.primary.withOpacity(0.1),
                checkmarkColor: AppTheme.primary,
                labelStyle: const TextStyle(fontSize: 12),
              );
            }).toList(),
          ),
          const Divider(height: 16),
          // Relation type filter (dynamique depuis l'API)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: provider.typeRelations.map((tr) {
              final selected = provider.selectedRelationTypeEntity?.id == tr.id;
              return FilterChip(
                label: Text(tr.libelle),
                selected: selected,
                onSelected: (_) =>
                    provider.setRelationTypeFilter(selected ? null : tr),
                selectedColor: AppTheme.secondary.withOpacity(0.15),
                checkmarkColor: AppTheme.secondary,
                labelStyle: const TextStyle(fontSize: 12),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
