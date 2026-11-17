import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/profile_repository.dart';
import '../../domain/user_profile.dart';

/// The saved profile, or null until the setup flow is finished.
final profileProvider = NotifierProvider<ProfileController, UserProfile?>(
  ProfileController.new,
);

class ProfileController extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => ref.watch(profileRepositoryProvider).load();

  Future<void> save(UserProfile profile) async {
    state = profile;
    await ref.read(profileRepositoryProvider).save(profile);
  }

  Future<void> update(UserProfile Function(UserProfile current) change) async {
    final current = state;
    if (current == null) return;
    await save(change(current));
  }
}
