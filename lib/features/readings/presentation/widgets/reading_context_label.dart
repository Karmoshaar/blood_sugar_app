import '../../domain/sugar_reading.dart';

extension ReadingContextLabel on ReadingContext {
  String get label => switch (this) {
    ReadingContext.fasting => 'Fasting',
    ReadingContext.beforeMeal => 'Before meal',
    ReadingContext.afterMeal => 'After meal',
    ReadingContext.bedtime => 'Bedtime',
    ReadingContext.random => 'Random',
  };
}
