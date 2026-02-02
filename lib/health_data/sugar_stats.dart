import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/sugar_provider.dart';
import 'package:blood_sugar_app_1/widgets/add_sugar_dialog.dart';
import '../models/sugar_reading_model.dart';
import 'sugar_stats_calculator.dart';
import 'package:blood_sugar_app_1/widgets/sugar_history_list.dart';
import 'package:blood_sugar_app_1/settings/settings_page.dart';
import 'package:blood_sugar_app_1/settings/settings_storage.dart';

enum ChartType { bar, line, history }

class SugarStats extends ConsumerStatefulWidget {
  const SugarStats({super.key});

  @override
  ConsumerState<SugarStats> createState() => _SugarStatsState();
}

class _SugarStatsState extends ConsumerState<SugarStats> {
  ChartType _selected = ChartType.bar;

  double minTarget = 70;
  double maxTarget = 140;

  @override
  void initState() {
    super.initState();
    loadTargets();
  }

  Future<void> loadTargets() async {
    final min = await SettingsStorage.getMinSugar();
    final max = await SettingsStorage.getMaxSugar();

    if (!mounted) return;

    setState(() {
      minTarget = min.toDouble();
      maxTarget = max.toDouble();
    });

    debugPrint("🔁 Reload Targets → min: $minTarget | max: $maxTarget");
  }

  // --- الرسوم البيانية ---

  Widget _buildBarChart(SugarStatsCalculator calculator) {
    final displayed = calculator.last7Readings;
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 250,
        barTouchData: BarTouchData(enabled: true),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(
          displayed.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: displayed[i].value.toDouble(),
                width: 18,
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [AppColors.primaryLight, AppColors.primaryDark],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(SugarStatsCalculator calculator) {
    final sorted = calculator.sortedByTime;
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              sorted.length,
              (i) => FlSpot(i.toDouble(), sorted[i].value.toDouble()),
            ),
            isCurved: true,
            barWidth: 4,
            color: AppColors.primaryDark,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLight.withOpacity(0.3),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sugarAsync = ref.watch(sugarProvider);
    final readings = sugarAsync.value ?? [];
    final calculator = SugarStatsCalculator(readings);
    final sorted = calculator.sortedByTime;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Blood Sugar', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );

              // 🔥 لما يرجع من Settings
              await loadTargets();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(calculator),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildMainToggleButton(
                    "Statistics",
                    isActive:
                        _selected == ChartType.bar ||
                        _selected == ChartType.line,
                    onTap: () => setState(() => _selected = ChartType.bar),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMainToggleButton(
                    "History",
                    isActive: _selected == ChartType.history,
                    onTap: () => setState(() => _selected = ChartType.history),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHeaderIcons(),
                      const SizedBox(height: 24),
                      Expanded(
                        child: readings.isEmpty && sugarAsync.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : readings.isEmpty
                            ? const Center(child: Text("No data available"))
                            : _buildMainContent(calculator, sorted),
                      ),
                      const SizedBox(height: 16),
                      _buildAddButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
    SugarStatsCalculator calculator,
    List<SugarReading> sorted,
  ) {
    switch (_selected) {
      case ChartType.bar:
        return _buildBarChart(calculator);
      case ChartType.line:
        return _buildLineChart(calculator);
      case ChartType.history:
        return SugarHistoryList(
          readings: sorted,
          minTarget: minTarget,
          maxTarget: maxTarget,
        );
    }
  }

  Widget _buildMainToggleButton(
    String title, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return isActive
        ? ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(title, style: const TextStyle(color: Colors.white)),
          )
        : OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(title, style: const TextStyle(color: Colors.black)),
          );
  }

  Widget _buildHeaderIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Blood sugar (mg/dL)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        Row(
          children: [
            _chartTypeIcon(Icons.bar_chart, ChartType.bar),
            const SizedBox(width: 8),
            _chartTypeIcon(Icons.show_chart, ChartType.line),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(SugarStatsCalculator calculator) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card(
          margin: const EdgeInsets.all(16),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Blood Sugar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  "Lifetime summary",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                      calculator.average.toStringAsFixed(1),
                      "Average",
                    ),
                    _buildStat(calculator.maxValue.toString(), "Max"),
                    _buildStat(calculator.minValue.toString(), "Min"),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 10,
          child: Image.asset(
            "asset/image/bubble.png",
            width: 80,
            height: 80,
            errorBuilder: (_, __, ___) => const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () =>
          showDialog(context: context, builder: (_) => const AddSugarDialog()),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(150, 45),
      ),
      child: const Text("Add Reading"),
    );
  }

  Widget _chartTypeIcon(IconData icon, ChartType type) {
    return GestureDetector(
      onTap: () => setState(() => _selected = type),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _selected == type ? AppColors.primaryDark : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: _selected == type ? Colors.white : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
