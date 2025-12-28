import 'package:blood_sugar_app_1/models/sugar_reading_model.dart';
import 'package:blood_sugar_app_1/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. تعريف الـ Provider
final sugarProvider = AsyncNotifierProvider<SugarNotifier, List<SugarReading>>(
  SugarNotifier.new,
);

// 2. تعريف الكلاس (الـ Notifier)
class SugarNotifier extends AsyncNotifier<List<SugarReading>> {

  @override
  Future<List<SugarReading>> build() async {
    final api = ref.read(apiServiceProvider);
    return await api.getSugarReadings();
  }

  Future<void> addReading(SugarReading reading) async {
    // استخدام value بدلاً من valueOrNull في الإصدارات الأقدم من Riverpod
    // أو التأكد من استخراج البيانات بشكل صحيح
    final previousState = state.value ?? [];

    try {
      final api = ref.read(apiServiceProvider);
      await api.postSugarReading(reading);

      // التحديث المحلي
      state = AsyncData([...previousState, reading]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
