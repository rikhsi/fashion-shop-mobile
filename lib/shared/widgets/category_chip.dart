import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class CategoryItem {
  final String label;
  final IconData icon;

  const CategoryItem({required this.label, required this.icon});
}

class CategoryChip extends StatelessWidget {
  final CategoryItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isSelected
                  ? scheme.primaryContainer
                  : scheme.outlineVariant,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: scheme.primary, width: 2)
                  : null,
            ),
            child: Icon(
              item.icon,
              size: AppSpacing.iconLg,
              color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
