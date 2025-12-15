import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'date_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';

class GenderSetup extends ConsumerStatefulWidget {
  const GenderSetup({super.key});

  @override
  ConsumerState<GenderSetup> createState() => _GenderSetupState();
}

class _GenderSetupState extends ConsumerState<GenderSetup> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  value: 0.32,
                  color: const Color.fromARGB(255, 251, 68, 82),
                  backgroundColor: Colors.grey.shade300,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 16),
              const Text('2/6', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            const Text(
              'What is your gender?',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGenderOption(
                  icon: FontAwesomeIcons.mars,
                  isSelected: selectedGender == "male",
                  onTap: () => setState(() => selectedGender = "male"),
                ),
                const SizedBox(width: 30),
                _buildGenderOption(
                  icon: FontAwesomeIcons.venus,
                  isSelected: selectedGender == "female",
                  onTap: () => setState(() => selectedGender = "female"),
                ),
              ],
            ),
            const Spacer(flex: 3),
            ElevatedButton(
              onPressed: selectedGender != null
                  ? () {
                      ref
                          .read(userSetupProvider.notifier)
                          .setGender(selectedGender!);

                      print('✅ تم حفظ الجنس: $selectedGender');

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DateSetup()),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 251, 68, 82),
                disabledBackgroundColor: Colors.grey.shade300,
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: CircleAvatar(
          radius: 60,
          backgroundColor: isSelected
              ? const Color.fromARGB(255, 251, 68, 82)
              : Colors.grey[300],
          child: FaIcon(icon, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
