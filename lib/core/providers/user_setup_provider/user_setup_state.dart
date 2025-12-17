class UserSetupState {
  final String? name;
  final String? gender;
  final DateTime? birthDate;
  final double? weight;
  final double? height;
  final DateTime? reminderTime;

  const UserSetupState({
    this.name,
    this.gender,
    this.birthDate,
    this.weight,
    this.height,
    this.reminderTime,
  });

  UserSetupState copyWith({
    String? name,
    String? gender,
    DateTime? birthDate,
    double? weight,
    double? height,
    DateTime? reminderTime,
  }) {
    return UserSetupState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
  int get completedSteps {
    int count = 0;

    if (name != null && name!.isNotEmpty) count++;
    if (gender != null) count++;
    if (birthDate != null) count++;
    if (weight != null) count++;
    if (height != null) count++;
    if (reminderTime != null) count++;

    return count;
  }

  double get progress => completedSteps / 6;

}

