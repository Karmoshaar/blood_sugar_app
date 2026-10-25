import 'sugar_reading.dart';

/// Where readings come from. The app depends on this interface only, so the
/// local implementation can later be swapped for (or synced with) a server
/// without touching the UI.
abstract interface class ReadingsRepository {
  Future<List<SugarReading>> fetchAll();

  Future<void> add(SugarReading reading);
}
