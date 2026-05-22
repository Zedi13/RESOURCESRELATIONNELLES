class UserProgression {
  final String userId;
  final List<String> favoriteResourceIds;
  final List<String> exploitedResourceIds;
  final List<String> savedResourceIds;

  const UserProgression({
    required this.userId,
    this.favoriteResourceIds = const [],
    this.exploitedResourceIds = const [],
    this.savedResourceIds = const [],
  });

  int get totalCompleted => exploitedResourceIds.length;
  int get totalFavorites => favoriteResourceIds.length;
  int get totalSaved => savedResourceIds.length;

  UserProgression copyWith({
    List<String>? favoriteResourceIds,
    List<String>? exploitedResourceIds,
    List<String>? savedResourceIds,
  }) {
    return UserProgression(
      userId: userId,
      favoriteResourceIds: favoriteResourceIds ?? this.favoriteResourceIds,
      exploitedResourceIds: exploitedResourceIds ?? this.exploitedResourceIds,
      savedResourceIds: savedResourceIds ?? this.savedResourceIds,
    );
  }
}
