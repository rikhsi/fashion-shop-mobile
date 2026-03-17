import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../data/models/cart_item.dart';

class CheckoutOrderItemRow extends StatelessWidget {
  final CartItem item;
  final String currency;

  const CheckoutOrderItemRow({
    super.key,
    required this.item,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: SizedBox(
              width: 56,
              height: 56,
              child: item.product.imageUrl != null
                  ? Image.network(
                      item.product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_outlined,
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  : Icon(Icons.image_outlined, color: scheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${item.quantity} × ${formatPrice(item.product.price)} $currency',
                  style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            '${formatPrice(item.total)} $currency',
            style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
          ),
        ],
      ),
    );
  }
}
