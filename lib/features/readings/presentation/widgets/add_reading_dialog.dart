import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/sugar_reading.dart';
import '../providers/readings_controller.dart';

class AddReadingDialog extends ConsumerStatefulWidget {
  const AddReadingDialog({super.key});

  @override
  ConsumerState<AddReadingDialog> createState() => _AddReadingDialogState();
}

class _AddReadingDialogState extends ConsumerState<AddReadingDialog> {
  /// Range a home glucose meter can report, in mg/dL.
  static const _minValue = 20;
  static const _maxValue = 600;

  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Sugar Reading'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Blood sugar (mg/dL)',
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }

  Future<void> _submit() async {
    final value = int.tryParse(_controller.text.trim());
    if (value == null || value < _minValue || value > _maxValue) {
      setState(
        () => _error = 'Enter a number between $_minValue and $_maxValue',
      );
      return;
    }

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    navigator.pop();
    try {
      await ref
          .read(readingsProvider.notifier)
          .add(SugarReading(value: value, time: DateTime.now()));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not save the reading')),
      );
    }
  }
}
