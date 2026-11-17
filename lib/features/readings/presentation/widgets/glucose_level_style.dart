import 'package:flutter/material.dart';

import '../../domain/glucose_level.dart';

/// How each [GlucoseLevel] looks in the UI. Kept out of the domain enum so
/// the domain stays free of Flutter.
extension GlucoseLevelStyle on GlucoseLevel {
  Color get color => switch (this) {
    GlucoseLevel.low => Colors.blue,
    GlucoseLevel.normal => Colors.green,
    GlucoseLevel.high => Colors.red,
  };

  String get label => switch (this) {
    GlucoseLevel.low => 'Low',
    GlucoseLevel.normal => 'Normal',
    GlucoseLevel.high => 'High',
  };
}
