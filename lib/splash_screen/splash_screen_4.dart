import 'package:flutter/material.dart';

class SplashScreen4 extends StatefulWidget {
  const SplashScreen4({super.key});

  @override
  _SplashScreen4State createState() => _SplashScreen4State();
}

class _SplashScreen4State extends State<SplashScreen4> {
  int currentPage = 3;

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
              decoration: BoxDecoration(
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
                  width: 400,
                  height: 500,
                ),
              ),
            ),

            SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Text(
                      "Consult with Our Al Chat\n"
                      "Doctor",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Experience personalized health consultations\n"
                        "with our Al Chat Doctor. Get health advice\n"
                        "anytime, anywhere.",
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
