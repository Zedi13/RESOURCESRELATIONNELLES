import '../entities/comment.dart';

abstract class CommentsRepository {
  Future<List<Comment>> getCommentsByResource(String resourceId);
  Future<void> addComment({
    required String resourceId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentId,
  });
  Future<void> moderateComment(String commentId, CommentStatus status);
  Future<void> deleteComment(String commentId);
}
