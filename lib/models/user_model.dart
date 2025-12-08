class UserModel {
  final String name;
  final String gender;
  final DateTime birthDate;
  final double weight;
  final double height;
  final DateTime? reminderTime;

  UserModel({
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.weight,
    required this.height,
    this.reminderTime,
  });

  // تحويل الـ Object إلى JSON Map
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "gender": gender,
      "birthDate": birthDate.toIso8601String(),
      "weight": weight,
      "height": height,
      "reminderTime": reminderTime?.toIso8601String(),
    };
  }

  // تحويل JSON إلى Object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"],
      gender: json["gender"],
      birthDate: DateTime.parse(json["birthDate"]),
      weight: json["weight"],
      height: json["height"],
      reminderTime: json["reminderTime"] != null
          ? DateTime.parse(json["reminderTime"])
          : null,
    );
  }
}

