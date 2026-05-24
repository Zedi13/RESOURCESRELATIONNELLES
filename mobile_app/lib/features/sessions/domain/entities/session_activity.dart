class SessionParticipant {
  final String id;
  final String name;
  const SessionParticipant({required this.id, required this.name});
}

class SessionMessage {
  final String id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime sentAt;

  const SessionMessage({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.sentAt,
  });
}

class SessionActivity {
  final String id;
  final String code;
  final String resourceId;
  final String resourceTitle;
  final String creatorId;
  final String creatorName;
  final List<SessionParticipant> participants;
  final List<SessionMessage> messages;
  final bool isActive;
  final DateTime createdAt;

  const SessionActivity({
    required this.id,
    required this.code,
    required this.resourceId,
    required this.resourceTitle,
    required this.creatorId,
    required this.creatorName,
    required this.participants,
    required this.messages,
    required this.isActive,
    required this.createdAt,
  });
}
