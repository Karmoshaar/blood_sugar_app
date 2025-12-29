import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/sugar_provider.dart';
import 'package:blood_sugar_app_1/widgets/add_sugar_dialog.dart';
import '../models/sugar_reading_model.dart';
import 'sugar_stats_calculator.dart'; // استيراد الكلاس من الملف الخارجي

class SugarStats extends ConsumerStatefulWidget {
  const SugarStats({super.key});

  @override
  ConsumerState<SugarStats> createState() => _SugarStatsState();
}

class _SugarStatsState extends ConsumerState<SugarStats> {
  ChartType _selected = ChartType.bar;

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

  // استخدام SugarStatsCalculator كمعامل
  Widget _statsRow(SugarStatsCalculator calculator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat(calculator.average.toStringAsFixed(1), "Average"),
        _buildStat(calculator.maxValue.toString(), "Max"),
        _buildStat(calculator.minValue.toString(), "Min"),
      ],
    );
  }

  Widget _buildBarChart(List<SugarReading> readings) {
    // استخدام المنطق الموجود داخل الـ Calculator
    final calculator = SugarStatsCalculator(readings);
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

  Widget _buildLineChart(List<SugarReading> readings) {
    final calculator = SugarStatsCalculator(readings);
    final data = calculator.sortedByTime
        .map((e) => e.value.toDouble())
        .toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (i) => FlSpot(i.toDouble(), data[i]),
            ),
            isCurved: true,
            barWidth: 4,
            color: AppColors.primaryDark,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sugarAsync = ref.watch(sugarProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: sugarAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (readings) {
          // إنشاء كائن من الكلاس الخارجي
          final calculator = SugarStatsCalculator(readings);

          return Column(
            children: [
              Stack(
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Lifetime summary",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _statsRow(calculator),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildToggleButton("Statistics", ChartType.bar),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildToggleButton("History", ChartType.line),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Blood sugar (mg/dL)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  _chartTypeIcon(
                                    Icons.bar_chart,
                                    ChartType.bar,
                                  ),
                                  const SizedBox(width: 8),
                                  _chartTypeIcon(
                                    Icons.show_chart,
                                    ChartType.line,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: readings.isEmpty
                                ? const Center(child: Text("No data available"))
                                : (_selected == ChartType.bar
                                      ? _buildBarChart(readings)
                                      : _buildLineChart(readings)),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => const AddSugarDialog(),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(150, 45),
                            ),
                            child: const Text("Add Reading"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToggleButton(String title, ChartType type) {
    bool isSelected = _selected == type;
    return isSelected
        ? ElevatedButton(
            onPressed: () => setState(() => _selected = type),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(title, style: const TextStyle(color: Colors.white)),
          )
        : OutlinedButton(
            onPressed: () => setState(() => _selected = type),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(title, style: const TextStyle(color: Colors.black)),
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

enum ChartType { bar, line }
