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
    final base = AppColors.isLight ? ThemeData.light(useMaterial3: true) : ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        surface: AppColors.background,
        primary: AppColors.gold,
        onPrimary: AppColors.background,
        // Material 3 pickers/dialogs read these container + tertiary roles;
        // left unset they fall back to the default purple/pink palette.
        primaryContainer: AppColors.goldDark,
        onPrimaryContainer: AppColors.foreground,
        secondary: AppColors.goldLight,
        onSecondary: AppColors.background,
        secondaryContainer: AppColors.surfaceAlt,
        onSecondaryContainer: AppColors.foreground,
        tertiary: AppColors.goldLight,
        onTertiary: AppColors.background,
        tertiaryContainer: AppColors.goldDark,
        onTertiaryContainer: AppColors.foreground,
        onSurface: AppColors.foreground,
        onSurfaceVariant: AppColors.foregroundMuted,
        surfaceContainerHighest: AppColors.surfaceAlt,
        surfaceContainerHigh: AppColors.surface,
        outline: AppColors.border,
        error: AppColors.danger,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.surface,
        hourMinuteColor: AppColors.surfaceAlt,
        hourMinuteTextColor: AppColors.foreground,
        dayPeriodColor: AppColors.goldDark,
        dayPeriodTextColor: AppColors.foreground,
        dialBackgroundColor: AppColors.surfaceAlt,
        dialHandColor: AppColors.gold,
        dialTextColor: AppColors.foreground,
        entryModeIconColor: AppColors.gold,
        helpTextStyle: GoogleFonts.figtree(color: AppColors.foregroundMuted),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.surface,
        headerBackgroundColor: AppColors.surfaceAlt,
        headerForegroundColor: AppColors.foreground,
        // Selected day: solid accent circle with contrasting text (the
        // number used to vanish — accent text on an accent circle).
        dayForegroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.background
              : s.contains(WidgetState.disabled)
                  ? AppColors.foregroundMuted.withValues(alpha: 0.35)
                  : AppColors.foreground,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.gold : null,
        ),
        todayForegroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.background : AppColors.gold,
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.gold : null,
        ),
        todayBorder: BorderSide(color: AppColors.gold),
      ),
      textTheme: _textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.foreground,
      ),
      dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1),
      iconTheme: IconThemeData(color: AppColors.foregroundMuted),
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
          side: BorderSide(color: AppColors.border),
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
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppColors.gold, width: 1.5),
        ),
        hintStyle: GoogleFonts.figtree(color: AppColors.foregroundMuted.withValues(alpha: 0.6)),
        labelStyle: GoogleFonts.figtree(color: AppColors.foregroundMuted),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
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
          side: BorderSide(color: AppColors.border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceAlt,
        selectedColor: AppColors.gold,
        labelStyle: TextStyle(color: AppColors.foreground),
        secondaryLabelStyle: TextStyle(color: AppColors.background),
        side: BorderSide(color: AppColors.border),
        checkmarkColor: AppColors.background,
      ),
      splashFactory: NoSplash.splashFactory,
    );
  }
}
