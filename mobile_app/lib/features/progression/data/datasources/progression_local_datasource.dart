import '../../domain/entities/user_progression.dart';

class ProgressionLocalDatasource {
  final Map<String, UserProgression> _progressions = {
    '1': UserProgression(
      userId: '1',
      favoriteResourceIds: ['res1', 'res5', 'res6'],
      exploitedResourceIds: ['res1', 'res2', 'res3'],
      savedResourceIds: ['res4', 'res7'],
    ),
    '2': UserProgression(
      userId: '2',
      favoriteResourceIds: ['res6', 'res10'],
      exploitedResourceIds: ['res1', 'res6'],
      savedResourceIds: ['res5'],
    ),
  };

  UserProgression getProgression(String userId) {
    return _progressions[userId] ??
        UserProgression(userId: userId);
  }

  void toggleFavorite(String userId, String resourceId) {
    final current = getProgression(userId);
    final favs = List<String>.from(current.favoriteResourceIds);
    if (favs.contains(resourceId)) {
      favs.remove(resourceId);
    } else {
      favs.add(resourceId);
    }
    _progressions[userId] = current.copyWith(favoriteResourceIds: favs);
  }

  void toggleExploited(String userId, String resourceId) {
    final current = getProgression(userId);
    final exploited = List<String>.from(current.exploitedResourceIds);
    if (exploited.contains(resourceId)) {
      exploited.remove(resourceId);
    } else {
      exploited.add(resourceId);
    }
    _progressions[userId] = current.copyWith(exploitedResourceIds: exploited);
  }

  void toggleSaved(String userId, String resourceId) {
    final current = getProgression(userId);
    final saved = List<String>.from(current.savedResourceIds);
    if (saved.contains(resourceId)) {
      saved.remove(resourceId);
    } else {
      saved.add(resourceId);
    }
    _progressions[userId] = current.copyWith(savedResourceIds: saved);
  }
}
