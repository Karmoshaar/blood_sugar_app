import 'package:blood_sugar_app_1/core/providers/sugar_provider.dart';
import 'package:blood_sugar_app_1/models/sugar_reading_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddSugarDialog extends ConsumerStatefulWidget {
  const AddSugarDialog({super.key});

  @override
  ConsumerState<AddSugarDialog> createState() => _AddSugarDialogState();
}

class _AddSugarDialogState extends ConsumerState<AddSugarDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Sugar Reading'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Blood sugar (mg/dL)',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _submit() {
    final valueStr = _controller.text;
    final value = int.tryParse(valueStr);

    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    final reading = SugarReading(
      value: value,
      type: 'Random',
      time: DateTime.now(),
    );

    // Add reading optimistically (updates UI immediately, API call happens in background)
    ref.read(sugarProvider.notifier).addReading(reading);
    
    // Close dialog immediately - no waiting
    Navigator.pop(context);
  }
}
