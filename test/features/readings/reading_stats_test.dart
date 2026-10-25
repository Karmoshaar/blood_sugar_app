import 'package:blood_sugar_app_1/features/readings/domain/reading_stats.dart';
import 'package:blood_sugar_app_1/features/readings/domain/sugar_reading.dart';
import 'package:flutter_test/flutter_test.dart';

SugarReading reading(int value, int day) =>
    SugarReading(value: value, time: DateTime(2026, 1, day));

void main() {
  test('empty readings give zeroed stats', () {
    final stats = ReadingStats(const []);

    expect(stats.isEmpty, isTrue);
    expect(stats.average, 0);
    expect(stats.maxValue, 0);
    expect(stats.minValue, 0);
  });

  test('computes average, min and max and ignores non-positive values', () {
    final stats = ReadingStats([
      reading(120, 2),
      reading(0, 3),
      reading(90, 1),
      reading(150, 4),
    ]);

    expect(stats.average, 120);
    expect(stats.maxValue, 150);
    expect(stats.minValue, 90);
  });

  test('sorts by time and keeps only the last seven for the bar chart', () {
    final stats = ReadingStats([
      for (var day = 10; day >= 1; day--) reading(100 + day, day),
    ]);

    expect(stats.sortedByTime.first.value, 101);
    expect(stats.last7.map((r) => r.value), [
      104,
      105,
      106,
      107,
      108,
      109,
      110,
    ]);
  });
}
