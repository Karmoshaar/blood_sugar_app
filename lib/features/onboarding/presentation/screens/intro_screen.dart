import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/screens/sign_up_screen.dart';
import '../widgets/intro_page.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  static const _pages = [
    IntroPage(
      image: 'asset/image/mobile2.png',
      title: 'Pulsey! Your Personal Health Companion',
      description:
          "Stay in tune with your heart's rhythm. Monitor your heart rate in real-time with precise measurements and insightful analysis.",
    ),
    IntroPage(
      image: 'asset/image/mobile3.png',
      title: 'All-in-One Health Monitoring',
      description:
          'Track blood pressure, sugar, weight & BMI.\nGain control over your health with comprehensive tracking tools.',
    ),
    IntroPage(
      image: 'asset/image/mobile4.png',
      title: 'Consult with Our AI Chat Doctor',
      description:
          'Experience personalized health consultations with our AI Chat Doctor. Get health advice anytime, anywhere.',
    ),
  ];

  final PageController _controller = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  onPageChanged: (index) =>
                      setState(() => _isLastPage = index == _pages.length - 1),
                  children: _pages,
                ),
              ),
              const SizedBox(height: 20),
              SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppColors.primary,
                  dotColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    if (!_isLastPage) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _goToSignUp,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_isLastPage) {
                            _goToSignUp();
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(
                          _isLastPage ? "Let's Get Started" : 'Next',
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
