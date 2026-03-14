import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../data/models/category_model.dart';

class CategoriesSection extends StatelessWidget {
  final List<CategoryModel> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const CategoriesSection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: Text(
            tr.categories,
            style: AppTextStyles.titleLarge.copyWith(
              color: scheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPadding,
            itemCount: categories.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.lg),
            itemBuilder: (_, i) => CategoryChip(
              item: CategoryItem(
                label: categories[i].title,
                icon: categories[i].iconData,
              ),
              isSelected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
          ),
        ),
      ],
    );
  }
}
