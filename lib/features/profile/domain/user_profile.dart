enum Gender { male, female }

class UserProfile {
  const UserProfile({
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.weightKg,
    required this.heightCm,
  });

  final String name;
  final Gender gender;
  final DateTime birthDate;
  final double weightKg;
  final double heightCm;

  int get age => ageAt(DateTime.now());

  int ageAt(DateTime date) {
    var age = date.year - birthDate.year;
    final hadBirthday =
        date.month > birthDate.month ||
        (date.month == birthDate.month && date.day >= birthDate.day);
    if (!hadBirthday) age--;
    return age;
  }

  UserProfile copyWith({
    String? name,
    Gender? gender,
    DateTime? birthDate,
    double? weightKg,
    double? heightCm,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender.name,
      'birthDate': birthDate.toIso8601String(),
      'weightKg': weightKg,
      'heightCm': heightCm,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      gender: Gender.values.byName(json['gender'] as String),
      birthDate: DateTime.parse(json['birthDate'] as String),
      weightKg: (json['weightKg'] as num).toDouble(),
      heightCm: (json['heightCm'] as num).toDouble(),
    );
  }
}
