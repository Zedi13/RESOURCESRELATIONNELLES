import 'package:flutter/material.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsProvider extends ChangeNotifier {
  final StatisticsRepository _repository;

  StatisticsProvider(this._repository);

  AppStatistics getStatistics() => _repository.getStatistics();
}
