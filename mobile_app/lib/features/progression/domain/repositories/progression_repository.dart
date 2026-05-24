import '../entities/user_progression.dart';

abstract class ProgressionRepository {
  Future<UserProgression> getProgression(String userId);
  Future<void> addFavorite(String resourceId);
  Future<void> removeFavorite(String resourceId);
  Future<void> addExploitation(String resourceId);
  Future<void> removeExploitation(String resourceId);
  Future<void> addSauvegarde(String resourceId);
  Future<void> removeSauvegarde(String resourceId);
}
