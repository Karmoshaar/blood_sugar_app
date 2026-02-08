import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../helpers/app_launch_storage.dart';
import 'height_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import '../widgets/setup_progress_bar.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';

class WeightSetup extends ConsumerStatefulWidget {
  const WeightSetup({super.key});

  @override
  ConsumerState<WeightSetup> createState() => _WeightSetupState();
}

class _WeightSetupState extends ConsumerState<WeightSetup> {
  int _kg = 70;
  bool _isKg = true;
  bool _initialized = false;

  static const double _kgToLbFactor = 2.20462262;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Removed AppLaunchStorage.setSetupStep(4) from here

    if (!_initialized) {
      _loadSavedData();
      _initialized = true;
    }
  }

  void _loadSavedData() {
    final state = ref.read(userSetupProvider);

    if (state.weight != null && state.weight! > 0) {
      setState(() {
        _kg = state.weight!.toInt();
      });
    }
  }

  int get _displayValue => _isKg ? _kg : (_kg * _kgToLbFactor).round();
  int get _minValue => _isKg ? 30 : (30 * _kgToLbFactor).round();
  int get _maxValue => _isKg ? 200 : (200 * _kgToLbFactor).round();

  void _onValueChanged(int value) {
    setState(() {
      if (_isKg) {
        _kg = value;
      } else {
        _kg = (value / _kgToLbFactor).round();
        _kg = _kg.clamp(30, 200);
      }
    });
  }

  void _saveAndContinue() async {
    ref.read(userSetupProvider.notifier).setWeight(_kg.toDouble());

    // Save Step 5 ONLY when moving forward
    await AppLaunchStorage.setSetupStep(5);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HeightSetup()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              )
            : null,
        title: const SetupProgressBar(currentPage: 4),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 28),
            _buildTitle(),
            const SizedBox(height: 18),
            _buildUnitSelector(),
            const SizedBox(height: 18),
            _buildWeightPicker(),
            const SizedBox(height: 20),
            _buildContinueButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "What's your body weight?",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUnitSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _unitButton('kg', _isKg, () => setState(() => _isKg = true)),
        const SizedBox(width: 12),
        _unitButton('lb', !_isKg, () => setState(() => _isKg = false)),
      ],
    );
  }

  Widget _buildWeightPicker() {
    return Expanded(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        child: Stack(
          key: ValueKey(_isKg),
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
            _buildSelectionIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator() {
    return IgnorePointer(
      child: Center(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
                width: 2,
              ),
              bottom: BorderSide(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _saveAndContinue,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 80,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        elevation: 2,
      ),
      child: const Text(
        "Continue",
        style: TextStyle(color: AppColors.textWhite, fontSize: 18),
      ),
    );
  }

  Widget _unitButton(String label, bool active, VoidCallback onTap) {
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
              : [],
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
