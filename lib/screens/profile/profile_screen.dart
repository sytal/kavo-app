import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Profile tab — a mix of account placeholder, "visit us" info, and
/// settings-style rows. No auth/backend; everything here is visual.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        children: const [
          _ProfileHeader(),
          SizedBox(height: 28),
          _VisitUsCard(),
          SizedBox(height: 28),
          _SettingsList(),
          SizedBox(height: 28),
          _SocialRow(),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.gold,
          child: Icon(Icons.person, color: AppColors.background, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome!', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                'Sign in to save your favorites',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.foregroundMuted,
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: null,
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}

class _VisitUsCard extends StatelessWidget {
  const _VisitUsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Visit Us'),
            SizedBox(height: 12),
            _InfoRow(
              icon: Icons.location_on_outlined,
              text: 'Gulberg Thana Road, Faisalabad',
            ),
            SizedBox(height: 12),
            _InfoRow(
              icon: Icons.access_time_rounded,
              text: 'Daily, 1pm – 1am',
            ),
            SizedBox(height: 12),
            _InfoRow(
              icon: Icons.phone_outlined,
              text: 'Call for reservations',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _SettingsList extends StatelessWidget {
  const _SettingsList();

  static const _items = [
    (Icons.receipt_long_outlined, 'Order History'),
    (Icons.favorite_border, 'Favorites'),
    (Icons.notifications_none_rounded, 'Notifications'),
    (Icons.info_outline, 'About Crunches Cafe'),
    (Icons.mail_outline, 'Contact Us'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          for (int i = 0; i < _items.length; i++)
            Column(
              children: [
                ListTile(
                  leading: Icon(_items[i].$1, color: AppColors.gold),
                  title: Text(_items[i].$2),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.foregroundMuted,
                  ),
                  onTap: () {},
                ),
                if (i != _items.length - 1)
                  const Divider(height: 1, color: AppColors.border),
              ],
            ),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  static const _icons = [
    Icons.camera_alt_outlined,
    Icons.facebook,
    Icons.alternate_email,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final icon in _icons)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.surfaceAlt,
                  child: Icon(icon, color: AppColors.gold, size: 18),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Crunches Cafe · v1.0.0',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.foregroundMuted,
              ),
        ),
      ],
    );
  }
}
