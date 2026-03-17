import 'package:flutter/material.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../shared/widgets/app_label_value_row.dart';
import '../../../data/models/order_model.dart';

/// Карточка статуса заказа
class OrderStatusCard extends StatelessWidget {
  final OrderModel order;
  final String Function(DateTime) formatDate;

  const OrderStatusCard({
    super.key,
    required this.order,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    final (statusLabel, statusColor) = switch (order.status) {
      OrderStatus.pending => (tr.orderStatusPending, AppColors.warning),
      OrderStatus.processing => (tr.orderStatusProcessing, AppColors.info),
      OrderStatus.shipped => (tr.orderStatusShipped, AppColors.accent),
      OrderStatus.delivered => (tr.orderStatusDelivered, AppColors.success),
      OrderStatus.cancelled => (tr.orderStatusCancelled, AppColors.error),
    };

    final statusDescription = switch (order.status) {
      OrderStatus.pending => tr.orderStatusPendingDesc,
      OrderStatus.processing => tr.orderStatusProcessingDesc,
      OrderStatus.shipped => tr.orderStatusShippedDesc,
      OrderStatus.delivered => tr.orderStatusDeliveredDesc,
      OrderStatus.cancelled => tr.orderStatusCancelledDesc,
    };

    final statusIcon = switch (order.status) {
      OrderStatus.pending => Icons.schedule_rounded,
      OrderStatus.processing => Icons.inventory_2_outlined,
      OrderStatus.shipped => Icons.local_shipping_outlined,
      OrderStatus.delivered => Icons.check_circle_outline_rounded,
      OrderStatus.cancelled => Icons.cancel_outlined,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(statusIcon, color: statusColor, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusLabel,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statusDescription,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: scheme.outline),
          const SizedBox(height: AppSpacing.md),
          AppLabelValueRow(label: tr.orderNumber, value: order.orderNumber),
          const SizedBox(height: AppSpacing.sm),
          AppLabelValueRow(label: tr.date, value: formatDate(order.date)),
          const SizedBox(height: AppSpacing.sm),
          AppLabelValueRow(label: tr.items, value: '${order.itemCount}'),
        ],
      ),
    );
  }
}
