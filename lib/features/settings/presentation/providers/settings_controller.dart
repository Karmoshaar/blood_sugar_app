import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/notification_service.dart';
import '../../data/settings_repository.dart';
import '../../domain/app_settings.dart';

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  Future<void> setMinTarget(int value) =>
      _update(state.copyWith(minTarget: value));

  Future<void> setMaxTarget(int value) =>
      _update(state.copyWith(maxTarget: value));

  Future<void> setUnit(GlucoseUnit unit) => _update(state.copyWith(unit: unit));

  /// Saves the time and reschedules the daily reminder notification.
  Future<void> setReminderTime(TimeOfDay time) async {
    await ref.read(notificationServiceProvider).scheduleDailyReminder(time);
    await _update(state.copyWith(reminderTime: time));
  }

  Future<void> _update(AppSettings settings) async {
    state = settings;
    await ref.read(settingsRepositoryProvider).save(settings);
  }
}
