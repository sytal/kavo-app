import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/menu_item.dart';
import '../utils/format.dart';

/// A single line in the tray: a menu item plus how many of it the user
/// wants to order.
class CartLine {
  final MenuItem item;
  int quantity;

  CartLine({required this.item, required this.quantity});

  // Prices are display strings ("Rs. 1,250"); parsePrice handles the
  // "Rs." prefix and thousands separators.
  double get lineTotal => parsePrice(item.price) * quantity;
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

  static const _storeKey = 'cart_v1';

  /// Restores the tray saved on this phone, so closing the app doesn't
  /// empty it (same as the website's saved cart).
  Future<void> load() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_storeKey);
      if (raw == null) return;
      _lines
        ..clear()
        ..addAll((jsonDecode(raw) as List).map((j) => CartLine(
              item: MenuItem.fromJson(Map<String, dynamic>.from(j['item'] as Map)),
              quantity: (j['quantity'] as num).toInt(),
            )));
      super.notifyListeners();
    } catch (_) {}
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    final data = jsonEncode([
      for (final l in _lines)
        {
          'quantity': l.quantity,
          'item': {
            'id': l.item.id, 'name': l.item.name, 'category': l.item.category,
            'description': l.item.description, 'price': l.item.price,
            'image': l.item.image, 'tags': l.item.tags,
          },
        },
    ]);
    SharedPreferences.getInstance().then((p) => p.setString(_storeKey, data));
  }

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
