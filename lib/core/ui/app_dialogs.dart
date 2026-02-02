import 'package:flutter/material.dart';

class AppDialogs {
  AppDialogs._();

  static Future<T?> showBase<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    required VoidCallback onSave,
    String cancelText = 'Cancel',
    String saveText = 'Save',
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(cancelText),
          ),
          ElevatedButton(onPressed: onSave, child: Text(saveText)),
        ],
      ),
    );
  }

  static Future<int?> numberInput({
    required BuildContext context,
    required String title,
    required int initialValue,
    int min = 1,
    int max = 120,
  }) {
    final controller = TextEditingController(text: initialValue.toString());

    return showBase<int>(
      context: context,
      title: title,
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: '$min - $max'),
      ),
      onSave: () {
        final value = int.tryParse(controller.text);
        if (value != null && value >= min && value <= max) {
          Navigator.pop(context, value);
        }
      },
    );
  }

  static Future<String?> units(BuildContext context, String currentUnit) {
    String selected = currentUnit;

    return showBase<String>(
      context: context,

      title: 'Blood Sugar Units',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('mg/dL'),
                value: 'mg/dL',
                groupValue: selected,
                onChanged: (v) => setState(() => selected = v!),
              ),
              RadioListTile<String>(
                title: const Text('mmol/L'),
                value: 'mmol/L',
                groupValue: selected,
                onChanged: (v) => setState(() => selected = v!),
              ),
            ],
          );
        },
      ),
      onSave: () => Navigator.pop(context, selected),
    );
  }

  static Future<double?> target({
    required BuildContext context,
    required String title,
    required double initialValue,
    required double min,
    required double max,
  }) {
    double tempValue = initialValue;

    return showBase<double>(
      context: context,

      title: title,
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
      onSave: () => Navigator.pop(context, tempValue),
    );
  }

  static Future<double?> weight(BuildContext context, double initialValue) {
    final controller = TextEditingController(
      text: initialValue.toInt().toString(),
    );

    return showBase<double>(
      context: context,
      title: 'Weight (kg)',
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'Enter your weight'),
      ),
      onSave: () {
        final value = double.tryParse(controller.text);
        if (value != null) {
          Navigator.pop(context, value);
        }
      },
    );
  }
}
