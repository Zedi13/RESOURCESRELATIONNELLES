import '../../../../core/network/api_client.dart';
import '../../domain/entities/session_activity.dart';

class SessionsRemoteDatasource {
  final ApiClient _client;
  SessionsRemoteDatasource(this._client);

  Future<SessionActivity> createSession(String resourceId) async {
    final data = await _client.post('/sessions', {
      'ressourceId': int.parse(resourceId),
    }) as Map<String, dynamic>;
    return _toSession(data);
  }

  Future<SessionActivity> getSession(String code) async {
    final data =
        await _client.get('/sessions/$code') as Map<String, dynamic>;
    return _toSession(data);
  }

  Future<SessionActivity> joinSession(String code) async {
    final data = await _client.post('/sessions/$code/rejoindre', {})
        as Map<String, dynamic>;
    return _toSession(data);
  }

  Future<SessionActivity> sendMessage(String code, String content) async {
    final data = await _client.post('/sessions/$code/messages', {
      'contenu': content,
    }) as Map<String, dynamic>;
    return _toSession(data);
  }

  Future<void> endSession(String code) async {
    await _client.delete('/sessions/$code');
  }

  static SessionActivity _toSession(Map<String, dynamic> j) {
    final parts = (j['participants'] as List? ?? [])
        .map((p) => SessionParticipant(
              id: (p['id'] ?? '').toString(),
              name: p['nom'] as String? ?? '',
            ))
        .toList();

    final msgs = (j['messages'] as List? ?? [])
        .map((m) => SessionMessage(
              id: (m['id'] ?? '').toString(),
              authorId: (m['auteurId'] ?? '').toString(),
              authorName: m['auteurNom'] as String? ?? '',
              content: m['contenu'] as String? ?? '',
              sentAt: DateTime.tryParse(m['dateEnvoi'] as String? ?? '') ??
                  DateTime.now(),
            ))
        .toList();

    return SessionActivity(
      id: (j['id'] ?? '').toString(),
      code: j['code'] as String? ?? '',
      resourceId: (j['ressourceId'] ?? '').toString(),
      resourceTitle: j['ressourceTitre'] as String? ?? '',
      creatorId: (j['createurId'] ?? '').toString(),
      creatorName: j['createurNom'] as String? ?? '',
      participants: parts,
      messages: msgs,
      isActive: (j['statut'] as String? ?? 'ACTIVE') == 'ACTIVE',
      createdAt: DateTime.tryParse(j['dateCreation'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
