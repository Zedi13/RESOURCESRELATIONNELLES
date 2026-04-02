import '../../domain/entities/user_progression.dart';
import '../../domain/repositories/progression_repository.dart';
import '../datasources/progression_local_datasource.dart';

class ProgressionRepositoryImpl implements ProgressionRepository {
  final ProgressionLocalDatasource _datasource;

  ProgressionRepositoryImpl(this._datasource);

  @override
  UserProgression getProgression(String userId) =>
      _datasource.getProgression(userId);

  @override
  void toggleFavorite(String userId, String resourceId) =>
      _datasource.toggleFavorite(userId, resourceId);

  @override
  void toggleExploited(String userId, String resourceId) =>
      _datasource.toggleExploited(userId, resourceId);

  @override
  void toggleSaved(String userId, String resourceId) =>
      _datasource.toggleSaved(userId, resourceId);
}
