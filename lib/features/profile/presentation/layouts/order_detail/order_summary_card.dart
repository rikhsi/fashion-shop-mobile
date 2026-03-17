import 'package:flutter/material.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/mappers/card_mapper.dart';
import '../../../data/models/order_model.dart';

/// Карточка итогов заказа
class OrderSummaryCard extends StatelessWidget {
  final OrderModel order;
  final String currency;

  const OrderSummaryCard({
    super.key,
    required this.order,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    final subtotal = order.items.fold<double>(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
    const shipping = 25000.0;
    final isCancelled = order.status == OrderStatus.cancelled;

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
            tr.orderSummary,
            style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: tr.subtotal,
            value: '${formatPrice(subtotal)} $currency',
            scheme: scheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: tr.shipping,
            value: order.total > 300000
                ? tr.freeDelivery
                : '${formatPrice(shipping)} $currency',
            scheme: scheme,
            valueColor: order.total > 300000 ? AppColors.success : null,
          ),
          if (isCancelled) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              label: tr.refund,
              value: '${formatPrice(order.total)} $currency',
              scheme: scheme,
              valueColor: AppColors.success,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: scheme.outline),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr.total,
                style: AppTextStyles.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              Text(
                '${formatPrice(order.total)} $currency',
                style: AppTextStyles.titleLarge.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.scheme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: valueColor ?? scheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
