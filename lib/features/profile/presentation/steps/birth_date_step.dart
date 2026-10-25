import 'package:dss_cupertino_date_picker/dss_cupertino_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/profile_setup_controller.dart';
import '../widgets/setup_step_layout.dart';

class BirthDateStep extends ConsumerStatefulWidget {
  const BirthDateStep({super.key});

  @override
  ConsumerState<BirthDateStep> createState() => _BirthDateStepState();
}

class _BirthDateStepState extends ConsumerState<BirthDateStep> {
  final DateTime _minDate = DateTime(1900, 1, 1);
  final DateTime _maxDate = DateTime.now();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = ref.read(profileSetupProvider).birthDate ?? _maxDate;
  }

  @override
  Widget build(BuildContext context) {
    return SetupStepLayout(
      title: 'When is your birthday?',
      onContinue: () => ref
          .read(profileSetupProvider.notifier)
          .submitBirthDate(_selectedDate),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: CupertinoDatePicker(
          itemExtent: 50,
          minDate: _minDate,
          maxDate: _maxDate,
          selectedDate: _selectedDate,
          selectionOverlay: Container(
            width: double.infinity,
            height: 50,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
          ),
          selectedStyle: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          unselectedStyle: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
          disabledStyle: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
          ),
          onSelectedItemChanged: (date) => setState(() => _selectedDate = date),
        ),
      ),
    );
  }
}
