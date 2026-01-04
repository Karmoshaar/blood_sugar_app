import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';

class SetupProgressBar extends ConsumerWidget {
  final int currentPage;
  final int totalPages;

  const SetupProgressBar({
    super.key,
    required this.currentPage,
    this.totalPages = 6,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userSetupProvider);

    final currentPageProgress = currentPage / totalPages;
    final displayProgress = userState.progress > currentPageProgress
        ? userState.progress
        : currentPageProgress;

    final displayStep = userState.completedSteps > currentPage
        ? userState.completedSteps
        : currentPage;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: displayProgress,
                minHeight: 12,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation(AppColors.primaryDark),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$displayStep/$totalPages',
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
