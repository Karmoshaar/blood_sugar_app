import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local_readings_repository.dart';
import '../../domain/readings_repository.dart';
import '../../domain/sugar_reading.dart';

final readingsProvider =
    AsyncNotifierProvider<ReadingsController, List<SugarReading>>(
      ReadingsController.new,
    );

class ReadingsController extends AsyncNotifier<List<SugarReading>> {
  @override
  Future<List<SugarReading>> build() =>
      ref.watch(readingsRepositoryProvider).fetchAll();

  Future<void> add(SugarReading reading) =>
      _mutate((list) => [...list, reading], (repo) => repo.add(reading));

  Future<void> edit(SugarReading reading) => _mutate(
    (list) => [for (final r in list) r.id == reading.id ? reading : r],
    (repo) => repo.update(reading),
  );

  Future<void> delete(String id) => _mutate(
    (list) => list.where((r) => r.id != id).toList(),
    (repo) => repo.delete(id),
  );

  /// Shows the change immediately, then saves it; rolls back if saving fails.
  Future<void> _mutate(
    List<SugarReading> Function(List<SugarReading> current) change,
    Future<void> Function(ReadingsRepository repo) persist,
  ) async {
    final previous = state.value ?? const <SugarReading>[];
    state = AsyncData(change(previous));
    try {
      await persist(ref.read(readingsRepositoryProvider));
    } catch (_) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}
