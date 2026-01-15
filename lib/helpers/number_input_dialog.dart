import 'package:flutter/material.dart';

Future<int?> showNumberInputDialog({
  required BuildContext context,
  required String title,
  required int initialValue,
  int min = 1,
  int max = 120,
}) {
  final controller = TextEditingController(text: initialValue.toString());

  return showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '$min - $max',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= min && value <= max) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
