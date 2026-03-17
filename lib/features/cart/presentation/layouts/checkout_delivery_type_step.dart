import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_selectable_card.dart';
import '../../../profile/data/models/order_model.dart';

/// Шаг выбора способа получения заказа (доставка / самовывоз)
class CheckoutDeliveryTypeStep extends StatelessWidget {
  final DeliveryType selectedType;
  final ValueChanged<DeliveryType> onTypeSelected;

  const CheckoutDeliveryTypeStep({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.deliveryTypeStep,
          style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppSelectableCard(
          isSelected: selectedType == DeliveryType.delivery,
          title: tr.deliveryOption,
          subtitle: tr.deliveryOptionSubtitle,
          icon: Icons.delivery_dining_rounded,
          onTap: () => onTypeSelected(DeliveryType.delivery),
        ),
        const SizedBox(height: AppSpacing.md),
        AppSelectableCard(
          isSelected: selectedType == DeliveryType.pickup,
          title: tr.pickupOption,
          subtitle: tr.pickupOptionSubtitle,
          icon: Icons.storefront_rounded,
          onTap: () => onTypeSelected(DeliveryType.pickup),
        ),
      ],
    );
  }
}
