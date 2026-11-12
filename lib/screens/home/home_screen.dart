import 'package:flutter/material.dart';

import '../../data/menu_item.dart';
import '../../services/menu_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dish_image.dart';
import '../../widgets/section_eyebrow.dart';
import '../dish_detail/dish_detail_screen.dart';

/// Home tab — first screen users see after splash.
class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  const HomeScreen({super.key, required this.onNavigateToTab});

  String get _greeting {
    // Same hours as the website hero (resources/js/lib/timeOfDay.js), so
    // 1–5 AM says "Good Night", not "Good Morning".
    final hour = DateTime.now().hour;
    if (hour < 5) return 'Good Night';
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _Hero(greeting: _greeting, onNavigateToTab: onNavigateToTab),
          ),
          const SliverToBoxAdapter(child: _CraveTeaserStrip()),
          SliverToBoxAdapter(child: _FeaturedMenuSection(onNavigateToTab: onNavigateToTab)),
          const SliverToBoxAdapter(child: _AboutTeaser()),
          SliverToBoxAdapter(child: _ReservationCta(onNavigateToTab: onNavigateToTab)),
          // Room for the floating cart button at the end of the page.
          const SliverToBoxAdapter(child: SizedBox(height: 96)),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final String greeting;
  final ValueChanged<int> onNavigateToTab;
  const _Hero({required this.greeting, required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.6;
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hero-bg.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xCC0C0B09),
                  AppColors.background,
                ],
                stops: [0.3, 0.75, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SectionEyebrow(greeting),
                const SizedBox(height: 10),
                Text(
                  'Crunches Cafe',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.foreground,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Faisalabad\'s favorite fast food hangout. Crispy. Loaded. Gone in minutes.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.foregroundMuted,
                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => onNavigateToTab(2),
                        child: const Text('Reserve a Table'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => onNavigateToTab(1),
                        child: const Text('View Menu'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CraveTeaserStrip extends StatelessWidget {
  const _CraveTeaserStrip();

  static const _items = [
    ('fire-from-wok.jpg', 'Sizzling'),
    ('chef-preparing-the-plates.jpg', 'Fresh Off the Grill'),
    ('cake.jpg', 'Molten'),
    ('lobster-roll.jpg', 'Loaded'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SectionEyebrow('Still deciding?'),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Hungry yet?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.foreground,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // Extra right padding so the last card can scroll clear of the
              // floating cart button.
              padding: const EdgeInsets.fromLTRB(24, 0, 88, 0),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final (image, caption) = _items[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: _CraveCard(image: image, caption: caption),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CraveCard extends StatelessWidget {
  final String image;
  final String caption;
  const _CraveCard({required this.image, required this.caption});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/$image', fit: BoxFit.cover),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE60C0B09)],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Text(
                caption,
                style: TextStyle(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedMenuSection extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  const _FeaturedMenuSection({required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MenuService.instance,
      builder: (context, _) => _build(context, MenuService.instance.items.take(6).toList()),
    );
  }

  Widget _build(BuildContext context, List<MenuItem> featured) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionEyebrow('Crafted to Order'),
          const SizedBox(height: 4),
          Text(
            'Our Favorites',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.foreground,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 72),
              itemCount: featured.length,
              itemBuilder: (context, index) {
                final item = featured[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: _FeaturedMenuCard(key: ValueKey(item.id), item: item),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => onNavigateToTab(1),
              child: const Text('View Full Menu'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedMenuCard extends StatelessWidget {
  final MenuItem item;
  const _FeaturedMenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Card(
        clipBehavior: Clip.antiAlias,
        // Tapping a favourite opens its dish page (it used to do nothing).
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DishDetailScreen(item: item)),
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: DishImage(item.image),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.foreground,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.price,
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _AboutTeaser extends StatelessWidget {
  const _AboutTeaser();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionEyebrow('Our Story'),
                const SizedBox(height: 8),
                Text(
                  'Built on Late Nights & Loaded Plates',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.foreground,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Crunches Cafe started with a simple idea — fast food that actually hits. '
                  'Every plate is loaded, every bite is fresh off the grill.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.foregroundMuted,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 0.85,
                child: Image.asset('assets/images/about.jpg', fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationCta extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;
  const _ReservationCta({required this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionEyebrow('Reserved for the Hungry'),
            const SizedBox(height: 8),
            Text(
              'Save Your Seat',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.foreground,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'A table worth craving — book ahead and skip the wait.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.foregroundMuted,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onNavigateToTab(2),
                child: const Text('Reserve a Table'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
