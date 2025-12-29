import 'package:blood_sugar_app_1/models/sugar_reading_model.dart';

class SugarStatsCalculator {
  final List<SugarReading> readings;

  SugarStatsCalculator(List<SugarReading> rawReadings)
      : readings = rawReadings.where((r) => r.value > 0).toList();

  bool get isEmpty => readings.isEmpty;

  List<int> get values => readings.map((e) => e.value).toList();

  double get average {
    if (isEmpty) return 0;
    final sum = values.reduce((a, b) => a + b);
    return sum / values.length;
  }

  int get maxValue {
    if (isEmpty) return 0;
    return values.reduce((a, b) => a > b ? a : b);
  }

  int get minValue {
    if (isEmpty) return 0;
    return values.reduce((a, b) => a < b ? a : b);
  }

  List<SugarReading> get sortedByTime {
    final list = [...readings];
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }

  List<SugarReading> get last7Readings {
    final sorted = sortedByTime;
    if (sorted.length <= 7) return sorted;
    return sorted.sublist(sorted.length - 7);
  }
}
