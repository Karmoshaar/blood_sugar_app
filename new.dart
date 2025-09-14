import 'package:flutter/material.dart';
import 'package:blood_sugar_app_1/AccountSetaup/account_setup.dart';

void main() {
  runApp(const MyApp()); // تشغيل التطبيق الرئيسي
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AccountSetup(),
      debugShowCheckedModeBanner:
          false,
    );
  }
}
