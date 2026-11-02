class MenuItem {
  /// Matches the id of the same dish in the Laravel backend's `menu_items`
  /// table (both are seeded in the same name/category order), so an order
  /// placed from this mock list references a real row the API can price
  /// and total server-side.
  final int id;
  final String name;
  final String category;
  final String description;
  final String price;
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
}
