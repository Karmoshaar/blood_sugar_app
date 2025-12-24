import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/services/api_services.dart';
import 'package:blood_sugar_app_1/models/user_model.dart';
final authProvider =
AsyncNotifierProvider<AuthNotifier, void>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {

  }

  Future<void> setupAccount({
    required String name,
    required String gender,
    required DateTime birthDate,
    required double weight,
    required double height,
  }) async {
    state = const AsyncLoading();

    try {
      final api = ref.read(apiServiceProvider);

      final user = UserModel(
        name: name,
        gender: gender,
        birthDate: birthDate,
        weight: weight,
        height: height,
      );

      await api.createUser(user);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
