import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('About KAVO')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Built on Late Nights & Loaded Plates', style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(
              "KAVO started on Gulberg Thana Road with one idea: Faisalabad "
              "deserved a late-night spot that didn't cut corners on flavor. No "
              "fuss, no pretense — just loaded fries, stacked burgers, and a "
              "kitchen that doesn't slow down after dark.",
              style: textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 16),
            Text(
              "Today it's the spot where the crew lands after a long day — neon "
              "signage out front, a menu built for sharing (or not), and a "
              "kitchen that's always running hot.",
              style: textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 16),
            Text(
              "From crispy loaded fries to our signature stacked burgers and that "
              "molten chocolate brownie everyone talks about, every item earns "
              "its spot on the menu the hard way: by actually being good.",
              style: textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                _StatTile(value: '4.2', label: 'Google Rating'),
                _StatTile(value: '38+', label: 'Happy Reviews'),
                _StatTile(value: '30+', label: 'Menu Items'),
                _StatTile(value: '7', label: 'Days Open Weekly'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(color: AppColors.gold, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.foregroundMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
