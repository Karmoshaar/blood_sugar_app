import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/profile_draft.dart';
import '../providers/profile_setup_controller.dart';
import '../steps/birth_date_step.dart';
import '../steps/gender_step.dart';
import '../steps/height_step.dart';
import '../steps/name_step.dart';
import '../steps/reminder_step.dart';
import '../steps/weight_step.dart';
import '../widgets/setup_progress_bar.dart';

/// Hosts the setup steps on a single route. The current step comes from
/// [profileSetupProvider], so back/forward is just a state change and an
/// interrupted setup resumes where it stopped.
class ProfileSetupScreen extends ConsumerWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(profileSetupProvider.select((d) => d.step));
    final controller = ref.read(profileSetupProvider.notifier);

    return PopScope(
      // The system back button goes to the previous step, not out of the app.
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          leading: step > 0
              ? IconButton(
                  onPressed: controller.back,
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                )
              : const SizedBox(width: 16),
          title: SetupProgressBar(
            currentStep: step + 1,
            totalSteps: ProfileDraft.stepCount,
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: KeyedSubtree(key: ValueKey(step), child: _stepFor(step)),
        ),
      ),
    );
  }

  Widget _stepFor(int step) {
    return switch (step) {
      0 => const NameStep(),
      1 => const GenderStep(),
      2 => const BirthDateStep(),
      3 => const WeightStep(),
      4 => const HeightStep(),
      _ => const ReminderStep(),
    };
  }
}
