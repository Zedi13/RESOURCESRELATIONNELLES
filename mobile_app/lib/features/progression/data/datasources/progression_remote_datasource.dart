import '../../domain/entities/user_progression.dart';
import '../../../../core/network/api_client.dart';

class ProgressionRemoteDatasource {
  final ApiClient _client;
  ProgressionRemoteDatasource(this._client);

  Future<UserProgression> getProgression(String userId) async {
    final data =
        await _client.get('/progression') as Map<String, dynamic>;
    return UserProgression(
      userId: userId,
      favoriteResourceIds:
          _toIds(data['favoris'] as List? ?? const []),
      exploitedResourceIds:
          _toIds(data['ressourcesExploitees'] as List? ?? const []),
      savedResourceIds:
          _toIds(data['ressourcesSauvegardees'] as List? ?? const []),
    );
  }

  Future<void> addFavorite(String resourceId) async {
    await _client.post('/progression/favoris/$resourceId', {});
  }

  Future<void> removeFavorite(String resourceId) async {
    await _client.delete('/progression/favoris/$resourceId');
  }

  Future<void> addExploitation(String resourceId) async {
    await _client.post('/progression/exploitations/$resourceId', {});
  }

  Future<void> removeExploitation(String resourceId) async {
    await _client.delete('/progression/exploitations/$resourceId');
  }

  Future<void> addSauvegarde(String resourceId) async {
    await _client.post('/progression/sauvegardes/$resourceId', {});
  }

  Future<void> removeSauvegarde(String resourceId) async {
    await _client.delete('/progression/sauvegardes/$resourceId');
  }

  static List<String> _toIds(List items) => items
      .map((e) => (e as Map<String, dynamic>)['id'].toString())
      .toList();
}
