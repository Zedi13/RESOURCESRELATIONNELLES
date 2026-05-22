import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../datasources/statistics_local_datasource.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsLocalDatasource _datasource;

  StatisticsRepositoryImpl(this._datasource);

  @override
  AppStatistics getStatistics() => _datasource.getStatistics();
}
