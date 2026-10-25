import 'package:blood_sugar_app_1/core/storage/shared_preferences_provider.dart';
import 'package:blood_sugar_app_1/features/readings/domain/sugar_reading.dart';
import 'package:blood_sugar_app_1/features/readings/presentation/providers/readings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  test('added readings are shown at once and survive an app restart', () async {
    final overrides = await testOverrides();
    final container = ProviderContainer.test(overrides: overrides);

    expect(await container.read(readingsProvider.future), isEmpty);

    final reading = SugarReading(value: 110, time: DateTime(2026, 3, 1, 8));
    await container.read(readingsProvider.notifier).add(reading);
    expect(container.read(readingsProvider).value, hasLength(1));

    // A fresh container over the same preferences simulates a restart.
    final restarted = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          container.read(sharedPreferencesProvider),
        ),
      ],
    );
    final loaded = await restarted.read(readingsProvider.future);
    expect(loaded.single.value, 110);
    expect(loaded.single.time, reading.time);
  });
}
