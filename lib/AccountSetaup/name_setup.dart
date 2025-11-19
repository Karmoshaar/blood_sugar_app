import 'package:flutter/material.dart';
import 'Gender_Setup.dart';

class NameSetup extends StatefulWidget {
  const NameSetup({super.key});

  @override
  _NameSetupState createState() => _NameSetupState();
}

class _NameSetupState extends State<NameSetup> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                  value: 0.16,
                  color: const Color.fromARGB(255, 251, 68, 82),
                  backgroundColor: Colors.grey.shade300,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 16),
              const Text('1/6', style: TextStyle(color: Colors.black)),
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