import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/order_model.dart';
import '../layouts/order_detail/order_delivery_card.dart';
import '../layouts/order_detail/order_items_section.dart';
import '../layouts/order_detail/order_payment_card.dart';
import '../layouts/order_detail/order_status_card.dart';
import '../layouts/order_detail/order_summary_card.dart';
import '../layouts/order_detail/order_tracking_card.dart';

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
    final tr = context.tr;

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
            OrderStatusCard(
              order: order,
              formatDate: (d) => _formatDate(d, tr),
            ),
            const SizedBox(height: AppSpacing.base),
            if (order.trackingNumber != null) ...[
              OrderTrackingCard(trackingNumber: order.trackingNumber!),
              const SizedBox(height: AppSpacing.base),
            ],
            OrderDeliveryCard(order: order),
            const SizedBox(height: AppSpacing.base),
            OrderPaymentCard(order: order),
            const SizedBox(height: AppSpacing.base),
            OrderItemsSection(items: order.items, currency: currency),
            const SizedBox(height: AppSpacing.base),
            OrderSummaryCard(order: order, currency: currency),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, AppLocalizations tr) {
    final months = [
      tr.get('monthJan'),
      tr.get('monthFeb'),
      tr.get('monthMar'),
      tr.get('monthApr'),
      tr.get('monthMay'),
      tr.get('monthJun'),
      tr.get('monthJul'),
      tr.get('monthAug'),
      tr.get('monthSep'),
      tr.get('monthOct'),
      tr.get('monthNov'),
      tr.get('monthDec'),
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
