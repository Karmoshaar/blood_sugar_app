import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/providers/settings_controller.dart';
import '../../domain/sugar_reading.dart';
import '../providers/readings_controller.dart';
import 'reading_context_label.dart';

/// Adds a new reading, or edits [initial] when it is given.
class AddReadingDialog extends ConsumerStatefulWidget {
  const AddReadingDialog({super.key, this.initial});

  final SugarReading? initial;

  @override
  ConsumerState<AddReadingDialog> createState() => _AddReadingDialogState();
}

class _AddReadingDialogState extends ConsumerState<AddReadingDialog> {
  /// Range a home glucose meter can report, in mg/dL.
  static const _minMgDl = 20;
  static const _maxMgDl = 600;

  late final TextEditingController _controller;
  late ReadingContext _context;
  String? _error;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    final unit = ref.read(settingsProvider).unit;
    _controller = TextEditingController(
      text: initial != null ? unit.format(initial.value) : '',
    );
    _context = initial?.context ?? ReadingContext.random;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unit = ref.watch(settingsProvider).unit;

    return AlertDialog(
      title: Text(_isEditing ? 'Edit Reading' : 'Add Sugar Reading'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'Blood sugar (${unit.label})',
                errorText: _error,
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in ReadingContext.values)
                  ChoiceChip(
                    label: Text(c.label),
                    selected: _context == c,
                    onSelected: (_) => setState(() => _context = c),
                  ),
              ],
            ),
          ],
        ),
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
    final unit = ref.read(settingsProvider).unit;
    final typed = double.tryParse(_controller.text.trim().replaceAll(',', '.'));
    final mgDl = typed == null ? null : unit.toMgDl(typed);
    if (mgDl == null || mgDl < _minMgDl || mgDl > _maxMgDl) {
      setState(() {
        _error =
            'Enter a value between ${unit.format(_minMgDl)} '
            'and ${unit.format(_maxMgDl)}';
      });
      return;
    }

    final readings = ref.read(readingsProvider.notifier);
    final initial = widget.initial;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    navigator.pop();
    try {
      if (initial != null) {
        await readings.edit(initial.copyWith(value: mgDl, context: _context));
      } else {
        await readings.add(
          SugarReading.create(
            value: mgDl,
            time: DateTime.now(),
            context: _context,
          ),
        );
      }
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not save the reading')),
      );
    }
  }
}
