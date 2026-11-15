import 'package:flutter/material.dart';

/// KAVO colour palette. Starts as the website's "Classic Gold"
/// dark theme and is replaced at launch by the theme chosen in
/// Admin > Appearance (see ThemeLoader), so the app follows the website.
class AppColors {
  AppColors._();

  static Color background = const Color(0xFF0C0B09);
  static Color surface = const Color(0xFF17140F);
  static Color surfaceAlt = const Color(0xFF1F1B15);
  static Color border = const Color(0xFF37332A);

  static Color foreground = const Color(0xFFF5F1E8);
  static Color foregroundMuted = const Color(0xFFB9B2A2);

  static Color gold = const Color(0xFFF4691F);
  static Color goldLight = const Color(0xFFFF9248);
  static Color goldDark = const Color(0xFFC44C13);

  static Color success = const Color(0xFF5FAE70);
  static Color danger = const Color(0xFFD6462F);

  static bool isLight = false;

  static Color? _parse(dynamic hex) {
    final h = hex?.toString().replaceFirst('#', '') ?? '';
    final v = int.tryParse(h, radix: 16);
    return (h.length == 6 && v != null) ? Color(0xFF000000 | v) : null;
  }

  /// Applies one palette map from GET /api/v1/theme ("dark" or "light").
  static void apply(Map palette, {required bool light}) {
    background = _parse(palette['background']) ?? background;
    surface = _parse(palette['surface']) ?? surface;
    surfaceAlt = _parse(palette['surfaceAlt']) ?? surfaceAlt;
    border = _parse(palette['border']) ?? border;
    foreground = _parse(palette['foreground']) ?? foreground;
    foregroundMuted = _parse(palette['foregroundMuted']) ?? foregroundMuted;
    gold = _parse(palette['gold']) ?? gold;
    goldLight = _parse(palette['goldLight']) ?? goldLight;
    goldDark = _parse(palette['goldDark']) ?? goldDark;
    success = _parse(palette['success']) ?? success;
    danger = _parse(palette['danger']) ?? danger;
    isLight = light;
  }
}
