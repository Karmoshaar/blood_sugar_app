import 'package:blood_sugar_app_1/features/profile/domain/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final profile = UserProfile(
    name: 'Sara',
    gender: Gender.female,
    birthDate: DateTime(2000, 6, 15),
    weightKg: 60,
    heightCm: 165,
  );

  test('age only increases on the birthday', () {
    expect(profile.ageAt(DateTime(2026, 6, 14)), 25);
    expect(profile.ageAt(DateTime(2026, 6, 15)), 26);
  });

  test('round-trips through JSON', () {
    final copy = UserProfile.fromJson(profile.toJson());

    expect(copy.name, profile.name);
    expect(copy.gender, profile.gender);
    expect(copy.birthDate, profile.birthDate);
    expect(copy.weightKg, profile.weightKg);
    expect(copy.heightCm, profile.heightCm);
  });
}
