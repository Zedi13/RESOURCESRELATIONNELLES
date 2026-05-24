import '../../domain/entities/user_progression.dart';
import '../../domain/repositories/progression_repository.dart';
import '../datasources/progression_remote_datasource.dart';

class ProgressionRepositoryImpl implements ProgressionRepository {
  final ProgressionRemoteDatasource _datasource;
  ProgressionRepositoryImpl(this._datasource);

  @override
  Future<UserProgression> getProgression(String userId) =>
      _datasource.getProgression(userId);

  @override
  Future<void> addFavorite(String resourceId) =>
      _datasource.addFavorite(resourceId);

  @override
  Future<void> removeFavorite(String resourceId) =>
      _datasource.removeFavorite(resourceId);

  @override
  Future<void> addExploitation(String resourceId) =>
      _datasource.addExploitation(resourceId);

  @override
  Future<void> removeExploitation(String resourceId) =>
      _datasource.removeExploitation(resourceId);

  @override
  Future<void> addSauvegarde(String resourceId) =>
      _datasource.addSauvegarde(resourceId);

  @override
  Future<void> removeSauvegarde(String resourceId) =>
      _datasource.removeSauvegarde(resourceId);
}
