class MenuItem {
  final String name;
  final String category;
  final String description;
  final String price;
  final String image;
  final List<String> tags;

  const MenuItem({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.image,
    required this.tags,
  });
}
