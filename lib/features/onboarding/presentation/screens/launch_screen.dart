import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/theme/app_colors.dart';
import 'intro_screen.dart';

/// Branded splash shown on first launch before the intro pages.
class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'asset/image/logo.png',
              width: 150,
              height: 150,
              errorBuilder: (_, _, _) => const SizedBox(),
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
