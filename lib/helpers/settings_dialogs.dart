import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> showNameDialog(
    BuildContext context,
    String currentName,
    ) async {
  final controller = TextEditingController(text: currentName);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Your Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('userName', name);

              Navigator.pop(context, name);
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
