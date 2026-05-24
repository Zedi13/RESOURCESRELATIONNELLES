import '../../domain/entities/comment.dart';
import '../../domain/repositories/comments_repository.dart';
import '../datasources/comments_remote_datasource.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final CommentsRemoteDatasource _datasource;
  CommentsRepositoryImpl(this._datasource);

  @override
  Future<List<Comment>> getCommentsByResource(String resourceId) =>
      _datasource.getCommentsByResource(resourceId);

  @override
  Future<void> addComment({
    required String resourceId,
    required String authorId,
    required String authorName,
    required String content,
    String? parentId,
  }) =>
      _datasource.addComment(
        resourceId: resourceId,
        content: content,
        parentId: parentId,
      );

  @override
  Future<void> moderateComment(String commentId, CommentStatus status) =>
      _datasource.moderateComment(commentId, status);

  @override
  Future<void> deleteComment(String commentId) =>
      _datasource.deleteComment(commentId);
}
