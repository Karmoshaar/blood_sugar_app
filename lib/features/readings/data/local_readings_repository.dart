import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/shared_preferences_provider.dart';
import '../domain/readings_repository.dart';
import '../domain/sugar_reading.dart';

/// Keeps readings on the device, one JSON string per reading.
///
/// SharedPreferences is plenty for a few thousand readings; if the history
/// grows beyond that, replace this class with a database-backed one.
class LocalReadingsRepository implements ReadingsRepository {
  LocalReadingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _key = 'readings.items';

  @override
  Future<List<SugarReading>> fetchAll() async => _read();

  @override
  Future<void> add(SugarReading reading) => _write([..._read(), reading]);

  @override
  Future<void> update(SugarReading reading) =>
      _write([for (final r in _read()) r.id == reading.id ? reading : r]);

  @override
  Future<void> delete(String id) =>
      _write(_read().where((r) => r.id != id).toList());

  List<SugarReading> _read() {
    final raw = _prefs.getStringList(_key) ?? const [];
    return [
      for (final item in raw)
        SugarReading.fromJson(jsonDecode(item) as Map<String, dynamic>),
    ];
  }

  Future<void> _write(List<SugarReading> readings) async {
    await _prefs.setStringList(_key, [
      for (final r in readings) jsonEncode(r.toJson()),
    ]);
  }
}

final readingsRepositoryProvider = Provider<ReadingsRepository>(
  (ref) => LocalReadingsRepository(ref.watch(sharedPreferencesProvider)),
);
