import 'package:flutter/material.dart';
import '../models/sugar_reading_model.dart';

class SugarHistoryList extends StatelessWidget {
  final List<SugarReading> readings;

  const SugarHistoryList({super.key, required this.readings});

  @override
  Widget build(BuildContext context) {
    // تم تغيير ListView إلى ListView.builder مع وضع أبعاد محددة أو استخدام Expanded
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: readings.length,
      itemBuilder: (context, index) {
        // ترتيب تنازلي (الأحدث أولاً)
        final r = readings[readings.length - 1 - index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFFB4452),
              child: Icon(Icons.bloodtype, color: Colors.white),
            ),
            title: Text(
              "${r.value} mg/dL",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${r.time.day}/${r.time.month}/${r.time.year} - ${r.time.hour}:${r.time.minute}",
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}
