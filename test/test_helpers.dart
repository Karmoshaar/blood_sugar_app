import 'package:blood_sugar_app_1/core/notifications/notification_service.dart';
import 'package:blood_sugar_app_1/core/storage/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeNotificationService implements NotificationService {
  final List<TimeOfDay> scheduled = [];
  bool permissionRequested = false;

  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermission() async {
    permissionRequested = true;
    return true;
  }

  @override
  Future<void> scheduleDailyReminder(TimeOfDay time) async {
    scheduled.add(time);
  }
}

/// Overrides for a [ProviderScope] or [ProviderContainer] backed by in-memory
/// preferences seeded with [values].
Future<List<Override>> testOverrides({
  Map<String, Object> values = const {},
  NotificationService? notifications,
}) async {
  SharedPreferences.setMockInitialValues(values);
  final prefs = await SharedPreferences.getInstance();
  return [
    sharedPreferencesProvider.overrideWithValue(prefs),
    notificationServiceProvider.overrideWithValue(
      notifications ?? FakeNotificationService(),
    ),
  ];
}
