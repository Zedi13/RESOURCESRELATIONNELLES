import 'package:flutter/material.dart';
import '../../domain/entities/user_progression.dart';
import '../../domain/repositories/progression_repository.dart';

class ProgressionProvider extends ChangeNotifier {
  final ProgressionRepository _repository;

  ProgressionProvider(this._repository);

  UserProgression getProgression(String userId) =>
      _repository.getProgression(userId);

  bool isFavorite(String userId, String resourceId) =>
      _repository.getProgression(userId).favoriteResourceIds.contains(resourceId);

  bool isExploited(String userId, String resourceId) =>
      _repository.getProgression(userId).exploitedResourceIds.contains(resourceId);

  bool isSaved(String userId, String resourceId) =>
      _repository.getProgression(userId).savedResourceIds.contains(resourceId);

  void toggleFavorite(String userId, String resourceId) {
    _repository.toggleFavorite(userId, resourceId);
    notifyListeners();
  }

  void toggleExploited(String userId, String resourceId) {
    _repository.toggleExploited(userId, resourceId);
    notifyListeners();
  }

  void toggleSaved(String userId, String resourceId) {
    _repository.toggleSaved(userId, resourceId);
    notifyListeners();
  }
}
