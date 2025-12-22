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
  bool _initialized = false;

  static const double _kgToLbFactor = 2.20462262;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // تنفيذ مرة واحدة فقط
    if (!_initialized) {
      _loadSavedData();
      _initialized = true;
    }
  }

  /// تحميل البيانات المحفوظة من Provider
  void _loadSavedData() {
    final state = ref.read(userSetupProvider);

    if (state.weight != null && state.weight! > 0) {
      setState(() {
        _kg = state.weight!.toInt();
      });
    }
  }

  /// حساب القيمة المعروضة حسب الوحدة
  int get _displayValue => _isKg ? _kg : (_kg * _kgToLbFactor).round();

  /// الحد الأدنى للقيمة حسب الوحدة
  int get _minValue => _isKg ? 30 : (30 * _kgToLbFactor).round();

  /// الحد الأقصى للقيمة حسب الوحدة
  int get _maxValue => _isKg ? 200 : (200 * _kgToLbFactor).round();

  /// معالج تغيير القيمة
  void _onValueChanged(int value) {
    setState(() {
      if (_isKg) {
        _kg = value;
      } else {
        // تحويل من lb إلى kg
        _kg = (value / _kgToLbFactor).round();

        // التحقق من النطاق
        _kg = _kg.clamp(30, 200);
      }
    });
  }

  /// حفظ البيانات والانتقال للصفحة التالية
  void _saveAndContinue() {
    ref.read(userSetupProvider.notifier).setWeight(_kg.toDouble());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HeightSetup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
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

  /// بناء العنوان
  Widget _buildTitle() {
    return const Text(
      "What's your body weight?",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  /// بناء محدد الوحدة
  Widget _buildUnitSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _unitButton(
          'kg',
          _isKg,
              () => setState(() => _isKg = true),
        ),
        const SizedBox(width: 12),
        _unitButton(
          'lb',
          !_isKg,
              () => setState(() => _isKg = false),
        ),
      ],
    );
  }

  /// بناء Number Picker
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

  /// بناء مؤشر التحديد
  Widget _buildSelectionIndicator() {
    return IgnorePointer(
      child: Center(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.primaryLight.withOpacity(0.5),
                width: 2,
              ),
              bottom: BorderSide(
                color: AppColors.primaryLight.withOpacity(0.5),
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// بناء زر المتابعة
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

  /// بناء زر الوحدة
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