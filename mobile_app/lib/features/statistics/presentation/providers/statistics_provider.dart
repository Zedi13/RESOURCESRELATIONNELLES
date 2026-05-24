import 'package:flutter/material.dart';
import '../../domain/entities/statistics.dart';
import '../../domain/repositories/statistics_repository.dart';

class StatisticsProvider extends ChangeNotifier {
  final StatisticsRepository _repository;
  StatisticsProvider(this._repository);

  AppStatistics? _statistics;
  bool isLoading = false;
  bool isExporting = false;
  String? error;

  AppStatistics? get statistics => _statistics;

  Future<void> loadStatistics() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      _statistics = await _repository.getStatistics();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> exportCsv() async {
    isExporting = true;
    notifyListeners();
    try {
      return await _repository.exportCsv();
    } catch (_) {
      return null;
    } finally {
      isExporting = false;
      notifyListeners();
    }
  }
}
