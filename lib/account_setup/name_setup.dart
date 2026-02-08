import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../helpers/app_launch_storage.dart';
import '../widgets/setup_progress_bar.dart';
import 'gender_setup.dart';

class NameSetup extends ConsumerStatefulWidget {
  const NameSetup({super.key});

  @override
  ConsumerState<NameSetup> createState() => _NameSetupState();
}

class _NameSetupState extends ConsumerState<NameSetup> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Removed AppLaunchStorage.setSetupStep(1) from here to prevent automatic increment/re-save
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(userSetupProvider);
      if (state.name != null) {
        _nameController.text = state.name!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Safety: Disable back button if this is the root setup screen to avoid black screen
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              )
            : null,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: SetupProgressBar(currentPage: 1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            const Text(
              'What is your name?',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Enter your name',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  ref
                      .read(userSetupProvider.notifier)
                      .setName(_nameController.text);

                  // Save the next step (2) ONLY when the user successfully clicks Continue
                  await AppLaunchStorage.setSetupStep(2);

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GenderSetup()),
                    );
                  }
                }
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
}
