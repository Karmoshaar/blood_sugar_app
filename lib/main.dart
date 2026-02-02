import 'package:flutter/material.dart';
import 'splash_screen/splash_screen_1.dart';
import 'splash_screen/splash_screen.dart';
import 'account_setup/account_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'health_data/sugar_stats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => SplashScreen1(),
        '/splashMain': (_) => SplashMain(),
        '/account_setup': (_) => AccountSetup(),
        '/SugarStats': (_) => SugarStats(),
      },
    );
  }
}
