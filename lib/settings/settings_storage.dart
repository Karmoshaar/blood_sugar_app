import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  static const _minSugarKey = 'min_sugar';
  static const _maxSugarKey = 'max_sugar';

  // حفظ الحد الأدنى
  static Future<void> setMinSugar(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_minSugarKey, value);
  }

  // قراءة الحد الأدنى
  static Future<int> getMinSugar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_minSugarKey) ?? 70;
  }

  // حفظ الحد الأعلى
  static Future<void> setMaxSugar(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxSugarKey, value);
  }

  // قراءة الحد الأعلى
  static Future<int> getMaxSugar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_maxSugarKey) ?? 140;
  }
}
