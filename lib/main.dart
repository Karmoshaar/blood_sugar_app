import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'helpers/app_launch_storage.dart';
import 'helpers/setup_flow_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final step = await AppLaunchStorage.getSetupStep();
  print("APP START STEP = $step");
  runApp(ProviderScope(child: MyApp(step: step)));
}

class MyApp extends StatelessWidget {
  final int step;

  const MyApp({super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SetupFlowController(step: step),
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
