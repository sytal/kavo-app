import '../models/order.dart';
import 'api_client.dart';

class OrderService {
  OrderService._();
  static final OrderService instance = OrderService._();

  /// Places an order for the signed-in user. [items] is
  /// `{menu_item_id: quantity}` — pricing is computed server-side from the
  /// real menu_items table, never trusted from the client.
  Future<String?> placeOrder({
    required String deliveryAddress,
    required String phone,
    String? notes,
    required Map<int, int> items,
  }) async {
    final res = await ApiClient.instance.post(
      '/orders',
      {
        'delivery_address': deliveryAddress,
        'phone': phone,
        'notes': notes,
        'items': items.entries
            .map((e) => {'menu_item_id': e.key, 'quantity': e.value})
            .toList(),
      },
      auth: true,
    );

    return res.ok ? null : res.errorMessage;
  }

  Future<({List<CafeOrder> orders, String? error})> myOrders() async {
    final res = await ApiClient.instance.get('/orders', auth: true);
    if (!res.ok) return (orders: <CafeOrder>[], error: res.errorMessage);

    final list = (res.data['data'] as List? ?? [])
        .map((e) => CafeOrder.fromJson(e as Map<String, dynamic>))
        .toList();
    return (orders: list, error: null);
  }
}
