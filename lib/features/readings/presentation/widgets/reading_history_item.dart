import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/glucose_level.dart';
import '../../domain/sugar_reading.dart';
import 'glucose_level_style.dart';

class ReadingHistoryItem extends StatelessWidget {
  const ReadingHistoryItem({
    super.key,
    required this.reading,
    required this.minTarget,
    required this.maxTarget,
  });

  final SugarReading reading;
  final int minTarget;
  final int maxTarget;

  @override
  Widget build(BuildContext context) {
    final level = GlucoseLevel.classify(
      reading.value,
      minTarget: minTarget,
      maxTarget: maxTarget,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: level.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${reading.value} mg/dL',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormatter.format(reading.time),
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: level.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              level.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
