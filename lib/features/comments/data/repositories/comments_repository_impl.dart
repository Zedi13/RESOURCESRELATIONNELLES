import '../../domain/entities/comment.dart';
import '../../domain/repositories/comments_repository.dart';
import '../datasources/comments_local_datasource.dart';

class CommentsRepositoryImpl implements CommentsRepository {
  final CommentsLocalDatasource _datasource;

  CommentsRepositoryImpl(this._datasource);

  @override
  List<Comment> getCommentsByResource(String resourceId) =>
      _datasource.getCommentsByResource(resourceId);

  @override
  void addComment(Comment comment) => _datasource.addComment(comment);

  @override
  void moderateComment(String commentId, CommentStatus status) =>
      _datasource.moderateComment(commentId, status);

  @override
  void deleteComment(String commentId) => _datasource.deleteComment(commentId);
}
