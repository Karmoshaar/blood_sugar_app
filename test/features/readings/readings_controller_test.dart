import 'package:blood_sugar_app_1/core/storage/shared_preferences_provider.dart';
import 'package:blood_sugar_app_1/features/readings/domain/sugar_reading.dart';
import 'package:blood_sugar_app_1/features/readings/presentation/providers/readings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

/// A second container over the same preferences, like an app restart.
ProviderContainer restart(ProviderContainer container) {
  return ProviderContainer.test(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(
        container.read(sharedPreferencesProvider),
      ),
    ],
  );
}

void main() {
  test('added readings are shown at once and survive an app restart', () async {
    final container = ProviderContainer.test(overrides: await testOverrides());

    expect(await container.read(readingsProvider.future), isEmpty);

    final reading = SugarReading.create(
      value: 110,
      time: DateTime(2026, 3, 1, 8),
      context: ReadingContext.fasting,
    );
    await container.read(readingsProvider.notifier).add(reading);
    expect(container.read(readingsProvider).value, hasLength(1));

    final loaded = await restart(container).read(readingsProvider.future);
    expect(loaded.single.id, reading.id);
    expect(loaded.single.value, 110);
    expect(loaded.single.time, reading.time);
    expect(loaded.single.context, ReadingContext.fasting);
  });

  test('edit and delete change only the targeted reading', () async {
    final container = ProviderContainer.test(overrides: await testOverrides());
    await container.read(readingsProvider.future);
    final readings = container.read(readingsProvider.notifier);

    final time = DateTime(2026, 3, 1, 8);
    final first = SugarReading(id: 'a', value: 100, time: time);
    final second = SugarReading(id: 'b', value: 200, time: time);
    await readings.add(first);
    await readings.add(second);

    await readings.edit(
      first.copyWith(value: 95, context: ReadingContext.afterMeal),
    );
    await readings.delete('b');

    final loaded = await restart(container).read(readingsProvider.future);
    expect(loaded.single.id, 'a');
    expect(loaded.single.value, 95);
    expect(loaded.single.context, ReadingContext.afterMeal);
  });

  test('readings saved before ids and contexts existed still load', () {
    final legacy = SugarReading.fromJson({
      'value': 130,
      'type': 'Random',
      'time': '2026-01-05T09:30:00.000',
    });

    expect(legacy.id, '2026-01-05T09:30:00.000');
    expect(legacy.context, ReadingContext.random);
  });
}
