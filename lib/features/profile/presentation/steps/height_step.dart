import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/profile_setup_controller.dart';
import '../widgets/setup_step_layout.dart';
import '../widgets/unit_toggle.dart';

class HeightStep extends ConsumerStatefulWidget {
  const HeightStep({super.key});

  @override
  ConsumerState<HeightStep> createState() => _HeightStepState();
}

class _HeightStepState extends ConsumerState<HeightStep> {
  static const double _cmPerInch = 2.54;
  static const int _minCm = 100;
  static const int _maxCm = 220;

  int _cm = 170;
  bool _isCm = true;

  @override
  void initState() {
    super.initState();
    final saved = ref.read(profileSetupProvider).heightCm;
    if (saved != null) _cm = saved.round().clamp(_minCm, _maxCm);
  }

  int get _totalInches => (_cm / _cmPerInch).round();
  int get _feet => (_totalInches ~/ 12).clamp(3, 7);
  int get _inches => _totalInches % 12;

  void _setFeetInches(int feet, int inches) {
    setState(() {
      _cm = ((feet * 12 + inches) * _cmPerInch).round().clamp(_minCm, _maxCm);
    });
  }

  String get _displayText => _isCm ? '$_cm cm' : "$_feet'$_inches\"";

  @override
  Widget build(BuildContext context) {
    return SetupStepLayout(
      title: "What's your height?",
      onContinue: () =>
          ref.read(profileSetupProvider.notifier).submitHeight(_cm.toDouble()),
      child: Column(
        children: [
          const SizedBox(height: 20),
          UnitToggle(
            labels: const ['cm', 'ft'],
            selectedIndex: _isCm ? 0 : 1,
            onChanged: (i) => setState(() => _isCm = i == 0),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: _isCm
                ? _picker(
                    value: _cm,
                    min: _minCm,
                    max: _maxCm,
                    onChanged: (v) => setState(() => _cm = v),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _picker(
                        value: _feet,
                        min: 3,
                        max: 7,
                        onChanged: (v) => _setFeetInches(v, _inches),
                      ),
                      const Text("'", style: TextStyle(fontSize: 28)),
                      _picker(
                        value: _inches,
                        min: 0,
                        max: 11,
                        onChanged: (v) => _setFeetInches(_feet, v),
                      ),
                      const Text('"', style: TextStyle(fontSize: 28)),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            _displayText,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _picker({
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return NumberPicker(
      value: value,
      minValue: min,
      maxValue: max,
      itemHeight: 50,
      selectedTextStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      textStyle: TextStyle(color: AppColors.disabled, fontSize: 18),
      onChanged: onChanged,
    );
  }
}
