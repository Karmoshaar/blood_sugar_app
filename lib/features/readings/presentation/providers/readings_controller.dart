import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local_readings_repository.dart';
import '../../domain/sugar_reading.dart';

final readingsProvider =
    AsyncNotifierProvider<ReadingsController, List<SugarReading>>(
      ReadingsController.new,
    );

class ReadingsController extends AsyncNotifier<List<SugarReading>> {
  @override
  Future<List<SugarReading>> build() =>
      ref.watch(readingsRepositoryProvider).fetchAll();

  /// Shows the reading immediately, then saves it; rolls back if saving fails.
  Future<void> add(SugarReading reading) async {
    final previous = state.value ?? const <SugarReading>[];
    state = AsyncData([...previous, reading]);
    try {
      await ref.read(readingsRepositoryProvider).add(reading);
    } catch (_) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}
