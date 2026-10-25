class SugarReading {
  const SugarReading({
    required this.value,
    required this.time,
    this.type = 'Random',
  });

  /// Blood glucose in mg/dL.
  final int value;
  final DateTime time;
  final String type;

  factory SugarReading.fromJson(Map<String, dynamic> json) {
    return SugarReading(
      value: (json['value'] as num).toInt(),
      time: DateTime.parse(json['time'] as String),
      type: json['type'] as String? ?? 'Random',
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'time': time.toIso8601String(), 'type': type};
  }
}
