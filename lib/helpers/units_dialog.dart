import 'package:flutter/material.dart';

Future<String?> showUnitsDialog(
    BuildContext context,
    String currentUnit,
    ) {
  String selected = currentUnit;

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Blood Sugar Units'),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selected),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
