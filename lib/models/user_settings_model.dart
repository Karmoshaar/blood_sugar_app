class UserSettings {
  final String name;
  final int age;
  final int minSugar;
  final int maxSugar;

  const UserSettings({
    required this.name,
    required this.age,
    required this.minSugar,
    required this.maxSugar,
  });

  /// Default settings (first app launch)
  factory UserSettings.initial() {
    return const UserSettings(
      name: 'User',
      age: 20,
      minSugar: 70,
      maxSugar: 140,
    );
  }

  /// Copy with changes (important for Provider later)
  UserSettings copyWith({
    String? name,
    int? age,
    int? minSugar,
    int? maxSugar,
  }) {
    return UserSettings(
      name: name ?? this.name,
      age: age ?? this.age,
      minSugar: minSugar ?? this.minSugar,
      maxSugar: maxSugar ?? this.maxSugar,
    );
  }

  /// Convert to Map (for storage later)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'minSugar': minSugar,
      'maxSugar': maxSugar,
    };
  }

  /// Create from Map (for loading later)
  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      name: map['name'] ?? 'User',
      age: map['age'] ?? 20,
      minSugar: map['minSugar'] ?? 70,
      maxSugar: map['maxSugar'] ?? 140,
    );
  }
}
