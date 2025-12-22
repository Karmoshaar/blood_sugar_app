import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'height_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import 'widgets/setup_progress_bar.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
class WeightSetup extends ConsumerStatefulWidget {
  const WeightSetup({super.key});

  @override
  ConsumerState<WeightSetup> createState() => _WeightSetupState();
}

class _WeightSetupState extends ConsumerState<WeightSetup> {
  int _kg = 70;
  bool _isKg = true;

  static const double _kgToLbFactor = 2.20462262;

  int get _displayValue => _isKg ? _kg : (_kg * _kgToLbFactor).round();

  int get _minValue => _isKg ? 30 : (30 * _kgToLbFactor).round();

  int get _maxValue => _isKg ? 200 : (200 * _kgToLbFactor).round();

  void _onValueChanged(int value) {
    setState(() {
      if (_isKg) {
        _kg = value;
      } else {
        _kg = (value / _kgToLbFactor).round();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userSetupProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: SetupProgressBar(currentPage: 4),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 28),
            const Text(
              "What's your body weight?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _unitButton('kg', _isKg, () => setState(() => _isKg = true)),
                const SizedBox(width: 12),
                _unitButton('lb', !_isKg, () => setState(() => _isKg = false)),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: NumberPicker(
                      value: _displayValue,
                      minValue: _minValue,
                      maxValue: _maxValue,
                      step: 1,
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
                  ),
                  IgnorePointer(
                    child: Center(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.red.shade200,
                              width: 2,
                            ),
                            bottom: BorderSide(
                              color: Colors.red.shade200,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(userSetupProvider.notifier).setWeight(_kg.toDouble());
                print('تم حفظ الوزن:$_kg kg');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HeightSetup()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 80,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(color: AppColors.textWhite, fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _unitButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary
              : Colors.transparent,
          border: Border.all(
            color: active ? Colors.transparent : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
