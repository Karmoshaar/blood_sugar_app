import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'name_setup.dart';

class HeightSetup extends StatefulWidget {
  const HeightSetup({super.key});

  @override
  State<HeightSetup> createState() => _HeightSetupState();
}

class _HeightSetupState extends State<HeightSetup> {
  int _cm = 170; // الطول بالسم
  bool _isCm = true; // true = cm, false = ft+inch

  static const double _cmToInchFactor = 0.393701;

  String get _displayText {
    if (_isCm) return '$_cm cm';
    int totalInches = (_cm * _cmToInchFactor).round();
    int feet = totalInches ~/ 12;
    int inches = totalInches % 12;
    return "${feet}’${inches}\"";
  }

  int get _pickerValue => _isCm ? _cm : (_cm * _cmToInchFactor).round();

  int get _minValue => _isCm ? 100 : (100 * _cmToInchFactor).round();

  int get _maxValue => _isCm ? 220 : (220 * _cmToInchFactor).round();

  void _onValueChanged(int value) {
    setState(() {
      if (_isCm) {
        _cm = value;
      } else {
        _cm = (value / _cmToInchFactor).round();
      }
    });
  }

  void _toggleUnit(bool toCm) {
    setState(() {
      _isCm = toCm;
    });
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
                    value: 0.83,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFFB4452)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text('5/6', style: TextStyle(color: Colors.black)),
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

            // وحدة الطول
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _unitButton('cm', _isCm, () => _toggleUnit(true)),
                const SizedBox(width: 12),
                _unitButton('ft', !_isCm, () => _toggleUnit(false)),
              ],
            ),

            const SizedBox(height: 20),

            // NumberPicker
            SizedBox(
              height: 250,
              child: NumberPicker(
                value: _pickerValue,
                minValue: _minValue,
                maxValue: _maxValue,
                step: 1,
                itemHeight: 50,
                selectedTextStyle: const TextStyle(
                  color: Color(0xFFFB4452),
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
                textStyle: TextStyle(color: Colors.grey.shade400, fontSize: 18),
                onChanged: (v) => _onValueChanged(v),
              ),
            ),

            const SizedBox(height: 20),

            // النص الكبير مع الخط الرمادي فوقه
            Stack(
              alignment: Alignment.center,
              children: [
                // الخط الرمادي فوق النص
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NameSetup()),
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
