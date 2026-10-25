import 'package:flutter/material.dart';

import '../../domain/app_settings.dart';

/// Small edit dialogs used by the settings screen. Each returns the new
/// value, or null when the user cancels.
class SettingsDialogs {
  SettingsDialogs._();

  static Future<T?> _showBase<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    required void Function(BuildContext dialogContext) onSave,
  }) {
    return showDialog<T>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => onSave(dialogContext),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  static Future<String?> text({
    required BuildContext context,
    required String title,
    required String initialValue,
    String? hint,
  }) {
    final controller = TextEditingController(text: initialValue);

    return _showBase<String>(
      context: context,
      title: title,
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(hintText: hint),
      ),
      onSave: (dialogContext) {
        final value = controller.text.trim();
        if (value.isNotEmpty) Navigator.pop(dialogContext, value);
      },
    );
  }

  static Future<int?> number({
    required BuildContext context,
    required String title,
    required int initialValue,
    required int min,
    required int max,
  }) {
    final controller = TextEditingController(text: initialValue.toString());

    return _showBase<int>(
      context: context,
      title: title,
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: '$min - $max'),
      ),
      onSave: (dialogContext) {
        final value = int.tryParse(controller.text);
        if (value != null && value >= min && value <= max) {
          Navigator.pop(dialogContext, value);
        }
      },
    );
  }

  static Future<GlucoseUnit?> unit(
    BuildContext context,
    GlucoseUnit currentUnit,
  ) {
    var selected = currentUnit;

    return _showBase<GlucoseUnit>(
      context: context,
      title: 'Blood Sugar Units',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final unit in GlucoseUnit.values)
                RadioListTile<GlucoseUnit>(
                  title: Text(unit.label),
                  value: unit,
                  // ignore: deprecated_member_use
                  groupValue: selected,
                  // ignore: deprecated_member_use
                  onChanged: (v) => setState(() => selected = v!),
                ),
            ],
          );
        },
      ),
      onSave: (dialogContext) => Navigator.pop(dialogContext, selected),
    );
  }

  static Future<int?> target({
    required BuildContext context,
    required String title,
    required int initialValue,
    required int min,
    required int max,
  }) {
    var tempValue = initialValue.clamp(min, max).toDouble();

    return _showBase<int>(
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
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: max - min,
                value: tempValue,
                onChanged: (v) => setState(() => tempValue = v),
              ),
            ],
          );
        },
      ),
      onSave: (dialogContext) =>
          Navigator.pop(dialogContext, tempValue.toInt()),
    );
  }
}
