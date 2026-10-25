import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/sugar_reading.dart';

const _hiddenTitles = FlTitlesData(
  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
);

class ReadingsBarChart extends StatelessWidget {
  const ReadingsBarChart({super.key, required this.readings});

  final List<SugarReading> readings;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 250,
        barTouchData: BarTouchData(enabled: true),
        titlesData: _hiddenTitles,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (var i = 0; i < readings.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: readings[i].value.toDouble(),
                  width: 18,
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.primaryDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ReadingsLineChart extends StatelessWidget {
  const ReadingsLineChart({super.key, required this.readings});

  final List<SugarReading> readings;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: _hiddenTitles,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < readings.length; i++)
                FlSpot(i.toDouble(), readings[i].value.toDouble()),
            ],
            isCurved: true,
            barWidth: 4,
            color: AppColors.primaryDark,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryLight.withValues(alpha: 0.3),
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
}
