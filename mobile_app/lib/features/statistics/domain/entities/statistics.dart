class MonthlyStats {
  final String month;
  final int views;
  final int creations;
  final int newUsers;

  const MonthlyStats({
    required this.month,
    required this.views,
    required this.creations,
    required this.newUsers,
  });
}

class AppStatistics {
  final int totalResources;
  final int totalPublishedResources;
  final int totalUsers;
  final int totalViews;
  final int totalShares;
  final int totalComments;
  final Map<String, int> viewsByCategory;
  final Map<String, int> resourcesByType;
  final List<MonthlyStats> monthlyStats;

  const AppStatistics({
    required this.totalResources,
    required this.totalPublishedResources,
    required this.totalUsers,
    required this.totalViews,
    required this.totalShares,
    required this.totalComments,
    required this.viewsByCategory,
    required this.resourcesByType,
    required this.monthlyStats,
  });
}
