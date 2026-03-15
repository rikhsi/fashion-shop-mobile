import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../data/mocks/mock_profile_data.dart';
import '../../data/models/order_model.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.myOrders,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: ListView.separated(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxl,
        ),
        itemCount: MockProfileData.orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, i) => _OrderTile(
          order: MockProfileData.orders[i],
          currency: tr.currency,
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderModel order;
  final String currency;

  const _OrderTile({required this.order, required this.currency});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: AppTextStyles.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              _StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _formatDate(order.date),
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (order.items.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 56,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: order.items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: SizedBox(
                    width: 44,
                    height: 56,
                    child: _buildItemImage(order.items[i], scheme),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: scheme.outline),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.itemCount} item${order.itemCount > 1 ? 's' : ''}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${formatPrice(order.total)} $currency',
                style: AppTextStyles.price.copyWith(color: scheme.onSurface),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(OrderItemModel item, ColorScheme scheme) {
    if (item.imageUrl != null) {
      return Image.network(
        item.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: scheme.outlineVariant,
          child: Icon(Icons.image_outlined, size: 16, color: scheme.onSurfaceVariant),
        ),
      );
    }
    return Container(
      color: scheme.outlineVariant,
      child: Icon(Icons.image_outlined, size: 16, color: scheme.onSurfaceVariant),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      OrderStatus.pending => ('Pending', AppColors.warning),
      OrderStatus.processing => ('Processing', AppColors.info),
      OrderStatus.shipped => ('Shipped', AppColors.accent),
      OrderStatus.delivered => ('Delivered', AppColors.success),
      OrderStatus.cancelled => ('Cancelled', AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(color: color),
      ),
    );
  }
}
