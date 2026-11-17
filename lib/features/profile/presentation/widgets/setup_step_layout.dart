import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Shared frame for every setup step: a title, the step's input, and the
/// bottom action button.
class SetupStepLayout extends StatelessWidget {
  const SetupStepLayout({
    super.key,
    required this.title,
    required this.child,
    required this.onContinue,
    this.buttonLabel = 'Continue',
    this.isLoading = false,
  });

  final String title;
  final Widget child;

  /// Null disables the button.
  final VoidCallback? onContinue;
  final String buttonLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            title,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Expanded(child: child),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isLoading ? null : onContinue,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.border,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    buttonLabel,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 18,
                    ),
                  ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
