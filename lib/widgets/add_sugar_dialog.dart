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
  bool _isLoading = false;

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
          onPressed: _isLoading
              ? null
              : () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final valueStr = _controller.text;
    final value = int.tryParse(valueStr);

    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reading = SugarReading(
        value: value,
        type: 'Random', // يمكنك تغيير النوع حسب الحاجة
        time: DateTime.now(),
      );

      // استدعاء الـ provider لإضافة البيانات
      await ref.read(sugarProvider.notifier).addReading(reading);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
