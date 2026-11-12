import 'package:flutter/material.dart';
import '../../data/menu_item.dart';
import '../../services/cart_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dish_image.dart';
import '../orders/checkout_screen.dart';

/// Full detail view for a single dish — big hero image, name, price, tags,
/// description, a quantity stepper and a pinned "Add to Order" button.
class DishDetailScreen extends StatefulWidget {
  final MenuItem item;
  const DishDetailScreen({super.key, required this.item});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  int quantity = 1;

  void _incr() => setState(() => quantity++);
  void _decr() => setState(() => quantity = quantity > 1 ? quantity - 1 : 1);

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: 320,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              DishImage(item.image),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                height: 100,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.background.withValues(alpha: 0),
                                        AppColors.background,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: SafeArea(
                            bottom: false,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withValues(alpha: 0.4),
                              child: IconButton(
                                tooltip: 'Back',
                                icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: AppColors.foreground,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                item.price,
                                style: textTheme.headlineSmall?.copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (item.tags.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: item.tags
                                  .map(
                                    (tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceAlt,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                          color: AppColors.foregroundMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          const SizedBox(height: 16),
                          Text(
                            item.description,
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.foregroundMuted,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Text(
                                'Quantity',
                                style: textTheme.titleMedium?.copyWith(
                                  color: AppColors.foreground,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, color: AppColors.foreground),
                                      onPressed: _decr,
                                    ),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        color: AppColors.foreground,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, color: AppColors.gold),
                                      onPressed: _incr,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        CartService.instance.addItem(item, quantity: quantity);
                        // Floating and lifted above the action bar, so it never
                        // covers the "Add to Tray" / "Order Now" buttons.
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('Added $quantity × ${item.name} to tray'),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 84),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                      },
                      child: const Text('Add to Tray'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen.singleItem(item: item, quantity: quantity),
                          ),
                        );
                      },
                      child: const Text('Order Now'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
