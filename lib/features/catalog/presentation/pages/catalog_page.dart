import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/product_card.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;
    final all = [
      ...MockProducts.popular,
      ...MockProducts.newArrivals,
      ...MockProducts.recommended,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.catalog,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
        centerTitle: false,
      ),
      body: GridView.builder(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.base,
          bottom: AppSpacing.xxl,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.base,
          childAspectRatio: 0.58,
        ),
        itemCount: all.length,
        itemBuilder: (_, i) => ProductCard(
          product: all[i],
          onTap: () {},
        ),
      ),
    );
  }
}
