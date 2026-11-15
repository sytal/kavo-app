import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/auth_service.dart';
import 'services/menu_service.dart';
import 'services/cart_service.dart';
import 'services/business_service.dart';
import 'services/theme_loader.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fonts ship inside the app (assets/google_fonts); never fetch at runtime.
  GoogleFonts.config.allowRuntimeFetching = false;
  // Use the colour theme picked in Admin > Appearance.
  await ThemeLoader.load();
  final iconBrightness = AppColors.isLight ? Brightness.dark : Brightness.light;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: iconBrightness,
      systemNavigationBarColor: AppColors.surface,
      systemNavigationBarIconBrightness: iconBrightness,
    ),
  );
  BusinessService.instance.load();
  CartService.instance.load();
  // Restores a saved sign-in (if any) before the splash hands off to the
  // rest of the app, so Profile/Order History reflect the right state from
  // the first frame instead of flashing "signed out" then flipping.
  AuthService.instance.bootstrap();
  // Fetch the live menu in the background; the bundled menu shows until
  // it arrives (or if the server can't be reached).
  MenuService.instance.load();
  runApp(const KavoApp());
}

class KavoApp extends StatelessWidget {
  const KavoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KAVO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark, // built from AppColors, which already holds the active light/dark palette
      darkTheme: AppTheme.dark,
      themeMode: AppColors.isLight ? ThemeMode.light : ThemeMode.dark,
      home: const SplashScreen(),
    );
  }
}
