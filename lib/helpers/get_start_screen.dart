import 'package:blood_sugar_app_1/account_setup/date_setup.dart';
import 'package:blood_sugar_app_1/account_setup/gender_setup.dart';
import 'package:blood_sugar_app_1/account_setup/height_setup.dart';
import 'package:blood_sugar_app_1/account_setup/name_setup.dart';
import 'package:blood_sugar_app_1/account_setup/remind_setup.dart';
import 'package:blood_sugar_app_1/account_setup/weight_setup.dart';
import 'package:flutter/cupertino.dart';

Widget getStartScreen(int step) {
  switch (step) {
    case 1:
      return const NameSetup();
    case 2:
      return const GenderSetup();
    case 3:
      return const DateSetup();
    case 4:
      return const WeightSetup();
    case 5:
      return const HeightSetup();
    case 6:
      return const RemindSetup();
    default:
      return const NameSetup();
  }
}
