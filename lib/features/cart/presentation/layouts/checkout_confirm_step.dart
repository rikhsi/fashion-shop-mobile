import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../../../shared/widgets/app_info_card.dart';
import '../../../profile/data/models/order_model.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/warehouse_model.dart';
import '../widgets/checkout_order_item_row.dart';

/// Шаг подтверждения заказа
class CheckoutConfirmStep extends StatelessWidget {
  final List<CartItem> items;
  final DeliveryType deliveryType;
  final String city;
  final String street;
  final String apartment;
  final String phone;
  final WarehouseModel? selectedWarehouse;
  final PaymentMethod paymentMethod;
  final double totalPrice;

  const CheckoutConfirmStep({
    super.key,
    required this.items,
    required this.deliveryType,
    required this.city,
    required this.street,
    required this.apartment,
    required this.phone,
    required this.selectedWarehouse,
    required this.paymentMethod,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    final deliveryValue = deliveryType == DeliveryType.delivery
        ? '$city, $street${apartment.isNotEmpty ? ", apt. $apartment" : ""}\n$phone'
        : selectedWarehouse != null
            ? '${selectedWarehouse!.name}\n${selectedWarehouse!.address}'
                '${selectedWarehouse!.workingHours != null ? '\n${selectedWarehouse!.workingHours}' : ''}'
            : '';

    final paymentLabel = paymentMethod.name.replaceFirst(
      paymentMethod.name[0],
      paymentMethod.name[0].toUpperCase(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.orderItems,
          style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.base),
        ...items.map(
          (item) => CheckoutOrderItemRow(
            item: item,
            currency: tr.currency,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppInfoCard(
          title: deliveryType == DeliveryType.delivery ? tr.deliveryTitle : tr.pickup,
          value: deliveryValue,
        ),
        const SizedBox(height: AppSpacing.base),
        AppInfoCard(title: tr.payment, value: paymentLabel),
        const SizedBox(height: AppSpacing.xl),
        Divider(color: scheme.outline),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr.orderTotal,
              style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
            ),
            Text(
              '${formatPrice(totalPrice)} ${tr.currency}',
              style: AppTextStyles.titleMedium.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
