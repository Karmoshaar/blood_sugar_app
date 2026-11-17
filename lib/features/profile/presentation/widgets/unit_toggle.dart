import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Two pill buttons for switching units, e.g. kg / lb.
class UnitToggle extends StatelessWidget {
  const UnitToggle({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          _pill(labels[i], i == selectedIndex, () => onChanged(i)),
        ],
      ],
    );
  }

  Widget _pill(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: active ? Colors.transparent : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.primaryShadow,
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
              : const [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.textWhite : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
