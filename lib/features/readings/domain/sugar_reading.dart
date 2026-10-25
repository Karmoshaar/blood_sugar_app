/// When the reading was taken relative to meals and sleep.
enum ReadingContext { fasting, beforeMeal, afterMeal, bedtime, random }

class SugarReading {
  const SugarReading({
    required this.id,
    required this.value,
    required this.time,
    this.context = ReadingContext.random,
  });

  /// A new reading with an id derived from its creation time.
  factory SugarReading.create({
    required int value,
    required DateTime time,
    ReadingContext context = ReadingContext.random,
  }) {
    return SugarReading(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      value: value,
      time: time,
      context: context,
    );
  }

  final String id;

  /// Blood glucose in mg/dL, whatever unit the user displays.
  final int value;
  final DateTime time;
  final ReadingContext context;

  SugarReading copyWith({int? value, DateTime? time, ReadingContext? context}) {
    return SugarReading(
      id: id,
      value: value ?? this.value,
      time: time ?? this.time,
      context: context ?? this.context,
    );
  }

  factory SugarReading.fromJson(Map<String, dynamic> json) {
    final time = json['time'] as String;
    return SugarReading(
      // Readings saved before ids existed fall back to their timestamp.
      id: json['id'] as String? ?? time,
      value: (json['value'] as num).toInt(),
      time: DateTime.parse(time),
      context:
          ReadingContext.values.asNameMap()[json['context']] ??
          ReadingContext.random,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'time': time.toIso8601String(),
      'context': context.name,
    };
  }
}
