import 'package:flutter/scheduler.dart';
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

  void addReading(SugarReading reading) {
    final previousState = state.value ?? [];

    // Use postFrameCallback to defer state update slightly
    // This allows the dialog to close first before triggering rebuild
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Optimistic update: update UI after frame
      state = AsyncData([...previousState, reading]);
      
      // Fire-and-forget API call in the background
      _saveReadingToServer(reading, previousState);
    });
  }

  Future<void> _saveReadingToServer(SugarReading reading, List<SugarReading> previousState) async {
    try {
      final api = ref.read(apiServiceProvider);
      await api.postSugarReading(reading);
    } catch (e) {
      // Revert optimistic update on error
      final currentState = state.value ?? [];
      if (currentState.length > previousState.length) {
        state = AsyncData(previousState);
      }
    }
  }
}
