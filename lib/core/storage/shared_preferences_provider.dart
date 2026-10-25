import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The [SharedPreferences] instance loaded once in `main()`.
///
/// It is overridden in the root [ProviderScope], so repositories can read
/// stored values synchronously instead of awaiting `getInstance()` everywhere.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  ),
);
