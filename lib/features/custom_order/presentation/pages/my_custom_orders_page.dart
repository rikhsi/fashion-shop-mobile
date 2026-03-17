import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/animations/app_page_route.dart';
import '../../data/mocks/mock_custom_orders.dart';
import '../../data/models/custom_order_model.dart';
import 'custom_order_detail_page.dart';
import 'custom_order_page.dart';

class MyCustomOrdersPage extends StatelessWidget {
  const MyCustomOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final orders = MockCustomOrders.orders;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Custom Orders',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: orders.isEmpty
          ? _buildEmpty(scheme)
          : ListView.separated(
              padding: AppSpacing.screenPadding.copyWith(
                top: AppSpacing.base,
                bottom: AppSpacing.xxl,
              ),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) => _OrderCard(
                order: orders[i],
                scheme: scheme,
                onTap: () => Navigator.push(
                  context,
                  appSlideRoute(CustomOrderDetailPage(order: orders[i])),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            appSlideRoute(const CustomOrderPage(mode: CustomOrderMode.ownDesign)),
          );
        },
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Design'),
      ),
    );
  }

  Widget _buildEmpty(ColorScheme scheme) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.content_cut_rounded,
              size: 80,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'No custom orders yet',
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Order custom-tailored clothing or submit your own design. '
              'Tap the button below or use "Custom Order" on any product page.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final CustomOrderModel order;
  final ColorScheme scheme;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: scheme.outline),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: _buildImage(),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.type == CustomOrderType.fromProduct
                              ? order.productTitle ?? 'Custom Product'
                              : 'Own Design',
                          style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StatusBadge(status: order.status, scheme: scheme),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    order.orderNumber,
                    style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${order.fabricChoice ?? ''} · ${order.colorChoice ?? ''}',
                        style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      Text(
                        '${_formatPrice(order.totalPrice)} UZS',
                        style: AppTextStyles.titleSmall.copyWith(color: scheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final url = order.type == CustomOrderType.fromProduct
        ? order.productImageUrl
        : order.designImages.isNotEmpty
            ? order.designImages.first
            : null;

    if (url != null) {
      return Image.network(
        url,
        width: 64,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      width: 64,
      height: 80,
      color: scheme.outline,
      child: Icon(Icons.content_cut_rounded, color: scheme.onSurfaceVariant),
    );
  }

  String _formatPrice(double v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _StatusBadge extends StatelessWidget {
  final CustomOrderStatus status;
  final ColorScheme scheme;

  const _StatusBadge({required this.status, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      CustomOrderStatus.pending => ('Pending', AppColors.warning),
      CustomOrderStatus.confirmed => ('Confirmed', AppColors.info),
      CustomOrderStatus.inProduction => ('In Production', AppColors.accent),
      CustomOrderStatus.shipping => ('Shipping', AppColors.info),
      CustomOrderStatus.delivered => ('Delivered', AppColors.success),
      CustomOrderStatus.cancelled => ('Cancelled', AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }
}
