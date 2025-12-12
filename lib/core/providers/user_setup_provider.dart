import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/models/user_model.dart';
import 'package:blood_sugar_app_1/services/api_services.dart';
class UserSetupState {
  final String? name;
  final String? gender;
  final DateTime? birthDate;
  final double? weight;
  final double? height;
  final DateTime? reminderTime;
  const UserSetupState({this.name,this.birthDate,this.gender,this.height,this.reminderTime,this.weight});
  UserSetupState copyWith(
      String? name,
      String? gender,DateTime?birthDate,double? weight,
  double? height,
  DateTime? reminderTime,
){return UserSetupState(  name: name ?? this.name,
gender: gender ?? this.gender,
birthDate: birthDate ?? this.birthDate,
weight: weight ?? this.weight,
height: height ?? this.height,
reminderTime: reminderTime ?? this.reminderTime,);}
}
