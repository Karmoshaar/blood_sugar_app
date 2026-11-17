import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../settings/domain/app_settings.dart';
import '../../domain/glucose_level.dart';
import '../../domain/sugar_reading.dart';
import 'glucose_level_style.dart';
import 'reading_context_label.dart';

class ReadingHistoryItem extends StatelessWidget {
  const ReadingHistoryItem({
    super.key,
    required this.reading,
    required this.settings,
    this.onTap,
  });

  final SugarReading reading;
  final AppSettings settings;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final level = GlucoseLevel.classify(
      reading.value,
      minTarget: settings.minTarget,
      maxTarget: settings.maxTarget,
    );
    final unit = settings.unit;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Material(
        color: level.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${unit.format(reading.value)} ${unit.label}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${reading.context.label} · '
                        '${DateFormatter.format(reading.time)}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
          ),
        ),
      ),
    );
  }
}
