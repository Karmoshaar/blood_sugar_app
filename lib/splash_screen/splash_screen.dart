import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'splash_screen_2.dart';
import 'splash_screen_3.dart';
import 'splash_screen_4.dart';
import 'package:blood_sugar_app_1/AccountSetaup/sign_up_screen.dart';
import 'package:blood_sugar_app_1/AccountSetaup/account_setup.dart';

class SplashMain extends StatefulWidget {
  @override
  _SplashMainState createState() => _SplashMainState();
}

class _SplashMainState extends State<SplashMain> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = (index == 2);
                  });
                },
                children: [
                  SplashScreen2(),
                  SplashScreen3(),
                  SplashScreen4(),
                  AccountSetup(),
                  SignUpScreen(),
                ],
              ),
            ),
            SizedBox(height: 20),
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Color.fromARGB(255, 251, 68, 82),
                dotColor: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  if (!isLastPage)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey),
                        ),
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: Color.fromARGB(255, 251, 68, 82),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                  if (!isLastPage) SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (isLastPage) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        } else {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Color.fromARGB(255, 251, 68, 82),
                      ),
                      child: Text(
                        isLastPage ? "Let's Get Started" : "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
