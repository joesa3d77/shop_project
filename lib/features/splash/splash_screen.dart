import 'package:flutter/material.dart';
import '../../core/assets/app_assets.dart';
import '../../core/colors/app_colors.dart';
import '../../core/network/token_storage.dart';
import '../get_started/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await TokenStorage.clearToken();

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(AppAssets.logo, fit: BoxFit.cover,width: 140),
             SizedBox(height: 8),

          ],
        ),
      ),
    );
  }
}
