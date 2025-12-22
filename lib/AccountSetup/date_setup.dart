import 'package:flutter/material.dart';
import 'package:dss_cupertino_date_picker/dss_cupertino_date_picker.dart';
import 'weight_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';
import 'widgets/setup_progress_bar.dart';
import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
class DateSetup extends ConsumerStatefulWidget {
  const DateSetup({super.key});

  @override
  ConsumerState<DateSetup> createState() => _DateSetupState();
}

class _DateSetupState extends ConsumerState<DateSetup> {
  DateTime _selectedDate = DateTime.now();
  final DateTime _minDate = DateTime(1900, 1, 1);
  final DateTime _maxDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      final state = ref.read(userSetupProvider);
      if (state.birthDate != null) {
        setState(() {
          _selectedDate = state.birthDate!;
        });
      }
    });
  }

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
        title: SetupProgressBar(currentPage: 3),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          const Text(
            'When is your birthday?',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: CupertinoDatePicker(
              itemExtent: 50,
              minDate: _minDate,
              maxDate: _maxDate,
              selectedDate: _selectedDate,
              selectionOverlay: Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                ),
              ),
              selectedStyle: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              unselectedStyle: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
              disabledStyle: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
              ),
              onSelectedItemChanged: (date) {
                setState(() => _selectedDate = date);
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ref.read(userSetupProvider.notifier).setBirthDate(_selectedDate);
              print('تم حفظ التاريخ :$_selectedDate');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WeightSetup()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:  AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
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
    );
  }
}
