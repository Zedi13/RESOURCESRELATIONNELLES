import '../entities/statistics.dart';

abstract class StatisticsRepository {
  Future<AppStatistics> getStatistics();
  Future<String> exportCsv();
}
