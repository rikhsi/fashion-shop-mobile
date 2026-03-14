import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/app_section_header.dart';
import '../../../../shared/widgets/product_card.dart';

class NewArrivalsSection extends StatelessWidget {
  final List<Product> products;

  const NewArrivalsSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: tr.newArrivals, onViewAll: () {}),
        const SizedBox(height: AppSpacing.base),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPadding,
            itemCount: products.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, i) => ProductCard(
              product: products[i],
              width: 150,
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
