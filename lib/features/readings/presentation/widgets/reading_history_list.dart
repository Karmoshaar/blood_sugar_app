import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/domain/app_settings.dart';
import '../../domain/sugar_reading.dart';
import '../providers/readings_controller.dart';
import 'add_reading_dialog.dart';
import 'reading_history_item.dart';

/// Readings newest first. Tap to edit, swipe to delete (with undo).
class ReadingHistoryList extends ConsumerWidget {
  const ReadingHistoryList({
    super.key,
    required this.readings,
    required this.settings,
  });

  /// Oldest first, as produced by `ReadingStats.sortedByTime`.
  final List<SugarReading> readings;
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: readings.length,
      itemBuilder: (context, index) {
        final reading = readings[readings.length - 1 - index];
        return Dismissible(
          key: ValueKey(reading.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: const Icon(Icons.delete, color: Colors.red),
          ),
          onDismissed: (_) => _delete(context, ref, reading),
          child: ReadingHistoryItem(
            reading: reading,
            settings: settings,
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => AddReadingDialog(initial: reading),
            ),
          ),
        );
      },
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    SugarReading reading,
  ) async {
    final readingsController = ref.read(readingsProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    try {
      await readingsController.delete(reading.id);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not delete the reading')),
      );
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Reading deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => readingsController.add(reading),
        ),
      ),
    );
  }
}
