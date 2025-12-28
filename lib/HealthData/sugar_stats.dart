import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/sugar_provider.dart';
import 'package:blood_sugar_app_1/widgets/add_sugar_dialog.dart';

import '../models/sugar_reading_model.dart';

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

enum ChartType { bar, line }

class SugarStats extends ConsumerStatefulWidget {
  const SugarStats({super.key});

  @override
  _SugarStatsState createState() => _SugarStatsState();
}

class _SugarStatsState extends ConsumerState<SugarStats> {
  Widget _buildBarChart(List<SugarReading> readings) {
    final displayed = readings.length > 7
        ? readings.sublist(readings.length - 7)
        : readings;
    final maxValue = displayed
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue + 20,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        barGroups: List.generate(
          displayed.length,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: displayed[i].value.toDouble(),
                width: 28,
                borderRadius: BorderRadius.circular(12),
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

  Widget _buildLineChart(List<double> weeklyData) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              weeklyData.length,
              (i) => FlSpot(i.toDouble(), weeklyData[i]),
            ),
            isCurved: true,
            barWidth: 4,
            color: AppColors.primaryDark,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  int _selectedTab = 1;
  ChartType _selected = ChartType.bar;

  @override
  Widget build(BuildContext context) {
    final sugarAsync = ref.watch(sugarProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 9,
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
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // _buildStat("90.6", "Average"),
                          // _buildStat("132.5", "Maximum"),
                          // _buildStat("74.9", "Minimum"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -2,
                right: 0,
                child: Image.asset(
                  "asset/image/bubble.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // زر Statistics
                _selected == ChartType.bar
                    ? ElevatedButton(
                        onPressed: () =>
                            setState(() => _selected = ChartType.bar),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            251,
                            68,
                            82,
                          ),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(170, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("Statistics"),
                      )
                    : OutlinedButton(
                        onPressed: () =>
                            setState(() => _selected = ChartType.bar),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: BorderSide(color: AppColors.border),
                          minimumSize: const Size(170, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Statistics"),
                      ),
                const SizedBox(width: 10),
                // زر History
                _selected == ChartType.line
                    ? ElevatedButton(
                        onPressed: () =>
                            setState(() => _selected = ChartType.line),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            251,
                            68,
                            82,
                          ),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(170, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text("History"),
                      )
                    : OutlinedButton(
                        onPressed: () =>
                            setState(() => _selected = ChartType.line),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: BorderSide(color: AppColors.border),
                          minimumSize: const Size(170, 40),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("History"),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Blood sugar(mg/dL)",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _selected == ChartType.bar
                                      ? AppColors.primaryDark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () =>
                                      setState(() => _selected = ChartType.bar),
                                  icon: const Icon(
                                    Icons.bar_chart,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _selected == ChartType.line
                                      ? AppColors.primaryDark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () => setState(
                                    () => _selected = ChartType.line,
                                  ),
                                  icon: const Icon(
                                    Icons.show_chart,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chevron_left),
                          ),
                          // const Text(
                          //   "Dec 16 - Dec 22, 2024",
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: sugarAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Center(child: Text('Error: $e')),
                          data: (readings) {
                            if (readings.isEmpty) {
                              return const Center(child: Text('No data yet'));
                            }

                            return _buildBarChart(readings);
                          },
                        ),
                      ),

                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const AddSugarDialog(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              251,
                              68,
                              82,
                            ),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(170, 40),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                            alignment: Alignment.bottomCenter,
                          ),
                          child: const Text("add"),
                        ),
                      ),
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
}
