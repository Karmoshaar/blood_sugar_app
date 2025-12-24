import 'package:blood_sugar_app_1/models/sugar_reading_model.dart';
import 'package:blood_sugar_app_1/services/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sugarProvider = AsyncNotifierProvider<SugarNotifier, List<SugarReading>>(
  SugarNotifier.new,
);

class SugarNotifier extends AsyncNotifier<List<SugarReading>> {
  @override
  Future<List<SugarReading>> build() async {
    final api = ref.read(apiServiceProvider);
    return await api.getSugarReadings();
  }

  Future<void> addReading(SugarReading reading) async {
    state = const AsyncLoading();

    try {
      final api = ref.read(apiServiceProvider);
      await api.postSugarReading(reading);

      final updatedList = await api.getSugarReadings();
      state = AsyncData(updatedList);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
