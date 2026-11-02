import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  // Restores a saved sign-in (if any) before the splash hands off to the
  // rest of the app, so Profile/Order History reflect the right state from
  // the first frame instead of flashing "signed out" then flipping.
  AuthService.instance.bootstrap();
  runApp(const CrunchesCafeApp());
}

class CrunchesCafeApp extends StatelessWidget {
  const CrunchesCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crunches Cafe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
