import 'package:flutter/material.dart';

Future<double?> showTargetDialog({
  required BuildContext context,
  required String title,
  required double initialValue,
  required double min,
  required double max,
}) async {
  double tempValue = initialValue;

  return showDialog<double>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${tempValue.toInt()} mg/dL',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  min: min,
                  max: max,
                  divisions: (max - min).toInt(),
                  value: tempValue,
                  onChanged: (v) {
                    setState(() => tempValue = v);
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, tempValue),
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
