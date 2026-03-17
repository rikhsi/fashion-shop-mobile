import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../data/models/order_model.dart';

/// Строка товара в деталях заказа
class OrderDetailItemRow extends StatelessWidget {
  final OrderItemModel item;
  final String currency;

  const OrderDetailItemRow({
    super.key,
    required this.item,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: SizedBox(
            width: 56,
            height: 70,
            child: item.imageUrl != null
                ? Image.network(
                    item.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, error, stackTrace) => _buildPlaceholder(scheme),
                  )
                : _buildPlaceholder(scheme),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Qty: ${item.quantity}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '${formatPrice(item.price)} $currency',
          style: AppTextStyles.price.copyWith(color: scheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(ColorScheme scheme) {
    return Container(
      color: scheme.outlineVariant,
      child: Icon(
        Icons.image_outlined,
        size: 20,
        color: scheme.onSurfaceVariant,
      ),
    );
  }
}
