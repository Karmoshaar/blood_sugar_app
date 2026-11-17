import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/user_profile.dart';
import '../providers/profile_setup_controller.dart';
import '../widgets/setup_step_layout.dart';

class GenderStep extends ConsumerStatefulWidget {
  const GenderStep({super.key});

  @override
  ConsumerState<GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends ConsumerState<GenderStep> {
  Gender? _selected;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(profileSetupProvider).gender;
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;

    return SetupStepLayout(
      title: 'What is your gender?',
      onContinue: selected == null
          ? null
          : () =>
                ref.read(profileSetupProvider.notifier).submitGender(selected),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _option(Gender.male, Icons.male),
          const SizedBox(width: 30),
          _option(Gender.female, Icons.female),
        ],
      ),
    );
  }

  Widget _option(Gender gender, IconData icon) {
    return GestureDetector(
      onTap: () => setState(() => _selected = gender),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: _selected == gender
            ? AppColors.primary
            : Colors.grey[300],
        child: Icon(icon, color: Colors.white, size: 56),
      ),
    );
  }
}
