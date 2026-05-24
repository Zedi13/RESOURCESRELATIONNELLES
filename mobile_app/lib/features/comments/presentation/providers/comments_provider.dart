import 'package:flutter/material.dart';
import '../../domain/entities/comment.dart';
import '../../domain/repositories/comments_repository.dart';

class CommentsProvider extends ChangeNotifier {
  final CommentsRepository _repository;
  CommentsProvider(this._repository);

  final Map<String, List<Comment>> _cache = {};
  bool isLoading = false;

  Future<void> loadComments(String resourceId) async {
    isLoading = true;
    notifyListeners();
    try {
      _cache[resourceId] = await _repository.getCommentsByResource(resourceId);
    } catch (_) {
      _cache[resourceId] = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Comment> getCommentsByResource(String resourceId) =>
      _cache[resourceId] ?? const [];

  Future<void> addComment({
    required String resourceId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentId,
  }) async {
    await _repository.addComment(
      resourceId: resourceId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      parentId: parentId,
    );
    await loadComments(resourceId);
  }

  Future<void> moderateComment(
      String commentId, CommentStatus status, String resourceId) async {
    await _repository.moderateComment(commentId, status);
    await loadComments(resourceId);
  }

  Future<void> deleteComment(String commentId, String resourceId) async {
    await _repository.deleteComment(commentId);
    await loadComments(resourceId);
  }
}
