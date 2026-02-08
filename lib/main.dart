import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'account_setup/name_setup.dart';
import 'helpers/app_launch_storage.dart';
import 'splash_screen/splash_screen_1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final reachedNAme = await AppLaunchStorage.hasReachedNameSetup();
  runApp(ProviderScope(child: MyApp(reachedName: reachedNAme)));
}

class MyApp extends StatelessWidget {
  final bool reachedName;

  const MyApp({super.key,
    required this.reachedName,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: reachedName
          ? const NameSetup()
          : const SplashScreen1(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
