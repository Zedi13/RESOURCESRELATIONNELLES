import 'package:flutter/material.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/comments_repository.dart';

class CommentsProvider extends ChangeNotifier {
  final CommentsRepository _repository;

  CommentsProvider(this._repository);

  List<Comment> getCommentsByResource(String resourceId) =>
      _repository.getCommentsByResource(resourceId);

  void addComment({
    required String resourceId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentId,
  }) {
    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      resourceId: resourceId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: DateTime.now(),
      status: CommentStatus.approuve,
      parentId: parentId,
    );
    _repository.addComment(comment);
    notifyListeners();
  }

  void moderateComment(String commentId, CommentStatus status) {
    _repository.moderateComment(commentId, status);
    notifyListeners();
  }

  void deleteComment(String commentId) {
    _repository.deleteComment(commentId);
    notifyListeners();
  }
}
