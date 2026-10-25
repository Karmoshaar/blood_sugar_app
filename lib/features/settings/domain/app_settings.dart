import 'package:flutter/material.dart' show TimeOfDay;

enum GlucoseUnit {
  mgDl('mg/dL'),
  mmolL('mmol/L');

  const GlucoseUnit(this.label);

  final String label;
}

/// User preferences that shape how readings are analysed and reminded.
class AppSettings {
  const AppSettings({
    this.minTarget = 70,
    this.maxTarget = 140,
    this.unit = GlucoseUnit.mgDl,
    this.reminderTime,
  });

  /// Lower and upper bound of the target range, in mg/dL.
  final int minTarget;
  final int maxTarget;
  final GlucoseUnit unit;
  final TimeOfDay? reminderTime;

  AppSettings copyWith({
    int? minTarget,
    int? maxTarget,
    GlucoseUnit? unit,
    TimeOfDay? reminderTime,
  }) {
    return AppSettings(
      minTarget: minTarget ?? this.minTarget,
      maxTarget: maxTarget ?? this.maxTarget,
      unit: unit ?? this.unit,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
