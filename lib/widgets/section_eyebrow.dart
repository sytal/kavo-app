import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Small uppercase gold label used above section headings, matching the
/// website's `font-mono text-xs uppercase tracking-[0.3em] text-brand-gold`.
class SectionEyebrow extends StatelessWidget {
  final String text;
  const SectionEyebrow(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.gold,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 3,
      ),
    );
  }
}
