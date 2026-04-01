import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../providers/statistics_provider.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stats =
        context.read<StatisticsProvider>().getStatistics();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Export en cours...'),
                    duration: Duration(seconds: 2)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatBadge(
                  icon: Icons.library_books,
                  value: '${stats.totalPublishedResources}',
                  label: 'Ressources\npubliées',
                  color: AppTheme.tertiary,
                ),
                StatBadge(
                  icon: Icons.people,
                  value: '${stats.totalUsers}',
                  label: 'Utilisateurs\ninscrits',
                  color: AppTheme.primary,
                ),
                StatBadge(
                  icon: Icons.visibility,
                  value: _formatNumber(stats.totalViews),
                  label: 'Consultations\ntotales',
                  color: AppTheme.success,
                ),
                StatBadge(
                  icon: Icons.share,
                  value: _formatNumber(stats.totalShares),
                  label: 'Partages\ntotaux',
                  color: AppTheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Monthly views chart
            const SectionTitle(title: 'Consultations mensuelles'),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: stats.monthlyStats
                          .map((s) => s.views.toDouble())
                          .reduce((a, b) => a > b ? a : b) *
                      1.2,
                  barGroups: stats.monthlyStats.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.views.toDouble(),
                          color: AppTheme.primary,
                          width: 22,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 ||
                              idx >= stats.monthlyStats.length) {
                            return const SizedBox();
                          }
                          return Text(
                            stats.monthlyStats[idx].month,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            _formatNumber(value.toInt()),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade100,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Resources by type (pie chart)
            const SectionTitle(title: 'Ressources par type'),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieSections(stats.resourcesByType),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildLegend(stats.resourcesByType),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Views by category
            const SectionTitle(title: 'Consultations par catégorie'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: stats.viewsByCategory.entries.map((entry) {
                  final total = stats.totalViews;
                  final pct = total > 0 ? entry.value / total : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${entry.value} vues',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: pct,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.tertiary),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(Map<String, int> data) {
    final colors = [
      AppTheme.primary,
      AppTheme.secondary,
      AppTheme.tertiary,
      AppTheme.success,
      AppTheme.warning,
    ];
    final total = data.values.fold(0, (a, b) => a + b);
    return data.entries.toList().asMap().entries.map((e) {
      final pct = total > 0 ? e.value.value / total * 100 : 0;
      return PieChartSectionData(
        value: e.value.value.toDouble(),
        title: '${pct.toStringAsFixed(0)}%',
        color: colors[e.key % colors.length],
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegend(Map<String, int> data) {
    final colors = [
      AppTheme.primary,
      AppTheme.secondary,
      AppTheme.tertiary,
      AppTheme.success,
      AppTheme.warning,
    ];
    return data.entries.toList().asMap().entries.map((e) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colors[e.key % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${e.value.key}: ${e.value.value}',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}
