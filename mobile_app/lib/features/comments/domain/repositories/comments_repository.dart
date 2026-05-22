import '../entities/comment.dart';

abstract class CommentsRepository {
  List<Comment> getCommentsByResource(String resourceId);
  void addComment(Comment comment);
  void moderateComment(String commentId, CommentStatus status);
  void deleteComment(String commentId);
}
