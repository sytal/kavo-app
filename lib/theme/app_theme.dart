import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App-wide ThemeData — Fraunces for display/headings, Figtree for body
/// text, matching the website's font-display / font-sans convention.
class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(TextTheme base) {
    final display = GoogleFonts.frauncesTextTheme(base);
    final body = GoogleFonts.figtreeTextTheme(base);

    return body.copyWith(
      displayLarge: display.displayLarge?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w300),
      displayMedium: display.displayMedium?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w300),
      displaySmall: display.displaySmall?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w400),
      headlineLarge: display.headlineLarge?.copyWith(color: AppColors.foreground),
      headlineMedium: display.headlineMedium?.copyWith(color: AppColors.foreground),
      headlineSmall: display.headlineSmall?.copyWith(color: AppColors.foreground),
      titleLarge: display.titleLarge?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w500),
      titleMedium: body.titleMedium?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w600),
      titleSmall: body.titleSmall?.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w600),
      bodyLarge: body.bodyLarge?.copyWith(color: AppColors.foreground),
      bodyMedium: body.bodyMedium?.copyWith(color: AppColors.foregroundMuted),
      bodySmall: body.bodySmall?.copyWith(color: AppColors.foregroundMuted),
      labelLarge: body.labelLarge?.copyWith(color: AppColors.foreground, letterSpacing: 1.2),
      labelMedium: body.labelMedium?.copyWith(color: AppColors.foregroundMuted, letterSpacing: 1.5),
      labelSmall: body.labelSmall?.copyWith(color: AppColors.foregroundMuted, letterSpacing: 1.5),
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        surface: AppColors.background,
        primary: AppColors.gold,
        secondary: AppColors.goldLight,
        error: AppColors.danger,
      ),
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.foreground,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
      iconTheme: const IconThemeData(color: AppColors.foregroundMuted),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.foreground,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.figtree(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
        hintStyle: GoogleFonts.figtree(color: AppColors.foregroundMuted.withValues(alpha: 0.6)),
        labelStyle: GoogleFonts.figtree(color: AppColors.foregroundMuted),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.gold,
        unselectedItemColor: AppColors.foregroundMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      splashFactory: NoSplash.splashFactory,
    );
  }
}
