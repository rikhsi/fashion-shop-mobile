import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../data/models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;
  final String currency;

  const OrderDetailPage({
    super.key,
    required this.order,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          order.orderNumber,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(scheme),
            const SizedBox(height: AppSpacing.base),
            if (order.trackingNumber != null) ...[
              _buildTrackingCard(context, scheme),
              const SizedBox(height: AppSpacing.base),
            ],
            _buildPaymentCard(scheme),
            const SizedBox(height: AppSpacing.base),
            _buildItemsSection(scheme),
            const SizedBox(height: AppSpacing.base),
            _buildSummaryCard(scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ColorScheme scheme) {
    final (statusLabel, statusColor) = switch (order.status) {
      OrderStatus.pending => ('Pending', AppColors.warning),
      OrderStatus.processing => ('Processing', AppColors.info),
      OrderStatus.shipped => ('Shipped', AppColors.accent),
      OrderStatus.delivered => ('Delivered', AppColors.success),
      OrderStatus.cancelled => ('Cancelled', AppColors.error),
    };

    final statusDescription = switch (order.status) {
      OrderStatus.pending => 'Your order is awaiting confirmation.',
      OrderStatus.processing => 'Your order is being prepared.',
      OrderStatus.shipped => 'Your order is on its way!',
      OrderStatus.delivered => 'Your order has been delivered.',
      OrderStatus.cancelled => 'This order was cancelled.',
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
          _InfoRow(
            label: 'Order number',
            value: order.orderNumber,
            scheme: scheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: 'Date',
            value: _formatDate(order.date),
            scheme: scheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(label: 'Items', value: '${order.itemCount}', scheme: scheme),
        ],
      ),
    );
  }

  Widget _buildTrackingCard(BuildContext context, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: scheme.primary, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tracking Number',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  order.trackingNumber!,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: order.trackingNumber!));
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Tracking number copied'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(Icons.copy_rounded, color: scheme.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(ColorScheme scheme) {
    final (label, icon, color) = switch (order.paymentMethod) {
      PaymentMethod.click => (
        'Click',
        Icons.bolt_rounded,
        const Color(0xFF00BCD4),
      ),
      PaymentMethod.payme => (
        'Payme',
        Icons.account_balance_wallet_rounded,
        const Color(0xFF00C853),
      ),
      PaymentMethod.uzumBank => (
        'Uzum Bank',
        Icons.account_balance_rounded,
        const Color(0xFFFF6F00),
      ),
      PaymentMethod.paynet => (
        'Paynet',
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
                  'Payment Method',
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
              'Paid',
              style: AppTextStyles.badge.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(ColorScheme scheme) {
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
            'Items',
            style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          ...List.generate(order.items.length, (i) {
            final item = order.items[i];
            return Column(
              children: [
                if (i > 0) ...[
                  Divider(height: 1, color: scheme.outline),
                  const SizedBox(height: AppSpacing.md),
                ],
                _OrderItemRow(item: item, currency: currency, scheme: scheme),
                if (i < order.items.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ColorScheme scheme) {
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
            'Order Summary',
            style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.md),
          _SummaryRow(
            label: 'Subtotal',
            value: '${formatPrice(subtotal)} $currency',
            scheme: scheme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: 'Shipping',
            value: order.total > 300000
                ? 'Free'
                : '${formatPrice(shipping)} $currency',
            scheme: scheme,
            valueColor: order.total > 300000 ? AppColors.success : null,
          ),
          if (isCancelled) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              label: 'Refund',
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
                'Total',
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

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItemModel item;
  final String currency;
  final ColorScheme scheme;

  const _OrderItemRow({
    required this.item,
    required this.currency,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
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
                    errorBuilder: (_, _, _) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
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

  Widget _imagePlaceholder() {
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
