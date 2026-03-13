import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/product_card.dart';
import 'section_header.dart';

class SpecialOffersSection extends StatelessWidget {
  const SpecialOffersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPadding,
          child: SectionHeader(title: tr.specialOffers, onViewAll: () {}),
        ),
        const SizedBox(height: AppSpacing.base),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.screenPadding,
            itemCount: MockProducts.specialOffers.length,
            separatorBuilder: (_, _) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, i) => ProductCard(
              product: MockProducts.specialOffers[i],
              width: 150,
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
