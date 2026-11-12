import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../theme/app_colors.dart';
import 'home/home_screen.dart';
import 'menu/menu_screen.dart';
import 'orders/cart_screen.dart';
import 'reservations/reservations_screen.dart';
import 'profile/profile_screen.dart';

/// Bottom-nav shell holding the four main tabs. Pure UI/navigation state —
/// no backend, no persistence.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  void _goToTab(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToTab: _goToTab),
      const MenuScreen(),
      const ReservationsScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      // Persistent tray/cart button, visible over every tab. Wrapped in a
      // `ListenableBuilder` on `CartService.instance` so the count badge
      // rebuilds the instant `addItem`/`updateQuantity`/`removeItem` call
      // `notifyListeners()` — no navigation or reload needed.
      // Only on Home and Menu, where dishes are picked. On Reserve/Profile it
      // sat on top of "Save My Table" and other controls.
      floatingActionButton: _index > 1 ? null : ListenableBuilder(
        listenable: CartService.instance,
        builder: (context, _) {
          final count = CartService.instance.totalCount;
          return Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            child: FloatingActionButton(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.background,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: AppColors.surface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_rounded), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Reserve'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
