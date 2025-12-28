class SugarReading {
  final int value;
  final String type;
  final DateTime time;

  SugarReading({
    required this.value,
    required this.type,
    required this.time,
  });

  factory SugarReading.fromJson(Map<String, dynamic> json) {
    return SugarReading(
      value: json['value'] ?? 0, 
      type: json['type'] ?? 'unknown',
      time: json['time'] != null 
          ? DateTime.parse(json['time']) 
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
