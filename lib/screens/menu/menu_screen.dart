import 'package:flutter/material.dart';
import '../../data/menu_item.dart';
import '../../services/menu_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dish_image.dart';
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

  /// While searching, look through the WHOLE menu (name, description and
  /// tags) regardless of the selected chip — searching "peri" from the
  /// Desserts chip should still find Peri Peri Fries.
  List<MenuItem> get _filteredItems {
    final query = _query.trim().toLowerCase();
    return MenuService.instance.items.where((item) {
      if (query.isNotEmpty) {
        return item.name.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query) ||
            item.tags.any((t) => t.toLowerCase().contains(query));
      }
      return _selectedCategory == _allLabel || item.category == _selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MenuService.instance,
      builder: (context, _) => _buildMenu(context),
    );
  }

  Widget _buildMenu(BuildContext context) {
    final items = _filteredItems;
    final categories = MenuService.instance.categories;
    if (_selectedCategory != _allLabel && !categories.contains(_selectedCategory)) {
      _selectedCategory = _allLabel;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Our Menu'),
        actions: [
          IconButton(
            tooltip: _searching ? 'Close search' : 'Search menu',
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
                  // Searching covers every category, so show "All" as selected.
                  onChanged: (value) => setState(() {
                    _query = value;
                    if (value.trim().isNotEmpty) _selectedCategory = _allLabel;
                  }),
                  style: TextStyle(color: AppColors.foreground),
                  decoration: InputDecoration(
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
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                children: [
                  _CategoryChip(
                    label: _allLabel,
                    selected: _selectedCategory == _allLabel,
                    onTap: () => setState(() => _selectedCategory = _allLabel),
                  ),
                  const SizedBox(width: 10),
                  for (final category in categories) ...[
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
              child: RefreshIndicator(
                color: AppColors.gold,
                onRefresh: MenuService.instance.load,
                child: items.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 120),
                        Center(
                          child: Text(
                            'No dishes match your search',
                            style: TextStyle(color: AppColors.foregroundMuted),
                          ),
                        ),
                      ],
                    )
                  : GridView.builder(
                      // Bottom padding keeps the last row clear of the
                      // floating cart button.
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        // 2 columns on phones, 3–5 on tablets; each card has
                        // a fixed height matched to its content (110px image
                        // + name/price/tag rows), so no tall empty cards.
                        maxCrossAxisExtent: 220,
                        mainAxisExtent: 224,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _MenuCard(
                          key: ValueKey(item.id),
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
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
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

  const _MenuCard({super.key, required this.item, required this.onTap});

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
              child: DishImage(item.image),
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
                      style: TextStyle(
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
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  // Reserve the tag row's height too (even when a dish has
                  // no tags) so every card is the same total height.
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 24,
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
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
