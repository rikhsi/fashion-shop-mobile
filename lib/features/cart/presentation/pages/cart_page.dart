import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_empty_state.dart';

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
      body: AppEmptyState(
        icon: Icons.shopping_bag_outlined,
        title: tr.emptyCart,
        description: tr.emptyCartDescription,
      ),
    );
  }
}
