import 'package:blood_sugar_app_1/core/theme/app_colors.dart';
import 'package:blood_sugar_app_1/helpers/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'splash_screen.dart';
class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
   initState() {
    super.initState();
    _requestPermission();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SplashMain(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Spacer(),
            Image.asset(
              'asset/image/logo.png',
              width: 150,
              height: 150,
              errorBuilder: (context, error, stackTrace) {
                return const Text('Failed to load image');
              },
            ),
            const Spacer(),
            LoadingAnimationWidget.inkDrop(color: Colors.white, size: 80),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
Future <void>_requestPermission() async{
await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
}