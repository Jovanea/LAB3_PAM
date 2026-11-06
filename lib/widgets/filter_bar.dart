import 'package:flutter/material.dart';

import '../theme/app_style.dart';

/// Randul derulabil cu filtre: "Favorites" + categoriile din date.
class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.favoritesOnly,
    required this.onCategorySelected,
    required this.onFavoritesChanged,
  });

  final List<String> categories;
  final String selectedCategory;
  final bool favoritesOnly;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<bool> onFavoritesChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _FilterChip(
            label: 'Favorites',
            icon: favoritesOnly ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            selected: favoritesOnly,
            onTap: () => onFavoritesChanged(!favoritesOnly),
          ),
          for (final String c in categories)
            _FilterChip(
              label: c,
              selected: c == selectedCategory,
              onTap: () => onCategorySelected(c),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? Colors.white : AppColors.ink;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        avatar: icon == null ? null : Icon(icon, size: 16, color: fg),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.blue,
        backgroundColor: AppColors.trackGrey,
        side: BorderSide.none,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: fg,
        ),
      ),
    );
  }
}
