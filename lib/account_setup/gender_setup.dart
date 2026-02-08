import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../helpers/app_launch_storage.dart';
import 'date_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import '../widgets/setup_progress_bar.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';

class GenderSetup extends ConsumerStatefulWidget {
  const GenderSetup({super.key});

  @override
  ConsumerState<GenderSetup> createState() => _GenderSetupState();
}

class _GenderSetupState extends ConsumerState<GenderSetup> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    // Removed AppLaunchStorage.setSetupStep(2) from here
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(userSetupProvider);
      if (state.gender != null) {
        setState(() {
          selectedGender = state.gender;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              )
            : null,
        title: SetupProgressBar(currentPage: 2),
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
                  ? () async {
                      ref
                          .read(userSetupProvider.notifier)
                          .setGender(selectedGender!);

                      // Save Step 3 ONLY when moving forward
                      await AppLaunchStorage.setSetupStep(3);

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DateSetup()),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.border,
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
          backgroundColor: isSelected ? AppColors.primary : Colors.grey[300],
          child: FaIcon(icon, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
