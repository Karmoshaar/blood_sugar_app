import 'blood_level_type.dart';

class BloodLevelHelper {
  static BloodLevelType fromValue(int value) {
    if (value < 70) {
      return BloodLevelType.low;
    } else if (value <= 140) {
      return BloodLevelType.normal;
    } else {
      return BloodLevelType.high;
    }
  }
}
