import 'package:flutter/material.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../data/models/order_model.dart';

/// Карточка способа оплаты
class OrderPaymentCard extends StatelessWidget {
  final OrderModel order;

  const OrderPaymentCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    final (label, icon, color) = switch (order.paymentMethod) {
      PaymentMethod.click => (
        tr.get('paymentClick'),
        Icons.bolt_rounded,
        const Color(0xFF00BCD4),
      ),
      PaymentMethod.payme => (
        tr.get('paymentPayme'),
        Icons.account_balance_wallet_rounded,
        const Color(0xFF00C853),
      ),
      PaymentMethod.uzumBank => (
        tr.get('paymentUzumBank'),
        Icons.account_balance_rounded,
        const Color(0xFFFF6F00),
      ),
      PaymentMethod.paynet => (
        tr.get('paymentPaynet'),
        Icons.payment_rounded,
        const Color(0xFF2196F3),
      ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr.paymentMethod,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: Text(
              tr.paid,
              style: AppTextStyles.badge.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
