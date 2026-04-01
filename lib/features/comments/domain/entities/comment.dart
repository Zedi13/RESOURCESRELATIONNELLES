enum CommentStatus { enAttente, approuve, rejete }

class Comment {
  final String id;
  final String resourceId;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final CommentStatus status;
  final String? parentId;
  final List<Comment> replies;

  const Comment({
    required this.id,
    required this.resourceId,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
    required this.status,
    this.parentId,
    this.replies = const [],
  });

  Comment copyWith({CommentStatus? status, List<Comment>? replies}) {
    return Comment(
      id: id,
      resourceId: resourceId,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: createdAt,
      status: status ?? this.status,
      parentId: parentId,
      replies: replies ?? this.replies,
    );
  }
}
