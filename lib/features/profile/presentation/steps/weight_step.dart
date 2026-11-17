import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/profile_setup_controller.dart';
import '../widgets/setup_step_layout.dart';
import '../widgets/unit_toggle.dart';

class WeightStep extends ConsumerStatefulWidget {
  const WeightStep({super.key});

  @override
  ConsumerState<WeightStep> createState() => _WeightStepState();
}

class _WeightStepState extends ConsumerState<WeightStep> {
  static const double _kgToLb = 2.20462262;
  static const int _minKg = 30;
  static const int _maxKg = 200;

  int _kg = 70;
  bool _isKg = true;

  @override
  void initState() {
    super.initState();
    final saved = ref.read(profileSetupProvider).weightKg;
    if (saved != null) _kg = saved.round().clamp(_minKg, _maxKg);
  }

  int _toDisplay(int kg) => _isKg ? kg : (kg * _kgToLb).round();

  void _onValueChanged(int value) {
    setState(() {
      _kg = _isKg ? value : (value / _kgToLb).round().clamp(_minKg, _maxKg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SetupStepLayout(
      title: "What's your body weight?",
      onContinue: () =>
          ref.read(profileSetupProvider.notifier).submitWeight(_kg.toDouble()),
      child: Column(
        children: [
          const SizedBox(height: 18),
          UnitToggle(
            labels: const ['kg', 'lb'],
            selectedIndex: _isKg ? 0 : 1,
            onChanged: (i) => setState(() => _isKg = i == 0),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                NumberPicker(
                  key: ValueKey(_isKg),
                  value: _toDisplay(_kg),
                  minValue: _toDisplay(_minKg),
                  maxValue: _toDisplay(_maxKg),
                  itemHeight: 40,
                  selectedTextStyle: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  textStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 20,
                  ),
                  onChanged: _onValueChanged,
                ),
                IgnorePointer(
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: AppColors.primaryLight.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
