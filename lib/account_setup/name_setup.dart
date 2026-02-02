import 'package:flutter/material.dart';
import 'gender_setup.dart';
import '../widgets/setup_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(userSetupProvider);
      if (state.name != null) {
        _nameController.text = state.name!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userSetupProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
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
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  // حفظ الاسم في Provider
                  ref
                      .read(userSetupProvider.notifier)
                      .setName(_nameController.text);

                  // طباعة للتأكد (اختياري - للتجربة)
                  print('✅ تم حفظ الاسم: ${_nameController.text}');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GenderSetup()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  AppColors.primary,
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
                style:  TextStyle(color: AppColors.textWhite, fontSize: 18),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
