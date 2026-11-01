import 'package:flutter/material.dart';

/// Single source of truth for Crunches Cafe's color palette — mirrors
/// resources/js/config/colors.js in the website project so the app and
/// site stay visually consistent.
class AppColors {
  AppColors._();

  static const background = Color(0xFF0C0B09);
  static const surface = Color(0xFF17140F);
  static const surfaceAlt = Color(0xFF1F1B15);
  static const border = Color(0xFF37332A);

  static const foreground = Color(0xFFF5F1E8);
  static const foregroundMuted = Color(0xFFB9B2A2);

  static const gold = Color(0xFFF4691F);
  static const goldLight = Color(0xFFFF9248);
  static const goldDark = Color(0xFFC44C13);

  static const success = Color(0xFF5FAE70);
  static const danger = Color(0xFFD6462F);
}
