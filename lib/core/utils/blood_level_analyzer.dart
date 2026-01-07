import 'blood_level_type.dart';

class BloodLevelAnalyzer {
  static BloodLevelType getLevel({
    required int value,
    required double minTarget,
    required double maxTarget,
  }) {
    if (value < minTarget) {
      return BloodLevelType.low;
    } else if (value <= maxTarget) {
      return BloodLevelType.normal;
    } else {
      return BloodLevelType.high;
    }
  }
}
