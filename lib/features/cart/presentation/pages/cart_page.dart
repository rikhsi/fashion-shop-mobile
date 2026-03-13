import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.cart,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: scheme.outlineVariant,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              tr.cart,
              style: AppTextStyles.titleMedium.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
