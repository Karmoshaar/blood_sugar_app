import 'sugar_reading.dart';

/// Summary numbers for a list of readings. Pure Dart, so it is easy to test.
class ReadingStats {
  ReadingStats(List<SugarReading> readings)
    : sortedByTime = [...readings.where((r) => r.value > 0)]
        ..sort((a, b) => a.time.compareTo(b.time));

  /// Valid readings, oldest first.
  final List<SugarReading> sortedByTime;

  bool get isEmpty => sortedByTime.isEmpty;

  Iterable<int> get _values => sortedByTime.map((r) => r.value);

  double get average {
    if (isEmpty) return 0;
    return _values.reduce((a, b) => a + b) / sortedByTime.length;
  }

  int get maxValue => isEmpty ? 0 : _values.reduce((a, b) => a > b ? a : b);

  int get minValue => isEmpty ? 0 : _values.reduce((a, b) => a < b ? a : b);

  List<SugarReading> get last7 {
    if (sortedByTime.length <= 7) return sortedByTime;
    return sortedByTime.sublist(sortedByTime.length - 7);
  }
}
