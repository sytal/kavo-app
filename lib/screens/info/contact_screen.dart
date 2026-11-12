import 'package:flutter/material.dart';
import '../../services/business_service.dart';
import '../../utils/links.dart';
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
            ListenableBuilder(
              listenable: BusinessService.instance,
              builder: (context, _) {
                final b = BusinessService.instance;
                return Column(children: [
                  _ContactRow(icon: Icons.location_on_outlined, title: 'Visit Us', value: b.address),
                  _ContactRow(icon: Icons.access_time_rounded, title: 'Hours', value: b.hoursLabel),
                  if (b.phone.isNotEmpty)
                    _ContactRow(icon: Icons.phone_outlined, title: 'Phone', value: b.phone, onTap: () => openLink(context, 'tel:${b.phone}')),
                  if (b.whatsappUrl.isNotEmpty)
                    _ContactRow(icon: Icons.chat_outlined, title: 'WhatsApp', value: 'Message us', onTap: () => openLink(context, b.whatsappUrl)),
                  if (b.email.isNotEmpty)
                    _ContactRow(icon: Icons.mail_outline, title: 'Email', value: b.email, onTap: () => openLink(context, 'mailto:${b.email}')),
                  if (b.instagram.isNotEmpty)
                    _ContactRow(icon: Icons.camera_alt_outlined, title: 'Instagram', value: 'Follow us', onTap: () => openLink(context, b.instagram)),
                  if (b.facebook.isNotEmpty)
                    _ContactRow(icon: Icons.facebook, title: 'Facebook', value: 'Like our page', onTap: () => openLink(context, b.facebook)),
                ]);
              },
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

  final VoidCallback? onTap;

  const _ContactRow({required this.icon, required this.title, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                Text(title, style: TextStyle(color: AppColors.foregroundMuted, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (onTap != null) Icon(Icons.chevron_right, color: AppColors.foregroundMuted),
        ],
      ),
    ),
    );
  }
}
