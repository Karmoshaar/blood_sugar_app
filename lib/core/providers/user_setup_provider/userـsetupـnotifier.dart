import 'package:blood_sugar_app_1/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/services/api_services.dart';
import 'user_setup_state.dart';

class UserSetupNotifier extends Notifier<UserSetupState> {
  late final ApiService _apiService;

  @override
  UserSetupState build() {
    _apiService = ref.read(apiServiceProvider);
    return const UserSetupState();
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setBirthDate(DateTime birthDate) {
    state = state.copyWith(birthDate: birthDate);
  }

  void setWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void setHeight(double height) {
    state = state.copyWith(height: height);
  }

  void setReminderTime(DateTime reminderTime) {
    state = state.copyWith(reminderTime: reminderTime);
  }

  bool get isComplete {
    return state.name != null &&
        state.height != null &&
        state.weight != null &&
        state.reminderTime != null &&
        state.gender != null &&
        state.birthDate != null;
  }

  Future<void> completeSetup() async {
    if (!isComplete) {
      throw Exception('يرجى اكمال البيانات المطلوبة');
    }

    final user = UserModel(
      name: state.name!,
      gender: state.gender!,
      birthDate: state.birthDate!,
      weight: state.weight!,
      height: state.height!,
      reminderTime: state.reminderTime,
    );

    try {
      await _apiService.createUser(user);
      state = const UserSetupState();
    } catch (e) {
      // Re-throw to be handled by the UI
      rethrow;
    }
  }

  void reset() {
    state = const UserSetupState();
  }
}

final userSetupProvider = NotifierProvider<UserSetupNotifier, UserSetupState>(
  () => UserSetupNotifier(),
);
