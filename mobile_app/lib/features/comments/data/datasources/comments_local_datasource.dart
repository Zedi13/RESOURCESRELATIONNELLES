import '../../domain/entities/comment.dart';

class CommentsLocalDatasource {
  final List<Comment> _comments = [
    Comment(
      id: 'c1',
      resourceId: 'res1',
      authorId: '2',
      authorName: 'Bob Dupont',
      content:
          'Excellent article ! J\'ai essayé la technique de la reformulation ce week-end et c\'est bluffant comme ça désamorce les tensions.',
      createdAt: DateTime(2024, 1, 22),
      status: CommentStatus.approuve,
    ),
    Comment(
      id: 'c2',
      resourceId: 'res1',
      authorId: '1',
      authorName: 'Alice Martin',
      content:
          'Merci pour ton retour ! La reformulation demande de la pratique mais devient naturelle avec le temps.',
      createdAt: DateTime(2024, 1, 23),
      status: CommentStatus.approuve,
      parentId: 'c1',
    ),
    Comment(
      id: 'c3',
      resourceId: 'res2',
      authorId: '1',
      authorName: 'Alice Martin',
      content:
          'Le modèle OSBD a vraiment changé ma façon de communiquer. Je l\'utilise même au travail maintenant !',
      createdAt: DateTime(2024, 2, 1),
      status: CommentStatus.approuve,
    ),
    Comment(
      id: 'c4',
      resourceId: 'res5',
      authorId: '2',
      authorName: 'Bob Dupont',
      content: 'Nous avons fait ce jeu vendredi soir, super moment en couple. Recommandé !',
      createdAt: DateTime(2024, 2, 25),
      status: CommentStatus.approuve,
    ),
    Comment(
      id: 'c5',
      resourceId: 'res6',
      authorId: '1',
      authorName: 'Alice Martin',
      content:
          'J\'ai découvert que mon langage principal est le temps de qualité et celui de mon mari sont les mots d\'affirmation. Ça explique beaucoup de nos incompréhensions passées !',
      createdAt: DateTime(2024, 3, 2),
      status: CommentStatus.approuve,
    ),
    Comment(
      id: 'c6',
      resourceId: 'res10',
      authorId: '2',
      authorName: 'Bob Dupont',
      content: 'La règle des 50 heures m\'a ouvert les yeux. Je pensais que c\'était plus facile pour les autres.',
      createdAt: DateTime(2024, 3, 25),
      status: CommentStatus.enAttente,
    ),
  ];

  List<Comment> getCommentsByResource(String resourceId) {
    final roots = _comments
        .where((c) => c.resourceId == resourceId && c.parentId == null && c.status == CommentStatus.approuve)
        .toList();
    return roots.map((root) {
      final replies = _comments
          .where((c) => c.parentId == root.id && c.status == CommentStatus.approuve)
          .toList();
      return root.copyWith(replies: replies);
    }).toList();
  }

  List<Comment> getPendingComments() =>
      _comments.where((c) => c.status == CommentStatus.enAttente).toList();

  void addComment(Comment comment) {
    _comments.add(comment);
  }

  void moderateComment(String commentId, CommentStatus status) {
    final idx = _comments.indexWhere((c) => c.id == commentId);
    if (idx != -1) {
      _comments[idx] = _comments[idx].copyWith(status: status);
    }
  }

  void deleteComment(String commentId) {
    _comments.removeWhere((c) => c.id == commentId);
  }
}
