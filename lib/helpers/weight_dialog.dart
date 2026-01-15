import 'package:flutter/material.dart';

Future<double?> showWeightDialog(
    BuildContext context,
    double initialValue,
    ) {
  final controller =
  TextEditingController(text: initialValue.toInt().toString());

  return showDialog<double>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Weight (kg)'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter your weight',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final value = double.tryParse(controller.text);
            if (value != null) {
              Navigator.pop(context, value);
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
