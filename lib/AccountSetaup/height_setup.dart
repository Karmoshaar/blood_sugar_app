import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'remind_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
class HeightSetup extends ConsumerStatefulWidget {
  const HeightSetup({super.key});

  @override
  ConsumerState<HeightSetup> createState() => _HeightSetupState();
}

class _HeightSetupState extends ConsumerState<HeightSetup> {
  int _cm = 170;
  bool _isCm = true;

  // للفيديو: feet و inches
  int _feet = 5;
  int _inches = 7;

  static const double _cmToInchFactor = 0.393701;

  String get _displayText {
    if (_isCm) return '$_cm cm';
    return "${_feet}’${_inches}\"";
  }

  void _updateFeetInches() {
    int totalInches = (_cm * _cmToInchFactor).round();
    _feet = totalInches ~/ 12;
    _inches = totalInches % 12;
  }

  void _updateCmFromFeetInches() {
    _cm = ((_feet * 12 + _inches) / _cmToInchFactor).round();
  }

  Widget _unitButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFB4452) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? Colors.transparent : Colors.grey.shade400,
          ),
          boxShadow: active
              ? [
            BoxShadow(
              color: Colors.red.shade200,
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userSetupProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: userState.progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFFB4452)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text('${userState.completedSteps}/6', style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 28),
            const Text(
              "What's your height?",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _unitButton('cm', _isCm, () {
                  setState(() {
                    _isCm = true;
                  });
                }),
                const SizedBox(width: 12),
                _unitButton('ft', !_isCm, () {
                  setState(() {
                    _isCm = false;
                    _updateFeetInches(); // تحديث القيمة عند التبديل
                  });
                }),
              ],
            ),

            const SizedBox(height: 20),

            // NumberPicker
            if (_isCm)
              SizedBox(
                height: 250,
                child: NumberPicker(
                  value: _cm,
                  minValue: 100,
                  maxValue: 220,
                  step: 1,
                  itemHeight: 50,
                  selectedTextStyle: const TextStyle(
                    color: Color(0xFFFB4452),
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  textStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 18),
                  onChanged: (v) => setState(() {
                    _cm = v;
                  }),
                ),
              )
            else
              SizedBox(
                height: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Feet picker
                    NumberPicker(
                      value: _feet,
                      minValue: 3,
                      maxValue: 7,
                      step: 1,
                      itemHeight: 50,
                      selectedTextStyle: const TextStyle(
                        color: Color(0xFFFB4452),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                      textStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 18),
                      onChanged: (v) => setState(() {
                        _feet = v;
                        _updateCmFromFeetInches();
                      }),
                    ),
                    const SizedBox(width: 8),
                    const Text("’", style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 8),
                    // Inches picker
                    NumberPicker(
                      value: _inches,
                      minValue: 0,
                      maxValue: 11,
                      step: 1,
                      itemHeight: 50,
                      selectedTextStyle: const TextStyle(
                        color: Color(0xFFFB4452),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                      textStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 18),
                      onChanged: (v) => setState(() {
                        _inches = v;
                        _updateCmFromFeetInches();
                      }),
                    ),
                    const SizedBox(width: 8),
                    const Text("\"", style: TextStyle(fontSize: 28)),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // النص الكبير مع الخط الرمادي فوقه
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    width: 80,
                    height: 2,
                    color: Colors.grey.shade400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _displayText,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFB4452),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                ref.read(userSetupProvider.notifier).setHeight(_cm.toDouble());
                print('تم طباعة الطول:$_cm cm');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const remindSetup()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFB4452),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 80,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                elevation: 5,
                shadowColor: Colors.red.shade200,
              ),
              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
