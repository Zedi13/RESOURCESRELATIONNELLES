import '../../domain/entities/statistics.dart';
import '../../../../core/network/api_client.dart';

class StatisticsRemoteDatasource {
  final ApiClient _client;
  StatisticsRemoteDatasource(this._client);

  Future<AppStatistics> getStatistics() async {
    final j =
        await _client.get('/statistiques') as Map<String, dynamic>;
    return AppStatistics(
      totalResources: (j['totalRessources'] as num? ?? 0).toInt(),
      totalPublishedResources: (j['ressourcesPubliees'] as num? ?? 0).toInt(),
      totalUsers: (j['totalUtilisateurs'] as num? ?? 0).toInt(),
      totalViews: (j['totalVues'] as num? ?? 0).toInt(),
      totalShares: (j['totalPartages'] as num? ?? 0).toInt(),
      totalComments: (j['totalCommentaires'] as num? ?? 0).toInt(),
      viewsByCategory:
          _toIntMap(j['ressourcesParCategorie'] as Map<String, dynamic>? ?? {}),
      resourcesByType:
          _toIntMap(j['ressourcesParType'] as Map<String, dynamic>? ?? {}),
      monthlyStats: _toMonthly(j['statsParMois'] as List? ?? const []),
    );
  }

  Future<String> exportCsv() => _client.getRaw('/statistiques/export');

  static Map<String, int> _toIntMap(Map<String, dynamic> raw) =>
      raw.map((k, v) => MapEntry(k, (v as num).toInt()));

  static List<MonthlyStats> _toMonthly(List items) {
    return items.map((e) {
      final j = e as Map<String, dynamic>;
      final mois = j['mois'] as int? ?? 1;
      final annee = j['annee'] as int? ?? DateTime.now().year;
      return MonthlyStats(
        month: '$annee-${mois.toString().padLeft(2, '0')}',
        views: (j['vues'] as num? ?? 0).toInt(),
        creations: (j['ressourcesCrees'] as num? ?? 0).toInt(),
        newUsers: 0,
      );
    }).toList();
  }
}
