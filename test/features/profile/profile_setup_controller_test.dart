import 'package:blood_sugar_app_1/core/storage/shared_preferences_provider.dart';
import 'package:blood_sugar_app_1/features/profile/data/profile_repository.dart';
import 'package:blood_sugar_app_1/features/profile/domain/user_profile.dart';
import 'package:blood_sugar_app_1/features/profile/presentation/providers/profile_controller.dart';
import 'package:blood_sugar_app_1/features/profile/presentation/providers/profile_setup_controller.dart';
import 'package:blood_sugar_app_1/features/settings/presentation/providers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  test('each answer advances a step and is kept after a restart', () async {
    final overrides = await testOverrides();
    final container = ProviderContainer.test(overrides: overrides);
    final setup = container.read(profileSetupProvider.notifier);

    await setup.submitName('  Omar ');
    await setup.submitGender(Gender.male);
    expect(container.read(profileSetupProvider).step, 2);

    await setup.back();
    expect(container.read(profileSetupProvider).step, 1);

    final restarted = ProviderContainer.test(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          container.read(sharedPreferencesProvider),
        ),
      ],
    );
    final draft = restarted.read(profileSetupProvider);
    expect(draft.step, 1);
    expect(draft.name, 'Omar');
    expect(draft.gender, Gender.male);
  });

  test(
    'finish saves the profile, schedules the reminder and drops the draft',
    () async {
      final notifications = FakeNotificationService();
      final overrides = await testOverrides(notifications: notifications);
      final container = ProviderContainer.test(overrides: overrides);
      final setup = container.read(profileSetupProvider.notifier);

      await setup.submitName('Omar');
      await setup.submitGender(Gender.male);
      await setup.submitBirthDate(DateTime(1995, 1, 1));
      await setup.submitWeight(80);
      await setup.submitHeight(180);
      await setup.finish(const TimeOfDay(hour: 8, minute: 30));

      expect(container.read(profileProvider)?.name, 'Omar');
      expect(
        container.read(settingsProvider).reminderTime,
        const TimeOfDay(hour: 8, minute: 30),
      );
      expect(notifications.permissionRequested, isTrue);
      expect(notifications.scheduled, [const TimeOfDay(hour: 8, minute: 30)]);
      expect(container.read(profileRepositoryProvider).loadDraft(), isNull);
    },
  );

  test('finish refuses an incomplete draft', () async {
    final overrides = await testOverrides();
    final container = ProviderContainer.test(overrides: overrides);

    await container.read(profileSetupProvider.notifier).submitName('Omar');

    expect(
      () => container
          .read(profileSetupProvider.notifier)
          .finish(const TimeOfDay(hour: 8, minute: 0)),
      throwsStateError,
    );
    expect(container.read(profileProvider), isNull);
  });
}
