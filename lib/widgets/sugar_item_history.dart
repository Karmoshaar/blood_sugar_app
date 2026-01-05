import 'package:flutter/material.dart';
import 'package:blood_sugar_app_1/core/utils/blood_level_analyzer.dart';
import 'package:blood_sugar_app_1/core/utils/blood_level_extension.dart';
import '../../../core/utils/date_formatter.dart';
import '../../models/sugar_reading_model.dart';

class SugarHistoryItem extends StatelessWidget {
  final SugarReading reading;

  String formatDate(DateTime date) {
    final now = DateTime.now();

    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final isYesterday =
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    final time = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

    if (isToday) {
      return "Today • $time";
    } else if (isYesterday) {
      return "Yesterday • $time";
    } else {
      return "${date.day}/${date.month}/${date.year} • $time";
    }
  }

  const SugarHistoryItem({super.key, required this.reading});

  @override
  Widget build(BuildContext context) {
    final status = BloodLevelAnalyzer.getLevel(reading.value);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
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

          // Status pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status.label,
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
