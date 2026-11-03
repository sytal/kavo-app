import 'package:flutter/foundation.dart';
import '../data/menu_item.dart';

/// A single line in the tray: a menu item plus how many of it the user
/// wants to order.
class CartLine {
  final MenuItem item;
  int quantity;

  CartLine({required this.item, required this.quantity});

  double get lineTotal => _parsePrice(item.price) * quantity;

  static double _parsePrice(String price) {
    // Prices are stored as display strings (e.g. "Rs. 450"). The "Rs."
    // prefix's own period must be dropped first — naively keeping every
    // '.' in the string turns "Rs. 650" into ".650" (parsed as 0.65).
    final withoutCurrency = price.replaceFirst(RegExp(r'^[A-Za-z\s]*\.?\s*'), '');
    final cleaned = withoutCurrency.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }
}

/// App-wide tray/cart state, in-memory only (cleared on app restart or after
/// an order is placed). Mirrors the `AuthService` pattern: a singleton
/// `ChangeNotifier` that widgets listen to via `AnimatedBuilder` /
/// `ListenableBuilder` on `CartService.instance`, so the tray badge and the
/// cart screen update the instant an item is added/changed — no navigation
/// or reload required.
class CartService extends ChangeNotifier {
  CartService._();
  static final CartService instance = CartService._();

  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);

  /// Sum of all line quantities — what the tray badge shows.
  int get totalCount => _lines.fold(0, (sum, line) => sum + line.quantity);

  /// Sum of all line totals — what the cart screen shows before checkout.
  double get totalPrice => _lines.fold(0.0, (sum, line) => sum + line.lineTotal);

  bool get isEmpty => _lines.isEmpty;

  /// Adds [item] to the tray. If it's already in there, bumps its quantity
  /// instead of creating a duplicate line.
  void addItem(MenuItem item, {int quantity = 1}) {
    final existingIndex = _lines.indexWhere((l) => l.item.id == item.id);
    if (existingIndex != -1) {
      _lines[existingIndex].quantity += quantity;
    } else {
      _lines.add(CartLine(item: item, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(int menuItemId, int quantity) {
    final index = _lines.indexWhere((l) => l.item.id == menuItemId);
    if (index == -1) return;
    if (quantity <= 0) {
      _lines.removeAt(index);
    } else {
      _lines[index].quantity = quantity;
    }
    notifyListeners();
  }

  void removeItem(int menuItemId) {
    _lines.removeWhere((l) => l.item.id == menuItemId);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }

  /// `{menu_item_id: quantity}`, ready to hand to
  /// `OrderService.instance.placeOrder`.
  Map<int, int> toOrderItems() => {
        for (final line in _lines) line.item.id: line.quantity,
      };
}
