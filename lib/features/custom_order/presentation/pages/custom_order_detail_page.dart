import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/animations/app_page_route.dart';
import '../../../product/presentation/pages/fullscreen_gallery_page.dart';
import '../../data/models/custom_order_model.dart';

class CustomOrderDetailPage extends StatelessWidget {
  final CustomOrderModel order;

  const CustomOrderDetailPage({super.key, required this.order});

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
      body: ListView(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.base,
          bottom: AppSpacing.xxl,
        ),
        children: [
          _buildStatusCard(scheme),
          const SizedBox(height: AppSpacing.base),
          if (order.type == CustomOrderType.fromProduct)
            _buildProductCard(scheme),
          if (order.type == CustomOrderType.ownDesign)
            _buildDesignCard(scheme, context),
          const SizedBox(height: AppSpacing.base),
          _buildMeasurementsCard(scheme),
          const SizedBox(height: AppSpacing.base),
          _buildDetailsCard(scheme),
          const SizedBox(height: AppSpacing.base),
          _buildPriceCard(scheme),
          if (order.estimatedDelivery != null) ...[
            const SizedBox(height: AppSpacing.base),
            _buildDeliveryCard(scheme),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard(ColorScheme scheme) {
    final (label, color, icon) = switch (order.status) {
      CustomOrderStatus.pending => ('Pending Review', AppColors.warning, Icons.hourglass_top_rounded),
      CustomOrderStatus.confirmed => ('Confirmed', AppColors.info, Icons.thumb_up_alt_rounded),
      CustomOrderStatus.inProduction => ('In Production', AppColors.accent, Icons.precision_manufacturing_rounded),
      CustomOrderStatus.shipping => ('Shipping', AppColors.info, Icons.local_shipping_outlined),
      CustomOrderStatus.delivered => ('Delivered', AppColors.success, Icons.check_circle_outline_rounded),
      CustomOrderStatus.cancelled => ('Cancelled', AppColors.error, Icons.cancel_outlined),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.titleSmall.copyWith(color: color)),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Ordered ${_formatDate(order.createdAt)}',
                  style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              order.type == CustomOrderType.fromProduct ? 'Custom Fit' : 'Own Design',
              style: AppTextStyles.labelSmall.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          if (order.productImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Image.network(
                order.productImageUrl!,
                width: 72,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 72, height: 90,
                  color: scheme.outline,
                  child: Icon(Icons.checkroom_rounded, color: scheme.onSurfaceVariant),
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Based On',
                  style: AppTextStyles.labelSmall.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  order.productTitle ?? 'Product',
                  style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                ),
                if (order.productPrice != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Base price: ${_formatPrice(order.productPrice!)} UZS',
                    style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignCard(ColorScheme scheme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.design_services_outlined, size: 18, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Your Design', style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface)),
            ],
          ),
          if (order.designImages.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: order.designImages.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    appSlideRoute(FullscreenGalleryPage(
                      images: order.designImages,
                      initialIndex: i,
                    )),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Image.network(
                      order.designImages[i],
                      width: 90,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (order.designDescription != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              order.designDescription!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMeasurementsCard(ColorScheme scheme) {
    final m = order.measurements;
    final rows = <(String, String)>[
      if (m.height != null) ('Height', '${m.height} cm'),
      if (m.weight != null) ('Weight', '${m.weight} kg'),
      if (m.chest != null) ('Chest', '${m.chest} cm'),
      if (m.waist != null) ('Waist', '${m.waist} cm'),
      if (m.hips != null) ('Hips', '${m.hips} cm'),
      if (m.shoulderWidth != null) ('Shoulders', '${m.shoulderWidth} cm'),
      if (m.armLength != null) ('Arm Length', '${m.armLength} cm'),
      if (m.legLength != null) ('Leg Length', '${m.legLength} cm'),
      if (m.neckCirc != null) ('Neck', '${m.neckCirc} cm'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.straighten_rounded, size: 18, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Measurements', style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.$1, style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
                    Text(
                      r.$2,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette_outlined, size: 18, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text('Tailoring Details', style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (order.fabricChoice != null)
            _DetailRow(label: 'Fabric', value: order.fabricChoice!, scheme: scheme),
          if (order.colorChoice != null)
            _DetailRow(label: 'Color', value: order.colorChoice!, scheme: scheme),
        ],
      ),
    );
  }

  Widget _buildPriceCard(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Price', style: AppTextStyles.titleSmall.copyWith(color: scheme.onPrimaryContainer)),
          Text(
            '${_formatPrice(order.totalPrice)} UZS',
            style: AppTextStyles.titleLarge.copyWith(color: scheme.onPrimaryContainer),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          Icon(Icons.event_outlined, size: 22, color: scheme.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Delivery',
                  style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatDate(order.estimatedDelivery!),
                  style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
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

  String _formatDate(DateTime d) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;

  const _DetailRow({required this.label, required this.value, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
