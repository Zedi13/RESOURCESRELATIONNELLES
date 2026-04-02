import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/comments/presentation/widgets/comments_section.dart';
import '../../../../features/progression/presentation/providers/progression_provider.dart';
import '../providers/resources_provider.dart';
import '../../domain/entities/resource.dart';

class ResourceDetailPage extends StatelessWidget {
  final String resourceId;

  const ResourceDetailPage({super.key, required this.resourceId});

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = context.watch<ResourcesProvider>();
    final progressionProvider = context.watch<ProgressionProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    final resource = resourcesProvider.getResourceById(resourceId);

    if (resource == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ressource introuvable')),
        body: const Center(child: Text('Cette ressource n\'existe pas.')),
      );
    }

    final category = resourcesProvider.getCategoryById(resource.categoryId);
    final catColor = category?.color ?? AppTheme.tertiary;

    final isFav = user != null &&
        progressionProvider.isFavorite(user.id, resource.id);
    final isExploited = user != null &&
        progressionProvider.isExploited(user.id, resource.id);
    final isSaved = user != null &&
        progressionProvider.isSaved(user.id, resource.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with color
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppTheme.primary,
            actions: [
              if (user != null)
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_outline,
                    color: isFav ? Colors.red.shade300 : Colors.white,
                  ),
                  onPressed: () =>
                      progressionProvider.toggleFavorite(user.id, resource.id),
                ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  resourcesProvider.incrementShares(resource.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lien copié dans le presse-papier !'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, catColor.withOpacity(0.9)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              resource.type.icon,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                resource.type.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (category != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: catColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    resource.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Meta row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppTheme.primary.withOpacity(0.15),
                        child: Text(
                          resource.authorName[0],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resource.authorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${resource.createdAt.day}/${resource.createdAt.month}/${resource.createdAt.year} • ${resource.estimatedDurationMin} min',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stats
                      Row(
                        children: [
                          Icon(Icons.visibility_outlined,
                              size: 14, color: AppTheme.textSecondary),
                          const SizedBox(width: 3),
                          Text(
                            '${resource.views}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.share_outlined,
                              size: 14, color: AppTheme.textSecondary),
                          const SizedBox(width: 3),
                          Text(
                            '${resource.shares}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Relation types
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: resource.relationTypes.map((rt) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: catColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          rt.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: catColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Description
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      resource.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  // Progression actions
                  if (user != null) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: isExploited
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            label: isExploited ? 'Vu !' : 'Marquer comme vu',
                            color: AppTheme.success,
                            isActive: isExploited,
                            onTap: () => progressionProvider.toggleExploited(
                                user.id, resource.id),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: isSaved
                                ? Icons.bookmark
                                : Icons.bookmark_outline,
                            label: isSaved ? 'Sauvegardé' : 'Sauvegarder',
                            color: AppTheme.tertiary,
                            isActive: isSaved,
                            onTap: () => progressionProvider.toggleSaved(
                                user.id, resource.id),
                          ),
                        ),
                      ],
                    ),
                  ],
                  // Main content
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _MarkdownContent(content: resource.content),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Comments
                  CommentsSection(resourceId: resource.id),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color.withOpacity(0.3) : Colors.grey.shade200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isActive ? color : AppTheme.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? color : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarkdownContent extends StatelessWidget {
  final String content;

  const _MarkdownContent({required this.content});

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('## ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              line.substring(3),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          );
        } else if (line.startsWith('### ')) {
          return Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 6),
            child: Text(
              line.substring(4),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          );
        } else if (line.startsWith('**') && line.endsWith('**')) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              line.substring(2, line.length - 2),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          );
        } else if (line.startsWith('- ')) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 8, right: 10),
                  decoration: const BoxDecoration(
                    color: AppTheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (line.isEmpty) {
          return const SizedBox(height: 6);
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              line,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: AppTheme.textPrimary,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
