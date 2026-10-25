import 'package:flutter/material.dart';

import '../../domain/sugar_reading.dart';
import 'reading_history_item.dart';

/// Readings newest first, coloured against the target range.
class ReadingHistoryList extends StatelessWidget {
  const ReadingHistoryList({
    super.key,
    required this.readings,
    required this.minTarget,
    required this.maxTarget,
  });

  /// Oldest first, as produced by `ReadingStats.sortedByTime`.
  final List<SugarReading> readings;
  final int minTarget;
  final int maxTarget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: readings.length,
      itemBuilder: (context, index) => ReadingHistoryItem(
        reading: readings[readings.length - 1 - index],
        minTarget: minTarget,
        maxTarget: maxTarget,
      ),
    );
  }
}
