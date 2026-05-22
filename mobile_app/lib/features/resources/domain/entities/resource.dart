enum ResourceType { article, video, audio, activite, jeu, podcast, document, lien }
enum RelationType { couple, famille, amis, professionnel, social, soi }
enum ResourceVisibility { prive, partage, public_ }
enum ResourceStatus { brouillon, enAttente, publie, suspendu }

extension ResourceTypeExt on ResourceType {
  String get label {
    switch (this) {
      case ResourceType.article:
        return 'Article';
      case ResourceType.video:
        return 'Vidéo';
      case ResourceType.audio:
        return 'Audio';
      case ResourceType.activite:
        return 'Activité';
      case ResourceType.jeu:
        return 'Jeu';
      case ResourceType.podcast:
        return 'Podcast';
      case ResourceType.document:
        return 'Document';
      case ResourceType.lien:
        return 'Lien';
    }
  }

  String get icon {
    switch (this) {
      case ResourceType.article:
        return '📄';
      case ResourceType.video:
        return '🎬';
      case ResourceType.audio:
        return '🎵';
      case ResourceType.activite:
        return '🎯';
      case ResourceType.jeu:
        return '🎮';
      case ResourceType.podcast:
        return '🎙️';
      case ResourceType.document:
        return '📋';
      case ResourceType.lien:
        return '🔗';
    }
  }
}

extension RelationTypeExt on RelationType {
  String get label {
    switch (this) {
      case RelationType.couple:
        return 'Couple';
      case RelationType.famille:
        return 'Famille';
      case RelationType.amis:
        return 'Amis';
      case RelationType.professionnel:
        return 'Professionnel';
      case RelationType.social:
        return 'Social';
      case RelationType.soi:
        return 'Soi-même';
    }
  }
}

extension ResourceStatusExt on ResourceStatus {
  String get label {
    switch (this) {
      case ResourceStatus.brouillon:
        return 'Brouillon';
      case ResourceStatus.enAttente:
        return 'En attente';
      case ResourceStatus.publie:
        return 'Publié';
      case ResourceStatus.suspendu:
        return 'Suspendu';
    }
  }
}

class Resource {
  final String id;
  final String title;
  final String description;
  final String content;
  final ResourceType type;
  final String categoryId;
  final List<RelationType> relationTypes;
  final ResourceVisibility visibility;
  final ResourceStatus status;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final int views;
  final int shares;
  final int estimatedDurationMin;
  final String? externalUrl;

  const Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.type,
    required this.categoryId,
    required this.relationTypes,
    required this.visibility,
    required this.status,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.views,
    required this.shares,
    required this.estimatedDurationMin,
    this.externalUrl,
  });

  bool get isPublic => visibility == ResourceVisibility.public_;
  bool get isPublished => status == ResourceStatus.publie;

  Resource copyWith({
    String? title,
    String? description,
    String? content,
    ResourceType? type,
    String? categoryId,
    List<RelationType>? relationTypes,
    ResourceVisibility? visibility,
    ResourceStatus? status,
    int? views,
    int? shares,
  }) {
    return Resource(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      relationTypes: relationTypes ?? this.relationTypes,
      visibility: visibility ?? this.visibility,
      status: status ?? this.status,
      authorId: authorId,
      authorName: authorName,
      createdAt: createdAt,
      views: views ?? this.views,
      shares: shares ?? this.shares,
      estimatedDurationMin: estimatedDurationMin,
      externalUrl: externalUrl,
    );
  }
}
