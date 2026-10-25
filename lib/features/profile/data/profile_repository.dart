import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/shared_preferences_provider.dart';
import '../domain/profile_draft.dart';
import '../domain/user_profile.dart';

/// Stores the finished [UserProfile] and the in-progress [ProfileDraft].
class ProfileRepository {
  ProfileRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _profileKey = 'profile.user';
  static const _draftKey = 'profile.setup_draft';

  UserProfile? load() {
    final raw = _prefs.getString(_profileKey);
    if (raw == null) return null;
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(UserProfile profile) async {
    await _prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  ProfileDraft? loadDraft() {
    final raw = _prefs.getString(_draftKey);
    if (raw == null) return null;
    return ProfileDraft.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveDraft(ProfileDraft draft) async {
    await _prefs.setString(_draftKey, jsonEncode(draft.toJson()));
  }

  Future<void> clearDraft() async {
    await _prefs.remove(_draftKey);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(ref.watch(sharedPreferencesProvider)),
);
