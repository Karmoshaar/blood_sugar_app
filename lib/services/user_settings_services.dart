import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings_model.dart';

class UserSettingsService {
  static const _key = 'user_settings';

  /// Save settings to disk
  Future<void> save(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    settings.toMap().forEach((key, value) {
      if (value is int) {
        prefs.setInt(key, value);
      } else if (value is String) {
        prefs.setString(key, value);
      }
    });
  }

  /// Load settings from disk
  Future<UserSettings> load() async {
    final prefs = await SharedPreferences.getInstance();

    return UserSettings(
      name: prefs.getString('name') ?? 'User',
      age: prefs.getInt('age') ?? 20,
      minSugar: prefs.getInt('minSugar') ?? 70,
      maxSugar: prefs.getInt('maxSugar') ?? 140,
    );
  }
}