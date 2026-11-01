import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'root_shell.dart';

/// Brand splash — "Crunches Cafe" wordmark on the dark background, then
/// hands off to the bottom-nav shell. Pure UI, no real initialization work.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, animation, _) => FadeTransition(
              opacity: animation,
              child: const RootShell(),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayFont = Theme.of(context).textTheme.displayMedium?.fontFamily;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: displayFont, fontSize: 36, color: AppColors.foreground),
                children: const [
                  TextSpan(text: 'Crunches '),
                  TextSpan(text: 'Cafe', style: TextStyle(color: AppColors.gold)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'FAST FOOD · FAISALABAD',
              style: TextStyle(
                color: AppColors.foregroundMuted,
                fontSize: 12,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
