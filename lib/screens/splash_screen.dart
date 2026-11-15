import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'root_shell.dart';

/// Brand splash — KAVO logo (cup + energy bolt) and tagline on the dark background, then
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/kavo-mark.png', width: 44, height: 44, color: AppColors.gold),
                const SizedBox(width: 12),
                Text(
                  'KAVO',
                  style: TextStyle(
                    fontFamily: displayFont,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 5,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'COFFEE BRINGS ENERGY',
              style: TextStyle(
                color: AppColors.gold,
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
