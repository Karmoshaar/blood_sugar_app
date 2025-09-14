import 'package:flutter/material.dart';

class SplashScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 251, 68, 82),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 350,
              color: Color.fromARGB(255, 251, 68, 82),
              child: Center(
                child: Image.asset(
                  'asset/image/mobile2.png',
                  width: 300,
                  height: 400,
                ),
              ),
            ),

            SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      "Pulsey! Your Personal Health Companion",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Stay in tune with your heart's rhythm. Monitor your heart rate in real-time with precise measurements and insightful analysis.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
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
