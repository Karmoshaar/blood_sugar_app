import 'package:blood_sugar_app_1/core/providers/auth_provider.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
import 'package:blood_sugar_app_1/health_data/sugar_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../helpers/app_launch_storage.dart';
import '../widgets/setup_progress_bar.dart';

class RemindSetup extends ConsumerStatefulWidget {
  const RemindSetup({super.key});

  @override
  ConsumerState<RemindSetup> createState() => _RemindSetupState();
}

class _RemindSetupState extends ConsumerState<RemindSetup> {
  bool _isLoading = false;
  DateTime _selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // تعديل: تم حذف setSetupStep من هنا لمنع زيادة رقم الخطوة تلقائياً عند إعادة بناء الشاشة (Rebuild)
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.background,
        elevation: 0,
        // تعديل: إضافة فحص Navigator.canPop لمنع ظهور زر الرجوع إذا كانت هذه الشاشة هي الرئيسية (تجنباً للشاشة السوداء)
        leading: Navigator.canPop(context)
            ? IconButton(
                // تعديل: استخدام maybePop لضمان عدم الخروج من التطبيق إلى شاشة فارغة
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              )
            : null,
        title: SetupProgressBar(currentPage: 6),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 28),
            const Text(
              "When would you like to receive health check reminders?",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TimePickerSpinner(
                  time: _selectedTime,
                  is24HourMode: false,
                  normalTextStyle: const TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                  highlightedTextStyle: const TextStyle(
                    fontSize: 24,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  spacing: 50,
                  itemHeight: 80,
                  isForce2Digits: true,
                  onTimeChange: (time) {
                    _selectedTime = time;
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        ref
                            .read(userSetupProvider.notifier)
                            .setReminderTime(_selectedTime);

                        final userSetup = ref.read(userSetupProvider);

                        await ref.read(authProvider.notifier).setupAccount(
                              name: userSetup.name!,
                              gender: userSetup.gender!,
                              birthDate: userSetup.birthDate!,
                              weight: userSetup.weight!,
                              height: userSetup.height!,
                            );

                        // تعديل: حفظ القيمة (0) فقط عند إتمام الإعداد بنجاح للإشارة إلى انتهاء مرحلة الـ Setup
                        await AppLaunchStorage.setSetupStep(0);

                        setState(() {
                          _isLoading = false;
                        });

                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SugarStats(),
                            ),
                          );
                        }
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to send data: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
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
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Finish",
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 18,
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
