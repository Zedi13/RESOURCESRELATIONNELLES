import 'package:flutter/material.dart';
import '../../domain/entities/user_progression.dart';
import '../../domain/repositories/progression_repository.dart';

class ProgressionProvider extends ChangeNotifier {
  final ProgressionRepository _repository;
  ProgressionProvider(this._repository);

  List<String> _favoriteIds = [];
  List<String> _exploitedIds = [];
  List<String> _savedIds = [];
  bool isLoading = false;
  String? _loadedUserId;

  Future<void> loadProgression(String userId) async {
    if (_loadedUserId == userId) return;
    isLoading = true;
    notifyListeners();
    try {
      final p = await _repository.getProgression(userId);
      _favoriteIds = List.from(p.favoriteResourceIds);
      _exploitedIds = List.from(p.exploitedResourceIds);
      _savedIds = List.from(p.savedResourceIds);
      _loadedUserId = userId;
    } catch (_) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void invalidate() => _loadedUserId = null;

  UserProgression getProgression(String userId) => UserProgression(
        userId: userId,
        favoriteResourceIds: _favoriteIds,
        exploitedResourceIds: _exploitedIds,
        savedResourceIds: _savedIds,
      );

  bool isFavorite(String userId, String resourceId) =>
      _favoriteIds.contains(resourceId);

  bool isExploited(String userId, String resourceId) =>
      _exploitedIds.contains(resourceId);

  bool isSaved(String userId, String resourceId) =>
      _savedIds.contains(resourceId);

  void toggleFavorite(String userId, String resourceId) {
    if (_favoriteIds.contains(resourceId)) {
      _favoriteIds.remove(resourceId);
      _repository.removeFavorite(resourceId);
    } else {
      _favoriteIds.add(resourceId);
      _repository.addFavorite(resourceId);
    }
    notifyListeners();
  }

  void toggleExploited(String userId, String resourceId) {
    if (_exploitedIds.contains(resourceId)) {
      _exploitedIds.remove(resourceId);
      _repository.removeExploitation(resourceId);
    } else {
      _exploitedIds.add(resourceId);
      _repository.addExploitation(resourceId);
    }
    notifyListeners();
  }

  void toggleSaved(String userId, String resourceId) {
    if (_savedIds.contains(resourceId)) {
      _savedIds.remove(resourceId);
      _repository.removeSauvegarde(resourceId);
    } else {
      _savedIds.add(resourceId);
      _repository.addSauvegarde(resourceId);
    }
    notifyListeners();
  }
}
