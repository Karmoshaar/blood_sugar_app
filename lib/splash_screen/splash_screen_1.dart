import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/splashMain');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 68, 82),
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
