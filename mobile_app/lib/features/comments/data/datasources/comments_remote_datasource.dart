import '../../domain/entities/comment.dart';
import '../../../../core/network/api_client.dart';

class CommentsRemoteDatasource {
  final ApiClient _client;
  CommentsRemoteDatasource(this._client);

  Future<List<Comment>> getCommentsByResource(String resourceId) async {
    final data =
        await _client.get('/ressources/$resourceId/commentaires') as List;
    return data.map(_toComment).toList();
  }

  Future<void> addComment({
    required String resourceId,
    required String content,
    String? parentId,
  }) async {
    await _client.post('/ressources/$resourceId/commentaires', {
      'contenu': content,
      if (parentId != null) 'parentId': int.tryParse(parentId),
    });
  }

  Future<void> moderateComment(String commentId, CommentStatus status) async {
    await _client.patch('/commentaires/$commentId/moderer', {
      'decision': _fromStatus(status),
    });
  }

  Future<void> deleteComment(String commentId) async {
    await _client.delete('/commentaires/$commentId');
  }

  Future<List<Comment>> getPendingComments() async {
    final data = await _client.get('/admin/commentaires?statut=en_attente&size=100')
        as Map<String, dynamic>;
    return (data['content'] as List).map(_toComment).toList();
  }

  static Comment _toComment(dynamic json) {
    final j = json as Map<String, dynamic>;
    final replies =
        (j['reponses'] as List? ?? const []).map(_toComment).toList();
    return Comment(
      id: j['id'].toString(),
      resourceId: (j['ressourceId'] ?? '').toString(),
      authorId: (j['auteurId'] ?? '').toString(),
      authorName: j['auteurNom'] as String? ?? 'Anonyme',
      content: j['contenu'] as String? ?? '',
      createdAt:
          DateTime.tryParse(j['dateCreation'] as String? ?? '') ?? DateTime.now(),
      status: _toStatus(j['statut'] as String? ?? ''),
      parentId: j['parentId']?.toString(),
      replies: replies,
    );
  }

  static CommentStatus _toStatus(String s) {
    switch (s.toUpperCase()) {
      case 'APPROUVE':
        return CommentStatus.approuve;
      case 'REJETE':
        return CommentStatus.rejete;
      default:
        return CommentStatus.enAttente;
    }
  }

  static String _fromStatus(CommentStatus s) {
    switch (s) {
      case CommentStatus.enAttente:
        return 'EN_ATTENTE';
      case CommentStatus.approuve:
        return 'APPROUVE';
      case CommentStatus.rejete:
        return 'REJETE';
    }
  }
}
