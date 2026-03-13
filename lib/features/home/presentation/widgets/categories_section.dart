import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/category_chip.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final scheme = Theme.of(context).colorScheme;

    final items = [
      CategoryItem(label: tr.women, icon: Icons.woman_rounded),
      CategoryItem(label: tr.men, icon: Icons.man_rounded),
      CategoryItem(label: tr.shoes, icon: Icons.ice_skating_outlined),
      CategoryItem(label: tr.accessories, icon: Icons.watch_outlined),
      CategoryItem(
        label: tr.newCollection,
        icon: Icons.auto_awesome_outlined,
      ),
    ];

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
            itemCount: items.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.lg),
            itemBuilder: (_, i) =>
                CategoryChip(item: items[i], onTap: () {}),
          ),
        ),
      ],
    );
  }
}
