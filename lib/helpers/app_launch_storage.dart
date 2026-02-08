import 'package:shared_preferences/shared_preferences.dart';

class AppLaunchStorage {
  static const _key = 'has_reached_name_setup';

  static Future<bool> hasReachedNameSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> setReachedNameSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
