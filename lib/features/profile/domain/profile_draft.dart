import 'user_profile.dart';

/// The profile while the user is still going through the setup steps.
///
/// It is saved after every step, so closing the app half-way resumes at
/// [step] with the answers already given.
class ProfileDraft {
  const ProfileDraft({
    this.step = 0,
    this.name,
    this.gender,
    this.birthDate,
    this.weightKg,
    this.heightCm,
  });

  /// Number of setup steps: name, gender, birth date, weight, height, reminder.
  static const stepCount = 6;

  /// Zero-based index of the step currently shown.
  final int step;
  final String? name;
  final Gender? gender;
  final DateTime? birthDate;
  final double? weightKg;
  final double? heightCm;

  bool get isComplete =>
      name != null &&
      gender != null &&
      birthDate != null &&
      weightKg != null &&
      heightCm != null;

  UserProfile toProfile() {
    if (!isComplete) {
      throw StateError('Profile setup is missing answers');
    }
    return UserProfile(
      name: name!,
      gender: gender!,
      birthDate: birthDate!,
      weightKg: weightKg!,
      heightCm: heightCm!,
    );
  }

  ProfileDraft copyWith({
    int? step,
    String? name,
    Gender? gender,
    DateTime? birthDate,
    double? weightKg,
    double? heightCm,
  }) {
    return ProfileDraft(
      step: step ?? this.step,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'name': name,
      'gender': gender?.name,
      'birthDate': birthDate?.toIso8601String(),
      'weightKg': weightKg,
      'heightCm': heightCm,
    };
  }

  factory ProfileDraft.fromJson(Map<String, dynamic> json) {
    final gender = json['gender'] as String?;
    final birthDate = json['birthDate'] as String?;
    return ProfileDraft(
      step: (json['step'] as int? ?? 0).clamp(0, stepCount - 1),
      name: json['name'] as String?,
      gender: gender != null ? Gender.values.byName(gender) : null,
      birthDate: birthDate != null ? DateTime.parse(birthDate) : null,
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      heightCm: (json['heightCm'] as num?)?.toDouble(),
    );
  }
}
