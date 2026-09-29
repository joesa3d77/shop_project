import 'package:flutter/material.dart';
import '../../core/assets/app_assets.dart';
import '../../core/colors/app_colors.dart';
import '../../core/network/token_storage.dart';
import '../get_started/onboarding_screen.dart';

/// أول شاشة تظهر لما التطبيق يفتح، فيها اللوجو بس، وبعد ثانيتين
/// بنوديك على طول لشاشات الـ Onboarding عشان تعمل Login/Register
/// بنفسك في كل مرة تشغل فيها التطبيق (من غير حفظ توكن ولا تخطي
/// تلقائي لصفحة الهوم) — وده بيخلينا متأكدين إن التوكن اللي بيتبعت
/// للسيرفر دايما جديد وصحيح.
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
    // بنمسح أي توكن قديم متخزن من مرة سابقة، عشان نضمن إن
    // كل تشغيل للتطبيق يبدأ نضيف من غير أي بيانات دخول قديمة.
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
        // TODO: asset -> ده مكان لوجو "Stylish" (الدايرتين المتشابكتين)
        // حط صورته في assets/images/logo.png وشغّل AppAssets.logo بدل الكود ده
        // مثال: Image.asset(AppAssets.logo, width: 140)

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
