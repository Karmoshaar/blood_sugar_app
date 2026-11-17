import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SetupProgressBar extends StatelessWidget {
  const SetupProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  /// One-based number of the step being shown.
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: currentStep / totalSteps),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$currentStep/$totalSteps',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
