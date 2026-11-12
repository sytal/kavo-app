import 'package:flutter/material.dart';
import '../../services/business_service.dart';
import '../../utils/links.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../auth/login_screen.dart';
import '../info/about_screen.dart';
import '../info/coming_soon_screen.dart';
import '../info/contact_screen.dart';
import '../orders/order_history_screen.dart';

/// Profile tab — account header + settings-style rows, all wired to real
/// screens/backend now: Order History hits the live orders API, About/
/// Contact are real static-content screens, Favorites/Notifications are
/// honest "coming soon" placeholders (not silent no-ops), and Sign In/Out
/// drives the shared [AuthService].
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: AuthService.instance,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            children: [
              // Not const: both read AuthService.instance.currentUser
              // directly in build(), so a const instance would never
              // rebuild when ListenableBuilder fires (Flutter skips
              // build() on an unchanged const widget identity), leaving
              // the header/menu stuck showing the signed-out state even
              // after a real, successful login.
              _ProfileHeader(),
              const SizedBox(height: 28),
              const _VisitUsCard(),
              const SizedBox(height: 28),
              _SettingsList(),
              const SizedBox(height: 28),
              const _SocialRow(),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  Future<void> _handleSignIn(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = AuthService.instance.currentUser;

    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.gold,
          child: Icon(Icons.person, color: AppColors.background, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user != null ? user.name : 'Welcome!', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                user != null ? user.email : 'Sign in to place orders',
                style: textTheme.bodySmall?.copyWith(color: AppColors.foregroundMuted),
              ),
            ],
          ),
        ),
        if (user != null)
          OutlinedButton(
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
            onPressed: () => AuthService.instance.logout(),
            child: const Text('Sign Out'),
          )
        else
          OutlinedButton(
            onPressed: () => _handleSignIn(context),
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
          children: [
            const Text('Visit Us'),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.location_on_outlined, text: BusinessService.instance.address),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.access_time_rounded, text: BusinessService.instance.hoursLabel),
            if (BusinessService.instance.phone.isNotEmpty) ...[
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.phone_outlined, text: BusinessService.instance.phone),
            ],
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

  @override
  Widget build(BuildContext context) {
    final items = <_SettingsItem>[
      _SettingsItem(
        Icons.receipt_long_outlined,
        'Order History',
        onTap: () async {
          if (!AuthService.instance.isAuthenticated) {
            final signedIn = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
            if (signedIn != true || !context.mounted) return;
          }
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
          );
        },
      ),
      _SettingsItem(
        Icons.favorite_border,
        'Favorites',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ComingSoonScreen(title: 'Favorites', icon: Icons.favorite_border),
          ),
        ),
      ),
      _SettingsItem(
        Icons.notifications_none_rounded,
        'Notifications',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                const ComingSoonScreen(title: 'Notifications', icon: Icons.notifications_none_rounded),
          ),
        ),
      ),
      _SettingsItem(
        Icons.info_outline,
        'About Crunches Cafe',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AboutScreen()),
        ),
      ),
      _SettingsItem(
        Icons.mail_outline,
        'Contact Us',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ContactScreen()),
        ),
      ),
    ];

    return Card(
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            Column(
              children: [
                ListTile(
                  leading: Icon(items[i].icon, color: AppColors.gold),
                  title: Text(items[i].label),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.foregroundMuted,
                  ),
                  onTap: items[i].onTap,
                ),
                if (i != items.length - 1)
                  Divider(height: 1, color: AppColors.border),
              ],
            ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _SettingsItem(this.icon, this.label, {required this.onTap});
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    final b = BusinessService.instance;
    final links = [
      if (b.instagram.isNotEmpty) (Icons.camera_alt_outlined, 'Instagram', b.instagram),
      if (b.facebook.isNotEmpty) (Icons.facebook, 'Facebook', b.facebook),
      if (b.whatsappUrl.isNotEmpty) (Icons.chat_outlined, 'WhatsApp', b.whatsappUrl),
      if (b.phone.isNotEmpty) (Icons.phone_outlined, 'Call', 'tel:${b.phone}'),
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final (icon, label, url) in links)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: IconButton(
                  tooltip: label,
                  onPressed: () => openLink(context, url),
                  style: IconButton.styleFrom(backgroundColor: AppColors.surfaceAlt, minimumSize: const Size(44, 44)),
                  icon: Icon(icon, color: AppColors.gold, size: 20),
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
