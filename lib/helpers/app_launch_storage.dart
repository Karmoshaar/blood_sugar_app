import 'package:shared_preferences/shared_preferences.dart';

class AppLaunchStorage {
  static const _stepKey = 'setup_step';

  static Future<void> setSetupStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_stepKey, step);
  }

  static Future<int> getSetupStep() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_stepKey) ?? 1;
  }

  static Future<void> clearSetupStep() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_stepKey);
  }
}
