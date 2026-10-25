import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../settings/domain/app_settings.dart';
import '../../domain/sugar_reading.dart';

/// Values, axes and target band shared by both charts, in the display unit.
class _ChartScale {
  _ChartScale(List<SugarReading> readings, this.settings)
    : values = [for (final r in readings) settings.unit.fromMgDl(r.value)],
      dates = [for (final r in readings) r.time];

  final AppSettings settings;
  final List<double> values;
  final List<DateTime> dates;

  GlucoseUnit get unit => settings.unit;
  double get minTarget => unit.fromMgDl(settings.minTarget);
  double get maxTarget => unit.fromMgDl(settings.maxTarget);

  /// Leaves headroom above the highest reading or target.
  double get maxY => math.max(values.reduce(math.max), maxTarget) * 1.15;

  RangeAnnotations get targetBand => RangeAnnotations(
    horizontalRangeAnnotations: [
      HorizontalRangeAnnotation(
        y1: minTarget,
        y2: maxTarget,
        color: Colors.green.withValues(alpha: 0.12),
      ),
    ],
  );

  FlTitlesData titles({required double bottomInterval}) => FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          // Skip the top label: it is the padded max, not a real value.
          if (value == meta.max) return const SizedBox.shrink();
          return SideTitleWidget(
            meta: meta,
            child: Text(
              unit == GlucoseUnit.mgDl
                  ? value.round().toString()
                  : value.toStringAsFixed(1),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          );
        },
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        interval: bottomInterval,
        getTitlesWidget: (value, meta) {
          final i = value.round();
          if (i != value || i < 0 || i >= dates.length) {
            return const SizedBox.shrink();
          }
          return SideTitleWidget(
            meta: meta,
            child: Text(
              DateFormat('d/M').format(dates[i]),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          );
        },
      ),
    ),
  );
}

class ReadingsBarChart extends StatelessWidget {
  const ReadingsBarChart({
    super.key,
    required this.readings,
    required this.settings,
  });

  final List<SugarReading> readings;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final scale = _ChartScale(readings, settings);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: scale.maxY,
        barTouchData: BarTouchData(enabled: true),
        titlesData: scale.titles(bottomInterval: 1),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        rangeAnnotations: scale.targetBand,
        barGroups: [
          for (var i = 0; i < scale.values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: scale.values[i],
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
  const ReadingsLineChart({
    super.key,
    required this.readings,
    required this.settings,
  });

  final List<SugarReading> readings;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final scale = _ChartScale(readings, settings);
    // About five date labels whatever the number of readings.
    final bottomInterval = math.max(1, (readings.length / 5).ceil()).toDouble();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: scale.maxY,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: scale.titles(bottomInterval: bottomInterval),
        rangeAnnotations: scale.targetBand,
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (var i = 0; i < scale.values.length; i++)
                FlSpot(i.toDouble(), scale.values[i]),
            ],
            isCurved: true,
            preventCurveOverShooting: true,
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
