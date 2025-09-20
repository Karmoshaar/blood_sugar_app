import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'name_setup.dart';
import 'height_setup.dart';
class WeightSetup extends StatefulWidget {
  const WeightSetup({super.key});

  @override
  State<WeightSetup> createState() => _WeightSetupState();
}

class _WeightSetupState extends State<WeightSetup> {
  // internal state stored in kilograms
  int _kg = 70;
  bool _isKg = true;

  // helpers
  static const double _kgToLbFactor = 2.20462262;

  int get _displayValue => _isKg ? _kg : (_kg * _kgToLbFactor).round();

  int get _minValue => _isKg ? 30 : (30 * _kgToLbFactor).round();

  int get _maxValue => _isKg ? 200 : (200 * _kgToLbFactor).round();

  void _onValueChanged(int value) {
    setState(() {
      if (_isKg) {
        _kg = value;
      } else {
        // user changed value in LB -> convert back to kg and store
        _kg = (value / _kgToLbFactor).round();
      }
    });
  }

  void _toggleUnit(bool toKg) {
    setState(() {
      _isKg = toKg;
      // _kg remains the single source of truth, the NumberPicker will display converted value
    });
  }

  Widget _unitButton(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? const Color.fromARGB(255, 251, 68, 82)
              : Colors.transparent,
          border: Border.all(
            color: active ? Colors.transparent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: LinearProgressIndicator(
                  value: 0.67,
                  color: const Color.fromARGB(255, 251, 68, 82),
                  backgroundColor: Colors.grey.shade300,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 16),
              const Text('4/6', style: TextStyle(color: Colors.black)),
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
              "What's your body weight?",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),

            // unit toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _unitButton('kg', _isKg, () => _toggleUnit(true)),
                const SizedBox(width: 12),
                _unitButton('lb', !_isKg, () => _toggleUnit(false)),
              ],
            ),

            const SizedBox(height: 18),

            // picker with center overlay lines
            SizedBox(
              height: 400,
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
                        color: Color.fromARGB(255, 251, 68, 82),
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                      textStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 20,
                      ),
                      onChanged: (v) => _onValueChanged(v),
                    ),
                  ),

                  // overlay two thin lines (top & bottom) to indicate selected row
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

            const SizedBox(height: 250),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HeightSetup()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 251, 68, 82),
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
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
