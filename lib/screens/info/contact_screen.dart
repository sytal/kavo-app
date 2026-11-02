import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Contact Us')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text("We'd love to hear from you", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Questions, feedback, or a catering request — reach us any of these ways.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const _ContactRow(
              icon: Icons.location_on_outlined,
              title: 'Visit Us',
              value: 'Gulberg Thana Road, Faisalabad',
            ),
            const _ContactRow(
              icon: Icons.access_time_rounded,
              title: 'Hours',
              value: 'Daily, 1pm – 1am',
            ),
            const _ContactRow(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: 'Call for reservations',
            ),
            const _ContactRow(
              icon: Icons.mail_outline,
              title: 'Email',
              value: 'hello@crunchescafe.com',
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ContactRow({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.foregroundMuted, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
