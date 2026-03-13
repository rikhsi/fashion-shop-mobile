import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/product_card.dart';
import 'section_header.dart';

class PopularProductsSection extends StatelessWidget {
  const PopularProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: SectionHeader(title: tr.popularProducts),
        ),
        const SizedBox(height: AppSpacing.base),
        Padding(
          padding: AppSpacing.screenPadding,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.base,
              childAspectRatio: 0.58,
            ),
            itemCount: MockProducts.popular.length,
            itemBuilder: (_, i) => ProductCard(
              product: MockProducts.popular[i],
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
