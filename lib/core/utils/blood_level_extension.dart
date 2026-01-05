import 'package:flutter/material.dart';
import 'blood_level_type.dart';

extension BloodLevelX on BloodLevelType {
  Color get color {
    switch (this) {
      case BloodLevelType.low:
        return Colors.blue;
      case BloodLevelType.normal:
        return Colors.green;
      case BloodLevelType.high:
        return Colors.red;
    }
  }

  String get label {
    switch (this) {
      case BloodLevelType.low:
        return 'Low';
      case BloodLevelType.normal:
        return 'Normal';
      case BloodLevelType.high:
        return 'High';
    }
  }
}
