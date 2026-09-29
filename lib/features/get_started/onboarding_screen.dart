import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/colors/app_colors.dart';
import 'get_started_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingItem {
  final String title;
  final String subtitle;
  final String svgAsset;
  const _OnboardingItem(this.title, this.subtitle, this.svgAsset);
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  int currentPage = 0;

  final items = const [
    _OnboardingItem(
      'Choose Products',
      'Amet minim mollit non deserunt ullamco est aliqua dolor do amet sint.',
      'assets/images/onboarding1.svg',
    ),
    _OnboardingItem(
      'Make Payment',
      'Amet minim mollit non deserunt ullamco est aliqua dolor do amet sint.',
      'assets/images/onboarding2.svg',
    ),
    _OnboardingItem(
      'Get Your Order',
      'Amet minim mollit non deserunt ullamco est aliqua dolor do amet sint.',
      'assets/images/onboarding3.svg',
    ),
  ];

  void _goToGetStarted() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const GetStartedScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = currentPage == items.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _goToGetStarted,
                  child: const Text('Skip', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: items.length,
                onPageChanged: (i) => setState(() => currentPage = i),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       SvgPicture.asset(item.svgAsset, color: AppColors.primary),
                        const SizedBox(height: 32),
                        Text(item.title,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(item.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.grey)),
                      ],
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentPage == i ? AppColors.primary : AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: currentPage == 0
                        ? null
                        : () => controller.previousPage(
                        duration: const Duration(milliseconds: 250), curve: Curves.ease),
                    child: const Text('Prev'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (isLast) {
                        _goToGetStarted();
                      } else {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 250), curve: Curves.ease);
                      }
                    },
                    child: Text(isLast ? 'Get Started' : 'Next',
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
