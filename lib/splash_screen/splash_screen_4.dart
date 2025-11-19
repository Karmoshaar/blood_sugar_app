import 'package:flutter/material.dart';

class SplashScreen4 extends StatelessWidget {
  const SplashScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 251, 68, 82),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 251, 68, 82),
                      Color.fromARGB(255, 251, 68, 82),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'asset/image/mobile4.png',
                    width: 300,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Consult with Our AI Chat Doctor",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Experience personalized health consultations with our AI Chat Doctor. Get health advice anytime, anywhere.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
