import 'package:flutter/material.dart';
import '../../data/menu_data.dart';
import '../../data/menu_item.dart';
import '../../theme/app_colors.dart';
import '../../widgets/section_eyebrow.dart';
import '../dish_detail/dish_detail_screen.dart';

/// Browsable menu: search, category filter chips, and a grid of dish cards.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const String _allLabel = 'All';

  String _selectedCategory = _allLabel;
  String _query = '';
  bool _searching = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MenuItem> get _filteredItems {
    final query = _query.trim().toLowerCase();
    return menuItems.where((item) {
      final matchesCategory =
          _selectedCategory == _allLabel || item.category == _selectedCategory;
      final matchesQuery = query.isEmpty || item.name.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Our Menu'),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searching = !_searching;
                if (!_searching) {
                  _query = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_searching)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: (value) => setState(() => _query = value),
                  style: const TextStyle(color: AppColors.foreground),
                  decoration: const InputDecoration(
                    hintText: 'Search dishes...',
                    prefixIcon: Icon(Icons.search, color: AppColors.foregroundMuted),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SectionEyebrow('Crafted to Order'),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                children: [
                  _CategoryChip(
                    label: _allLabel,
                    selected: _selectedCategory == _allLabel,
                    onTap: () => setState(() => _selectedCategory = _allLabel),
                  ),
                  const SizedBox(width: 10),
                  for (final category in menuCategories) ...[
                    _CategoryChip(
                      label: category,
                      selected: _selectedCategory == category,
                      onTap: () => setState(() => _selectedCategory = category),
                    ),
                    const SizedBox(width: 10),
                  ],
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'No dishes match your search',
                        style: TextStyle(color: AppColors.foregroundMuted),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        // Matched to the card's actual content height (110px
                        // image + fixed-height name/price/tag regions) so
                        // there's no leftover empty space at the bottom.
                        childAspectRatio: 0.72,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _MenuCard(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DishDetailScreen(item: item),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.border,
          ),
        ),
        child: Text(
          label,
          softWrap: false,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
          style: TextStyle(
            color: selected ? AppColors.background : AppColors.foregroundMuted,
            fontWeight: FontWeight.w600,
            fontSize: 13,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const _MenuCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              width: double.infinity,
              child: Image.asset(
                'assets/images/${item.image}',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed 2-line height regardless of whether the name
                  // actually wraps, so price/tag sit at the same y-position
                  // on every card instead of shifting with name length.
                  SizedBox(
                    height: 36,
                    child: Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.foreground,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.price,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  // Reserve the tag row's height too (even when a dish has
                  // no tags) so every card is the same total height.
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 22,
                    child: item.tags.isEmpty
                        ? null
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceAlt,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                item.tags.first,
                                style: const TextStyle(
                                  color: AppColors.foregroundMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
