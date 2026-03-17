import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_selectable_card.dart';
import '../../../profile/data/models/order_model.dart';

/// Шаг выбора способа оплаты
class CheckoutPaymentStep extends StatelessWidget {
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodSelected;

  const CheckoutPaymentStep({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  static const _methods = [
    (PaymentMethod.click, 'paymentClick', Icons.credit_card_rounded),
    (PaymentMethod.payme, 'paymentPayme', Icons.phone_android_rounded),
    (PaymentMethod.uzumBank, 'paymentUzumBank', Icons.account_balance_wallet_rounded),
    (PaymentMethod.paynet, 'paymentPaynet', Icons.payment_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.choosePaymentMethod,
          style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.lg),
        ..._methods.map((m) {
          final isSelected = selectedMethod == m.$1;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppSelectableCard(
              isSelected: isSelected,
              title: tr.get(m.$2),
              icon: m.$3,
              onTap: () => onMethodSelected(m.$1),
            ),
          );
        }),
      ],
    );
  }
}
