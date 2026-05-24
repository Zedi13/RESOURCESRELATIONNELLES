import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/network/api_client.dart';
import '../../../resources/domain/entities/resource.dart';
import '../../../resources/data/datasources/resources_remote_datasource.dart';
import '../../../resources/presentation/providers/resources_provider.dart';
import '../../../comments/domain/entities/comment.dart';
import '../../../comments/data/datasources/comments_remote_datasource.dart';

class ModerationPage extends StatefulWidget {
  const ModerationPage({super.key});

  @override
  State<ModerationPage> createState() => _ModerationPageState();
}

class _ModerationPageState extends State<ModerationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  List<Resource> _pendingResources = [];
  List<Comment> _pendingComments = [];
  bool _loadingResources = true;
  bool _loadingComments = true;

  late ResourcesRemoteDatasource _resourcesDs;
  late CommentsRemoteDatasource _commentsDs;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    final client = context.read<ApiClient>();
    _resourcesDs = ResourcesRemoteDatasource(client);
    _commentsDs = CommentsRemoteDatasource(client);
    _loadResources();
    _loadComments();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadResources() async {
    setState(() => _loadingResources = true);
    try {
      final resources = await _resourcesDs.getPendingResources();
      if (mounted) setState(() => _pendingResources = resources);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingResources = false);
    }
  }

  Future<void> _loadComments() async {
    setState(() => _loadingComments = true);
    try {
      final comments = await _commentsDs.getPendingComments();
      if (mounted) setState(() => _pendingComments = comments);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingComments = false);
    }
  }

  Future<void> _moderateResource(String id, String statut) async {
    try {
      await _resourcesDs.changeResourceStatus(id, statut);
      await _loadResources();
      context.read<ResourcesProvider>().loadResources();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(statut == 'PUBLIE' ? 'Ressource publiée' : 'Ressource rejetée'),
          backgroundColor: statut == 'PUBLIE' ? AppTheme.success : AppTheme.error,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  Future<void> _moderateComment(String id, CommentStatus status) async {
    try {
      await _commentsDs.moderateComment(id, status);
      await _loadComments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(status == CommentStatus.approuve ? 'Commentaire approuvé' : 'Commentaire rejeté'),
          backgroundColor: status == CommentStatus.approuve ? AppTheme.success : AppTheme.error,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'), backgroundColor: AppTheme.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Modération'),
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppTheme.secondary,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: 'Ressources (${_pendingResources.length})'),
            Tab(text: 'Commentaires (${_pendingComments.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildResourcesTab(),
          _buildCommentsTab(),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    if (_loadingResources) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pendingResources.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: AppTheme.success),
            SizedBox(height: 16),
            Text('Aucune ressource en attente',
                style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadResources,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingResources.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _ResourceModerationCard(
          resource: _pendingResources[i],
          onPublish: () => _moderateResource(_pendingResources[i].id, 'PUBLIE'),
          onReject: () => _moderateResource(_pendingResources[i].id, 'SUSPENDU'),
        ),
      ),
    );
  }

  Widget _buildCommentsTab() {
    if (_loadingComments) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pendingComments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: AppTheme.success),
            SizedBox(height: 16),
            Text('Aucun commentaire en attente',
                style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadComments,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingComments.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _CommentModerationCard(
          comment: _pendingComments[i],
          onApprove: () => _moderateComment(_pendingComments[i].id, CommentStatus.approuve),
          onReject: () => _moderateComment(_pendingComments[i].id, CommentStatus.rejete),
        ),
      ),
    );
  }
}

class _ResourceModerationCard extends StatelessWidget {
  final Resource resource;
  final VoidCallback onPublish;
  final VoidCallback onReject;

  const _ResourceModerationCard({
    required this.resource,
    required this.onPublish,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  resource.type.name.toUpperCase(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.warning),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(resource.createdAt),
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(resource.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          if (resource.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(resource.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ],
          const SizedBox(height: 6),
          Text('Par ${resource.authorName}',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close, size: 16, color: AppTheme.error),
                  label: const Text('Rejeter', style: TextStyle(color: AppTheme.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onPublish,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Publier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}

class _CommentModerationCard extends StatelessWidget {
  final Comment comment;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _CommentModerationCard({
    required this.comment,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.primary.withOpacity(0.1),
                child: Text(
                  comment.authorName.isNotEmpty ? comment.authorName[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(comment.authorName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              Text(
                _formatDate(comment.createdAt),
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment.content,
              style: const TextStyle(fontSize: 13, height: 1.4)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onReject,
                  icon: const Icon(Icons.close, size: 16, color: AppTheme.error),
                  label: const Text('Rejeter', style: TextStyle(color: AppTheme.error)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.error),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onApprove,
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Approuver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
