import 'package:flutter/material.dart';
import '../../domain/entities/resource.dart';
import '../../domain/entities/category.dart';
import '../../../../core/theme/app_theme.dart';

class ResourceCard extends StatelessWidget {
  final Resource resource;
  final Category? category;
  final VoidCallback? onTap;
  final bool isFavorite;
  final bool isExploited;
  final VoidCallback? onFavoriteToggle;

  const ResourceCard({
    super.key,
    required this.resource,
    this.category,
    this.onTap,
    this.isFavorite = false,
    this.isExploited = false,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cat = category;
    final catColor = cat?.color ?? AppTheme.tertiary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color header
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: catColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type + Category row
                  Row(
                    children: [
                      Text(
                        resource.type.icon,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      if (cat != null)
                        Expanded(
                          child: Text(
                            cat.name,
                            style: TextStyle(
                              fontSize: 11,
                              color: catColor,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (isExploited)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '✓ Vu',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.success,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    resource.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    resource.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Relation types chips
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: resource.relationTypes.map((rt) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: catColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          rt.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: catColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Footer: stats
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${resource.estimatedDurationMin} min',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.visibility_outlined,
                          size: 12, color: AppTheme.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        '${resource.views}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      if (onFavoriteToggle != null)
                        GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_outline,
                            size: 18,
                            color: isFavorite ? Colors.red : AppTheme.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
