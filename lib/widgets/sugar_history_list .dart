import 'package:flutter/material.dart';
import '../models/sugar_reading_model.dart';

class SugarHistoryList extends StatelessWidget {
  final List<SugarReading> readings;

  const SugarHistoryList({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: readings.length,
      itemBuilder: (context, index) {
        final r = readings[index];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: const Icon(Icons.bloodtype),
            title: Text("${r.value} mg/dL"),
            subtitle: Text(r.time.toString()),
          ),
        );
      },
    );
  }
}
