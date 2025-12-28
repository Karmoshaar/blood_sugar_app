import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter/material.dart';
import 'package:blood_sugar_app_1/HealthData/sugar_stats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import '../widgets/setup_progress_bar.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
import 'package:blood_sugar_app_1/core/providers/auth_provider.dart';

class remindSetup extends ConsumerStatefulWidget {
  const remindSetup({super.key});

  @override
  ConsumerState<remindSetup> createState() => _remindSetupState();
}

class _remindSetupState extends ConsumerState<remindSetup> {
  bool _isLoading = false;
  DateTime _selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userSetupProvider);
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
        title: SetupProgressBar(currentPage: 6),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 28),
            const Text(
              "When would you like to"
              "receive health check                            "
              "reminders?",
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
                    // Handle time change if needed
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
                      // بداية التحميل
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        // حفظ وقت التذكير
                        ref
                            .read(userSetupProvider.notifier)
                            .setReminderTime(_selectedTime);

                        print('🚀 جاري إرسال البيانات...');
                        print('⏰ وقت التذكير: $_selectedTime');

                        // إرسال البيانات
                        final userSetup = ref.read(userSetupProvider);

                        await ref.read(authProvider.notifier).setupAccount(
                          name: userSetup.name!,
                          gender: userSetup.gender!,
                          birthDate: userSetup.birthDate!,
                          weight: userSetup.weight!,
                          height: userSetup.height!,
                        );


                        print('✅ تم إرسال البيانات بنجاح!');

                        // إيقاف التحميل
                        setState(() {
                          _isLoading = false;
                        });

                        // الانتقال للصفحة التالية
                        if (mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SugarStats(),
                            ),
                          );
                        }
                      } catch (e) {
                        // إيقاف التحميل
                        setState(() {
                          _isLoading = false;
                        });

                        // إظهار رسالة الخطأ
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('فشل في إرسال البيانات: $e'),
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }

                        print('❌ خطأ في إرسال البيانات: $e');
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
