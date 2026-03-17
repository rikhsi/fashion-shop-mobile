import 'package:flutter/material.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/order_model.dart';
import '../../widgets/order_detail_item_row.dart';

/// Секция списка товаров заказа
class OrderItemsSection extends StatelessWidget {
  final List<OrderItemModel> items;
  final String currency;

  const OrderItemsSection({
    super.key,
    required this.items,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.items,
            style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(items.length, (i) {
            final item = items[i];
            return Column(
              children: [
                if (i > 0) ...[
                  Divider(height: 1, color: scheme.outline),
                  const SizedBox(height: AppSpacing.md),
                ],
                OrderDetailItemRow(item: item, currency: currency),
                if (i < items.length - 1) const SizedBox(height: AppSpacing.md),
              ],
            );
          }),
        ],
      ),
    );
  }
}
