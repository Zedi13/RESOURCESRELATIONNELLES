import '../../domain/entities/statistics.dart';

class StatisticsLocalDatasource {
  AppStatistics getStatistics() {
    return const AppStatistics(
      totalResources: 12,
      totalPublishedResources: 10,
      totalUsers: 5,
      totalViews: 18950,
      totalShares: 2192,
      totalComments: 6,
      viewsByCategory: {
        'Communication': 3350,
        'Gestion des conflits': 873,
        'Développement personnel': 4143,
        'Parentalité': 943,
        'Vie de couple': 5558,
        'Amitié': 2789,
        'Vie professionnelle': 1234,
      },
      resourcesByType: {
        'Article': 8,
        'Audio': 1,
        'Activité': 1,
        'Podcast': 1,
        'Document': 1,
      },
      monthlyStats: [
        MonthlyStats(month: 'Oct', views: 890, creations: 1, newUsers: 1),
        MonthlyStats(month: 'Nov', views: 1240, creations: 2, newUsers: 1),
        MonthlyStats(month: 'Déc', views: 1680, creations: 1, newUsers: 0),
        MonthlyStats(month: 'Jan', views: 2340, creations: 3, newUsers: 2),
        MonthlyStats(month: 'Fév', views: 3120, creations: 3, newUsers: 1),
        MonthlyStats(month: 'Mar', views: 4890, creations: 4, newUsers: 0),
      ],
    );
  }
}
