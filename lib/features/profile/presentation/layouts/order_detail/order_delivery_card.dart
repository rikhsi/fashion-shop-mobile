import 'package:flutter/material.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../cart/data/mocks/mock_warehouses.dart';
import '../../../data/models/order_model.dart';

/// Карточка доставки/самовывоза
class OrderDeliveryCard extends StatelessWidget {
  final OrderModel order;

  const OrderDeliveryCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    late String title;
    late String subtitle;
    late IconData icon;

    if (order.deliveryType == DeliveryType.delivery) {
      final addr = order.deliveryAddress;
      if (addr != null) {
        title = tr.deliveryTitle;
        subtitle = '${addr.fullAddress}\n${addr.phone}';
        icon = Icons.location_on_outlined;
      } else {
        title = tr.deliveryTitle;
        subtitle = tr.addressWillBeConfirmed;
        icon = Icons.location_on_outlined;
      }
    } else {
      if (order.warehouseId != null) {
        final wh = MockWarehouses.warehouses
            .where((w) => w.id == order.warehouseId)
            .firstOrNull;
        if (wh != null) {
          title = tr.pickup;
          subtitle =
              '${wh.name}\n${wh.address}${wh.workingHours != null ? '\n${wh.workingHours}' : ''}';
          icon = Icons.warehouse_rounded;
        } else {
          title = tr.pickup;
          subtitle = tr.warehouseSelected;
          icon = Icons.storefront_rounded;
        }
      } else {
        title = tr.pickup;
        subtitle = tr.pickupPointWillBeConfirmed;
        icon = Icons.storefront_rounded;
      }
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
