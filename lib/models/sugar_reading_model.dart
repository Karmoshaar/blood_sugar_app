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
  value: json['value'],
  type: json['type'],
  time: DateTime.parse(json['time']),
);
  }
  Map<String, dynamic> toJson() {
return{
  'value': value,
  'type': type,
  'time': time.toIso8601String(),
};
  }
}