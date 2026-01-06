class SugarReading {
  final int value;
  final String type;
  final DateTime time;

  const SugarReading({
    required this.value,
    required this.type,
    required this.time,
  });

  factory SugarReading.fromJson(Map<String, dynamic> json) {
    return SugarReading(
      value: (json['value'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? 'unknown',
      time: json['time'] != null
          ? DateTime.parse(json['time'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'type': type,
      'time': time.toIso8601String(),
    };
  }
}