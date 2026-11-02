import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import '../../theme/app_colors.dart';
import 'checkout_screen.dart';

/// The tray/cart screen: lists everything added via "Add to Tray" with
/// quantity controls and a total, then hands off to [CheckoutScreen] to
/// collect delivery details and place the order. Rebuilds live from
/// [CartService] via `ListenableBuilder`, so quantity edits here reflect
/// instantly without any extra setState plumbing.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Your Tray')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: CartService.instance,
          builder: (context, _) {
            final lines = CartService.instance.lines;
            if (lines.isEmpty) {
              return Center(
                child: Text(
                  'Your tray is empty',
                  style: TextStyle(color: AppColors.foregroundMuted),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    itemCount: lines.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final line = lines[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    line.item.name,
                                    style: const TextStyle(
                                      color: AppColors.foreground,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    line.item.price,
                                    style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceAlt,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: AppColors.foreground, size: 18),
                                    onPressed: () => CartService.instance.updateQuantity(
                                      line.item.id,
                                      line.quantity - 1,
                                    ),
                                  ),
                                  Text(
                                    '${line.quantity}',
                                    style: const TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: AppColors.gold, size: 18),
                                    onPressed: () => CartService.instance.updateQuantity(
                                      line.item.id,
                                      line.quantity + 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                              onPressed: () => CartService.instance.removeItem(line.item.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.foreground),
                          ),
                          Text(
                            'Rs. ${CartService.instance.totalPrice.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CheckoutScreen.fromCart()),
                          );
                        },
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
