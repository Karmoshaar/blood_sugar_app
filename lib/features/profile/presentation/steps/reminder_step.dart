import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../readings/presentation/screens/dashboard_screen.dart';
import '../providers/profile_setup_controller.dart';
import '../widgets/setup_step_layout.dart';

class ReminderStep extends ConsumerStatefulWidget {
  const ReminderStep({super.key});

  @override
  ConsumerState<ReminderStep> createState() => _ReminderStepState();
}

class _ReminderStepState extends ConsumerState<ReminderStep> {
  bool _isLoading = false;
  DateTime _selectedTime = DateTime.now();

  Future<void> _finish() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(profileSetupProvider.notifier)
          .finish(TimeOfDay.fromDateTime(_selectedTime));
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not finish setup: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SetupStepLayout(
      title: 'When would you like to receive health check reminders?',
      buttonLabel: 'Finish',
      isLoading: _isLoading,
      onContinue: _finish,
      child: Center(
        child: TimePickerSpinner(
          time: _selectedTime,
          is24HourMode: false,
          normalTextStyle: const TextStyle(fontSize: 24, color: Colors.grey),
          highlightedTextStyle: const TextStyle(
            fontSize: 24,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          spacing: 50,
          itemHeight: 80,
          isForce2Digits: true,
          onTimeChange: (time) => _selectedTime = time,
        ),
      ),
    );
  }
}
