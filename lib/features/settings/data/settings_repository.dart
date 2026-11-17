import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/shared_preferences_provider.dart';
import '../domain/app_settings.dart';

/// The single place that knows how [AppSettings] are stored on disk.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _minTargetKey = 'settings.min_target';
  static const _maxTargetKey = 'settings.max_target';
  static const _unitKey = 'settings.unit';
  static const _reminderHourKey = 'settings.reminder_hour';
  static const _reminderMinuteKey = 'settings.reminder_minute';

  AppSettings load() {
    const defaults = AppSettings();
    final hour = _prefs.getInt(_reminderHourKey);
    final minute = _prefs.getInt(_reminderMinuteKey);

    return AppSettings(
      minTarget: _prefs.getInt(_minTargetKey) ?? defaults.minTarget,
      maxTarget: _prefs.getInt(_maxTargetKey) ?? defaults.maxTarget,
      unit:
          GlucoseUnit.values.asNameMap()[_prefs.getString(_unitKey)] ??
          defaults.unit,
      reminderTime: hour != null && minute != null
          ? TimeOfDay(hour: hour, minute: minute)
          : null,
    );
  }

  Future<void> save(AppSettings settings) async {
    await _prefs.setInt(_minTargetKey, settings.minTarget);
    await _prefs.setInt(_maxTargetKey, settings.maxTarget);
    await _prefs.setString(_unitKey, settings.unit.name);
    final reminder = settings.reminderTime;
    if (reminder != null) {
      await _prefs.setInt(_reminderHourKey, reminder.hour);
      await _prefs.setInt(_reminderMinuteKey, reminder.minute);
    }
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);
