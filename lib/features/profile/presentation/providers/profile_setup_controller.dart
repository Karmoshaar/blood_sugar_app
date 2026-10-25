import 'package:flutter/material.dart' show TimeOfDay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/notification_service.dart';
import '../../../settings/presentation/providers/settings_controller.dart';
import '../../data/profile_repository.dart';
import '../../domain/profile_draft.dart';
import '../../domain/user_profile.dart';
import 'profile_controller.dart';

final profileSetupProvider =
    NotifierProvider<ProfileSetupController, ProfileDraft>(
      ProfileSetupController.new,
    );

/// Drives the multi-step setup flow: each `submit*` stores one answer,
/// moves to the next step and persists the draft.
class ProfileSetupController extends Notifier<ProfileDraft> {
  @override
  ProfileDraft build() =>
      ref.watch(profileRepositoryProvider).loadDraft() ?? const ProfileDraft();

  Future<void> submitName(String name) =>
      _advance(state.copyWith(name: name.trim()));

  Future<void> submitGender(Gender gender) =>
      _advance(state.copyWith(gender: gender));

  Future<void> submitBirthDate(DateTime birthDate) =>
      _advance(state.copyWith(birthDate: birthDate));

  Future<void> submitWeight(double weightKg) =>
      _advance(state.copyWith(weightKg: weightKg));

  Future<void> submitHeight(double heightCm) =>
      _advance(state.copyWith(heightCm: heightCm));

  Future<void> back() async {
    if (state.step == 0) return;
    state = state.copyWith(step: state.step - 1);
    await ref.read(profileRepositoryProvider).saveDraft(state);
  }

  /// Last step: schedules the reminder, saves the profile and drops the draft.
  ///
  /// The profile is saved last, so if scheduling fails the user stays on the
  /// reminder step and can retry.
  Future<void> finish(TimeOfDay reminderTime) async {
    final profile = state.toProfile();

    await ref.read(notificationServiceProvider).requestPermission();
    await ref.read(settingsProvider.notifier).setReminderTime(reminderTime);
    await ref.read(profileProvider.notifier).save(profile);
    await ref.read(profileRepositoryProvider).clearDraft();
  }

  Future<void> _advance(ProfileDraft updated) async {
    final nextStep = (updated.step + 1).clamp(0, ProfileDraft.stepCount - 1);
    state = updated.copyWith(step: nextStep);
    await ref.read(profileRepositoryProvider).saveDraft(state);
  }
}
