class OrderLineItem {
  final int id;
  final int? menuItemId;
  final String name;
  final double price;
  final int quantity;

  OrderLineItem({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderLineItem.fromJson(Map<String, dynamic> json) => OrderLineItem(
        id: json['id'] as int,
        menuItemId: json['menu_item_id'] as int?,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'] as int,
      );
}

class CafeOrder {
  final int id;
  final String status;
  final String deliveryAddress;
  final String phone;
  final String? notes;
  final double total;
  final double deliveryFee;
  final DateTime? createdAt;
  final List<OrderLineItem> items;

  CafeOrder({
    required this.id,
    required this.status,
    required this.deliveryAddress,
    required this.phone,
    required this.notes,
    required this.total,
    this.deliveryFee = 0,
    required this.createdAt,
    required this.items,
  });

  factory CafeOrder.fromJson(Map<String, dynamic> json) => CafeOrder(
        id: json['id'] as int,
        status: json['status'] as String,
        deliveryAddress: json['delivery_address'] as String,
        phone: json['phone'] as String,
        notes: json['notes'] as String?,
        total: (json['total'] as num).toDouble(),
        deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0,
        createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
        items: ((json['items'] as List?) ?? [])
            .map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
