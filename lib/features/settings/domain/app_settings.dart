import 'package:flutter/material.dart' show TimeOfDay;

enum GlucoseUnit {
  mgDl('mg/dL'),
  mmolL('mmol/L');

  const GlucoseUnit(this.label);

  final String label;

  static const _mgDlPerMmolL = 18.0;

  /// Converts a stored mg/dL value into this unit.
  double fromMgDl(num mgDl) => switch (this) {
    GlucoseUnit.mgDl => mgDl.toDouble(),
    GlucoseUnit.mmolL => mgDl / _mgDlPerMmolL,
  };

  /// Converts a value typed in this unit back to mg/dL for storage.
  int toMgDl(double value) => switch (this) {
    GlucoseUnit.mgDl => value.round(),
    GlucoseUnit.mmolL => (value * _mgDlPerMmolL).round(),
  };

  /// A mg/dL value as text in this unit, without the unit label.
  String format(num mgDl) => switch (this) {
    GlucoseUnit.mgDl => mgDl.round().toString(),
    GlucoseUnit.mmolL => fromMgDl(mgDl).toStringAsFixed(1),
  };
}

/// User preferences that shape how readings are analysed and reminded.
class AppSettings {
  const AppSettings({
    this.minTarget = 70,
    this.maxTarget = 140,
    this.unit = GlucoseUnit.mgDl,
    this.reminderTime,
  });

  /// Lower and upper bound of the target range, always stored in mg/dL.
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
