import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/app_section_header.dart';
import '../../../../shared/widgets/product_card.dart';

class RecommendedSection extends StatelessWidget {
  final List<Product> products;

  const RecommendedSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(title: tr.recommendedForYou, onViewAll: () {}),
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
            itemCount: products.length,
            itemBuilder: (_, i) => ProductCard(
              product: products[i],
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
