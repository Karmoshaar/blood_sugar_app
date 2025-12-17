import 'package:flutter/material.dart';
import 'Gender_Setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_sugar_app_1/core/providers/user_setup_provider/userـsetupـnotifier.dart';

class NameSetup extends ConsumerStatefulWidget {
  const NameSetup({super.key});

  @override
  ConsumerState<NameSetup> createState() => _NameSetupState();
}

class _NameSetupState extends ConsumerState<NameSetup> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userSetupProvider);
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
                  value: userState.progress,
                  color: const Color.fromARGB(255, 251, 68, 82),
                  backgroundColor: Colors.grey.shade300,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 16),
             Text('${userState.completedSteps}/6', style: TextStyle(color: Colors.black)),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
