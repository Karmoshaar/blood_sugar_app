enum GlucoseLevel {
  low,
  normal,
  high;

  /// Classifies [value] (mg/dL) against the user's target range.
  static GlucoseLevel classify(
    int value, {
    required int minTarget,
    required int maxTarget,
  }) {
    if (value < minTarget) return GlucoseLevel.low;
    if (value <= maxTarget) return GlucoseLevel.normal;
    return GlucoseLevel.high;
  }
}
