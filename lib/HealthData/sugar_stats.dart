import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

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

enum ChartType {
  bar,
  line,
}

class SugarStats extends StatefulWidget {
  const SugarStats({super.key});

  @override
  _SugarStatsState createState() => _SugarStatsState();
}

class _SugarStatsState extends State<SugarStats> {
  int _selectedTab = 1;
  ChartType _selected = ChartType.bar;
  final List<double> weeklyData = [110, 95, 130, 120, 150, 100, 90];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                          _buildStat("90.6", "Average"),
                          _buildStat("132.5", "Maximum"),
                          _buildStat("74.9", "Minimum"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -2,
                right: -5,
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
                  onPressed: () => setState(() => _selected = ChartType.bar),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 251, 68, 82),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(170, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("Statistics"),
                )
                    : OutlinedButton(
                  onPressed: () => setState(() => _selected = ChartType.bar),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey.shade300),
                    minimumSize: const Size(170, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  onPressed: () => setState(() => _selected = ChartType.line),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 251, 68, 82),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(170, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text("History"),
                )
                    : OutlinedButton(
                  onPressed: () => setState(() => _selected = ChartType.line),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey.shade300),
                    minimumSize: const Size(170, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                                  color: _selected == ChartType.line
                                      ? Colors.grey[200]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  onPressed: () => setState(() => _selected = ChartType.line),
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
                                  color: const Color.fromARGB(255, 251, 68, 82),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 20,
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
                          const Text(
                            "Dec 16 - Dec 22, 2024",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _selected == ChartType.bar
                            ? BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 200,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                                    return Text(days[value.toInt()]);
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            barGroups: List.generate(
                              weeklyData.length,
                                  (i) => BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: weeklyData[i],
                                    color: const Color.fromARGB(255, 251, 68, 82),
                                    width: 20,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            : LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                                    if (value.toInt() >= 0 && value.toInt() < 7) {
                                      return Text(days[value.toInt()]);
                                    }
                                    return const Text("");
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  weeklyData.length,
                                      (i) => FlSpot(i.toDouble(), weeklyData[i]),
                                ),
                                isCurved: true,
                                color: const Color.fromARGB(255, 251, 68, 82),
                                barWidth: 4,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
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
