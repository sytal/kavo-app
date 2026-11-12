import 'package:flutter/foundation.dart';
import '../data/menu_data.dart' as fallback;
import '../data/menu_item.dart';
import 'api_client.dart';

/// Live menu from the backend (`GET /api/v1/menu-items`), so dishes, prices
/// and photos edited in the admin panel show up in the app too. Until the
/// first load finishes — or if the server can't be reached — the bundled
/// menu in `data/menu_data.dart` is shown, so the app never opens empty.
class MenuService extends ChangeNotifier {
  MenuService._();
  static final MenuService instance = MenuService._();

  List<MenuItem> _items = fallback.menuItems;
  List<String> _categories = fallback.menuCategories;
  bool _loading = false;
  bool _fromServer = false;

  List<MenuItem> get items => _items;
  List<String> get categories => _categories;
  bool get isLoading => _loading;
  bool get isLive => _fromServer;

  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    notifyListeners();

    final res = await ApiClient.instance.get('/menu-items');
    if (res.ok && res.data is Map && res.data['data'] is List) {
      final parsed = (res.data['data'] as List)
          .whereType<Map>()
          .where((json) => json['is_available'] != false)
          .map((json) => MenuItem.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      if (parsed.isNotEmpty) {
        _items = parsed;
        final order = <String>[];
        for (final item in parsed) {
          if (!order.contains(item.category)) order.add(item.category);
        }
        final cats = await ApiClient.instance.get('/menu-categories');
        if (cats.ok && cats.data is Map && cats.data['data'] is List) {
          final serverOrder = (cats.data['data'] as List).map((c) => c.toString()).where(order.contains).toList();
          _categories = [...serverOrder, ...order.where((c) => !serverOrder.contains(c))];
        } else {
          _categories = order;
        }
        _fromServer = true;
      }
    }

    _loading = false;
    notifyListeners();
  }
}
