import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/resource.dart';
import '../providers/resources_provider.dart';

class AdminResourcesPage extends StatefulWidget {
  const AdminResourcesPage({super.key});

  @override
  State<AdminResourcesPage> createState() => _AdminResourcesPageState();
}

class _AdminResourcesPageState extends State<AdminResourcesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  static const _tabs = [
    _TabDef('Tous', null),
    _TabDef('En attente', 'EN_ATTENTE'),
    _TabDef('Publiés', 'PUBLIE'),
    _TabDef('Suspendus', 'SUSPENDU'),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResourcesProvider>().loadAdminResources();
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<Resource> _filtered(List<Resource> all, String? statut) {
    if (statut == null) return all;
    return all.where((r) {
      switch (statut) {
        case 'EN_ATTENTE':
          return r.status == ResourceStatus.enAttente;
        case 'PUBLIE':
          return r.status == ResourceStatus.publie;
        case 'SUSPENDU':
          return r.status == ResourceStatus.suspendu;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResourcesProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Gestion des ressources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
            onPressed: () => provider.loadAdminResources(),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppTheme.secondary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          isScrollable: true,
          tabs: _tabs.map((t) {
            final count = _filtered(provider.adminResources, t.statut).length;
            return Tab(text: '${t.label} ($count)');
          }).toList(),
        ),
      ),
      body: provider.isLoadingAdminResources
          ? const Center(child: CircularProgressIndicator())
          : provider.adminResourcesError != null
              ? _ErrorView(
                  message: provider.adminResourcesError!,
                  onRetry: () => provider.loadAdminResources(),
                )
              : TabBarView(
                  controller: _tabCtrl,
                  children: _tabs.map((t) {
                    final items =
                        _filtered(provider.adminResources, t.statut);
                    if (items.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 64, color: AppTheme.textSecondary),
                            SizedBox(height: 12),
                            Text('Aucune ressource',
                                style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 15)),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () => provider.loadAdminResources(),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (ctx, i) => _ResourceAdminCard(
                          resource: items[i],
                          onPublish: () =>
                              _changeStatus(ctx, items[i].id, 'PUBLIE'),
                          onSuspend: () =>
                              _changeStatus(ctx, items[i].id, 'SUSPENDU'),
                          onDelete: () =>
                              _confirmDelete(ctx, items[i]),
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }

  Future<void> _changeStatus(
      BuildContext ctx, String id, String statut) async {
    try {
      await context.read<ResourcesProvider>().changeResourceStatus(id, statut);
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(statut == 'PUBLIE'
              ? 'Ressource publiée'
              : 'Ressource suspendue'),
          backgroundColor:
              statut == 'PUBLIE' ? AppTheme.success : AppTheme.warning,
        ));
      }
    } catch (e) {
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: AppTheme.error,
        ));
      }
    }
  }

  void _confirmDelete(BuildContext ctx, Resource resource) {
    showDialog(
      context: ctx,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer cette ressource ?'),
        content: Text(
            'La ressource « ${resource.title} » sera définitivement supprimée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await context
                    .read<ResourcesProvider>()
                    .deleteResource(resource.id);
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Ressource supprimée'),
                      backgroundColor: AppTheme.success,
                    ),
                  );
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                    content: Text('Erreur : $e'),
                    backgroundColor: AppTheme.error,
                  ));
                }
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class _TabDef {
  final String label;
  final String? statut;
  const _TabDef(this.label, this.statut);
}

class _ResourceAdminCard extends StatelessWidget {
  final Resource resource;
  final VoidCallback onPublish;
  final VoidCallback onSuspend;
  final VoidCallback onDelete;

  const _ResourceAdminCard({
    required this.resource,
    required this.onPublish,
    required this.onSuspend,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final (statusLabel, statusColor) = _statusInfo(resource.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: type + status
            Row(
              children: [
                Text(resource.type.icon,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  resource.type.label,
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecondary),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor),
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
                  color: AppTheme.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Par ${resource.authorName} · ${_formatDate(resource.createdAt)}',
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            // Actions
            Row(
              children: [
                if (resource.status != ResourceStatus.publie)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onPublish,
                      icon: const Icon(Icons.check_circle_outline,
                          size: 14, color: AppTheme.success),
                      label: const Text('Publier',
                          style: TextStyle(
                              color: AppTheme.success, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side:
                            const BorderSide(color: AppTheme.success),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: Size.zero,
                      ),
                    ),
                  ),
                if (resource.status != ResourceStatus.publie &&
                    resource.status != ResourceStatus.suspendu)
                  const SizedBox(width: 8),
                if (resource.status == ResourceStatus.publie)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSuspend,
                      icon: const Icon(Icons.pause_circle_outline,
                          size: 14, color: AppTheme.warning),
                      label: const Text('Suspendre',
                          style: TextStyle(
                              color: AppTheme.warning, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side:
                            const BorderSide(color: AppTheme.warning),
                        padding:
                            const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: Size.zero,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline,
                      size: 14, color: AppTheme.error),
                  label: const Text('Supprimer',
                      style: TextStyle(
                          color: AppTheme.error, fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  (String, Color) _statusInfo(ResourceStatus status) {
    switch (status) {
      case ResourceStatus.publie:
        return ('Publié', AppTheme.success);
      case ResourceStatus.enAttente:
        return ('En attente', AppTheme.warning);
      case ResourceStatus.suspendu:
        return ('Suspendu', AppTheme.error);
      case ResourceStatus.brouillon:
        return ('Brouillon', AppTheme.textSecondary);
    }
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}
