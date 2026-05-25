import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../../core/utils/download_helper.dart';
import '../../domain/entities/statistics.dart';
import '../providers/statistics_provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int _periodFilter = 0; // 0 = tout, 3/6/12 = N derniers mois
  Set<String> _selectedCategories = {};  // vide = tout afficher
  Set<String> _selectedTypes = {};       // vide = tout afficher

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatisticsProvider>().loadStatistics();
    });
  }

  // API retourne DESC (plus récent en premier) — on prend N puis on inverse
  List<MonthlyStats> _applyPeriodFilter(List<MonthlyStats> all) {
    final sorted = all.toList(); // déjà DESC depuis l'API
    final limited = (_periodFilter == 0 || sorted.length <= _periodFilter)
        ? sorted
        : sorted.take(_periodFilter).toList();
    return limited.reversed.toList(); // ASC pour le graphique
  }

  Map<String, int> _applyTypeFilter(Map<String, int> data) {
    if (_selectedTypes.isEmpty) return data;
    return Map.fromEntries(
        data.entries.where((e) => _selectedTypes.contains(e.key)));
  }

  Map<String, int> _applyCategoryFilter(Map<String, int> data) {
    if (_selectedCategories.isEmpty) return data;
    return Map.fromEntries(
        data.entries.where((e) => _selectedCategories.contains(e.key)));
  }

  Future<void> _export(BuildContext context) async {
    final provider = context.read<StatisticsProvider>();
    final csv = await provider.exportCsv();
    if (!mounted) return;
    if (csv != null) {
      triggerCsvDownload(csv, 'statistiques.csv');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Export CSV téléchargé'),
          backgroundColor: AppTheme.success,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'export'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StatisticsProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final stats = provider.statistics;
    if (stats == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Statistiques')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(provider.error ?? 'Impossible de charger les statistiques.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: provider.loadStatistics,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    final filteredMonthly = _applyPeriodFilter(stats.monthlyStats);
    final filteredTypes = _applyTypeFilter(stats.resourcesByType);
    final filteredCategories = _applyCategoryFilter(stats.viewsByCategory);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          if (provider.isExporting)
            const Padding(
              padding: EdgeInsets.all(14),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.download_outlined),
              tooltip: 'Exporter en CSV',
              onPressed: () => _export(context),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
            onPressed: provider.loadStatistics,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── KPI ──────────────────────────────────────────────
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
                  value: _fmt(stats.totalViews),
                  label: 'Consultations\ntotales',
                  color: AppTheme.success,
                ),
                StatBadge(
                  icon: Icons.share,
                  value: _fmt(stats.totalShares),
                  label: 'Partages\ntotaux',
                  color: AppTheme.secondary,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Graphique mensuel + filtre période ────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: SectionTitle(title: 'Consultations mensuelles'),
                ),
                _PeriodDropdown(
                  value: _periodFilter,
                  onChanged: (v) => setState(() => _periodFilter = v),
                ),
              ],
            ),
            // Indicateur du nombre de mois affichés
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Text(
                filteredMonthly.isEmpty
                    ? 'Aucune donnée disponible'
                    : '${filteredMonthly.length} mois affiché${filteredMonthly.length > 1 ? 's' : ''}'
                      ' sur ${stats.monthlyStats.length} disponible${stats.monthlyStats.length > 1 ? 's' : ''}',
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary),
              ),
            ),
            _Card(
              height: 220,
              child: filteredMonthly.isEmpty
                  ? const _Empty()
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: filteredMonthly
                                .map((s) => s.views.toDouble())
                                .reduce((a, b) => a > b ? a : b) *
                            1.3,
                        barGroups: filteredMonthly.asMap().entries.map((e) {
                          return BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.views.toDouble(),
                                color: AppTheme.primary,
                                width: _barWidth(filteredMonthly.length),
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(5)),
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
                                if (idx < 0 || idx >= filteredMonthly.length) {
                                  return const SizedBox();
                                }
                                final parts =
                                    filteredMonthly[idx].month.split('-');
                                final label = parts.length == 2
                                    ? '${_monthLabel(int.tryParse(parts[1]) ?? 1)}\n${parts[0]}'
                                    : filteredMonthly[idx].month;
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(label,
                                      style: const TextStyle(
                                          fontSize: 9,
                                          color: AppTheme.textSecondary),
                                      textAlign: TextAlign.center),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              getTitlesWidget: (value, meta) => Text(
                                _fmt(value.toInt()),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textSecondary),
                              ),
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          drawVerticalLine: false,
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

            // ── Ressources par type + filtre ─────────────────────
            const SectionTitle(title: 'Ressources par type'),
            const SizedBox(height: 8),
            if (stats.resourcesByType.isNotEmpty) ...[
              _FilterChips(
                allKeys: stats.resourcesByType.keys.toList(),
                selected: _selectedTypes,
                onToggle: (key) => setState(() {
                  if (key == '__clear__') { _selectedTypes.clear(); return; }
                  _selectedTypes.contains(key)
                      ? _selectedTypes.remove(key)
                      : _selectedTypes.add(key);
                }),
                color: AppTheme.secondary,
              ),
              const SizedBox(height: 8),
            ],
            filteredTypes.isEmpty
                ? const _Empty()
                : _Card(
                    height: 220,
                    child: Row(
                      children: [
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sections: _pieSections(filteredTypes),
                              sectionsSpace: 2,
                              centerSpaceRadius: 38,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _legend(filteredTypes),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 24),

            // ── Ressources par catégorie + filtre ─────────────────
            const SectionTitle(title: 'Ressources par catégorie'),
            const SizedBox(height: 8),
            if (stats.viewsByCategory.isNotEmpty) ...[
              _FilterChips(
                allKeys: stats.viewsByCategory.keys.toList(),
                selected: _selectedCategories,
                onToggle: (key) => setState(() {
                  if (key == '__clear__') { _selectedCategories.clear(); return; }
                  _selectedCategories.contains(key)
                      ? _selectedCategories.remove(key)
                      : _selectedCategories.add(key);
                }),
                color: AppTheme.tertiary,
              ),
              const SizedBox(height: 8),
            ],
            filteredCategories.isEmpty
                ? const _Empty()
                : _Card(
                    child: Column(
                      children: filteredCategories.entries.map((entry) {
                        final total = filteredCategories.values
                            .fold(0, (a, b) => a + b);
                        final pct =
                            total > 0 ? entry.value / total : 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(entry.key,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Text('${entry.value}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: pct,
                                backgroundColor: Colors.grey.shade100,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
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

  // ── Helpers ──────────────────────────────────────────────────────────────

  double _barWidth(int count) {
    if (count <= 3) return 28;
    if (count <= 6) return 22;
    if (count <= 12) return 16;
    return 10;
  }

  List<PieChartSectionData> _pieSections(Map<String, int> data) {
    const colors = [
      AppTheme.primary, AppTheme.secondary, AppTheme.tertiary,
      AppTheme.success, AppTheme.warning,
    ];
    final total = data.values.fold(0, (a, b) => a + b);
    return data.entries.toList().asMap().entries.map((e) {
      final pct = total > 0 ? e.value.value / total * 100 : 0;
      return PieChartSectionData(
        value: e.value.value.toDouble(),
        title: '${pct.toStringAsFixed(0)}%',
        color: colors[e.key % colors.length],
        radius: 58,
        titleStyle: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
      );
    }).toList();
  }

  List<Widget> _legend(Map<String, int> data) {
    const colors = [
      AppTheme.primary, AppTheme.secondary, AppTheme.tertiary,
      AppTheme.success, AppTheme.warning,
    ];
    return data.entries.toList().asMap().entries.map((e) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(
                color: colors[e.key % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text('${e.value.key}: ${e.value.value}',
                style: const TextStyle(fontSize: 11)),
          ],
        ),
      );
    }).toList();
  }

  String _fmt(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  String _monthLabel(int m) {
    const labels = ['Jan','Fév','Mar','Avr','Mai','Jun',
                    'Jul','Aoû','Sep','Oct','Nov','Déc'];
    return (m >= 1 && m <= 12) ? labels[m - 1] : '$m';
  }
}

// ── Sous-widgets ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  final double? height;

  const _Card({required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
      child: child,
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('Aucune donnée disponible',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      ),
    );
  }
}

class _PeriodDropdown extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _PeriodDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          isDense: true,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
          items: const [
            DropdownMenuItem(value: 3, child: Text('3 mois')),
            DropdownMenuItem(value: 6, child: Text('6 mois')),
            DropdownMenuItem(value: 12, child: Text('12 mois')),
            DropdownMenuItem(value: 0, child: Text('Tout')),
          ],
          onChanged: (v) { if (v != null) onChanged(v); },
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final List<String> allKeys;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final Color color;

  const _FilterChips({
    required this.allKeys,
    required this.selected,
    required this.onToggle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        // "Tout" chip
        FilterChip(
          label: const Text('Tout'),
          selected: selected.isEmpty,
          onSelected: (_) {
            // clear selection = show all
            if (selected.isNotEmpty) onToggle('__clear__');
          },
          selectedColor: color.withOpacity(0.15),
          checkmarkColor: color,
          labelStyle: TextStyle(
            fontSize: 12,
            color: selected.isEmpty ? color : AppTheme.textSecondary,
            fontWeight:
                selected.isEmpty ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        ...allKeys.map((key) {
          final isSelected = selected.contains(key);
          return FilterChip(
            label: Text(key),
            selected: isSelected,
            onSelected: (_) => onToggle(key),
            selectedColor: color.withOpacity(0.15),
            checkmarkColor: color,
            labelStyle: TextStyle(
              fontSize: 12,
              color: isSelected ? color : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        }),
      ],
    );
  }
}
