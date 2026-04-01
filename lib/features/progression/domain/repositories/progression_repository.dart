import '../entities/user_progression.dart';

abstract class ProgressionRepository {
  UserProgression getProgression(String userId);
  void toggleFavorite(String userId, String resourceId);
  void toggleExploited(String userId, String resourceId);
  void toggleSaved(String userId, String resourceId);
}
