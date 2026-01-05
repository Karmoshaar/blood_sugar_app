import 'package:flutter/material.dart';
import '../models/sugar_reading_model.dart';
import 'package:blood_sugar_app_1/widgets/sugar_item_history.dart';

class SugarHistoryList extends StatelessWidget {
  final List<SugarReading> readings;

  const SugarHistoryList({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: readings.length,
      itemBuilder: (context, index) {
        final r = readings[readings.length - 1 - index];
        return SugarHistoryItem(reading: r);
      },
    );
  }
}

