class MenuItem {
  /// Matches the id of the same dish in the Laravel backend's `menu_items`
  /// table, so an order references a real row the API can price and total
  /// server-side.
  final int id;
  final String name;
  final String category;
  final String description;
  final String price;

  /// Either a bundled asset file name (e.g. "lobster-roll.jpg", used by the
  /// offline fallback menu) or a server image URL/path from the API.
  final String image;
  final List<String> tags;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.image,
    required this.tags,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        id: (json['id'] as num).toInt(),
        name: (json['name'] ?? '').toString(),
        category: (json['category'] ?? '').toString(),
        description: (json['description'] ?? '').toString(),
        price: (json['price'] ?? '').toString(),
        image: (json['image'] ?? '').toString(),
        tags: (json['tags'] is List) ? (json['tags'] as List).map((t) => t.toString()).toList() : const [],
      );

  bool get isRemoteImage => image.startsWith('http') || image.startsWith('/');
}
