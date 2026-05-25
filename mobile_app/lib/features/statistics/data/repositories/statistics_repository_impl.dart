import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_remote_datasource.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDatasource _datasource;
  StatisticsRepositoryImpl(this._datasource);

  @override
  Future<AppStatistics> getStatistics() => _datasource.getStatistics();

  @override
  Future<String> exportCsv() => _datasource.exportCsv();
}
