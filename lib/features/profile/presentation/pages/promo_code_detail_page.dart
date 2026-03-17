import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../data/models/promo_code_model.dart';

class PromoCodeDetailPage extends StatelessWidget {
  final PromoCodeModel promo;
  final String currency;

  const PromoCodeDetailPage({
    super.key,
    required this.promo,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Promo Code',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.base,
          bottom: AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDiscountHeader(scheme),
            const SizedBox(height: AppSpacing.base),
            _buildCodeCard(context, scheme),
            const SizedBox(height: AppSpacing.base),
            _buildDetailsCard(scheme),
            if (promo.isUsed) ...[
              const SizedBox(height: AppSpacing.base),
              _buildUsedOnCard(scheme),
            ],
            const SizedBox(height: AppSpacing.xl),
            _buildActionButton(context, scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountHeader(ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: promo.isActive
              ? [scheme.primary, scheme.primary.withValues(alpha: 0.7)]
              : [scheme.onSurfaceVariant.withValues(alpha: 0.3), scheme.onSurfaceVariant.withValues(alpha: 0.15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          if (promo.discountPercent > 0) ...[
            Text(
              '-${promo.discountPercent}%',
              style: AppTextStyles.displayLarge.copyWith(
                color: Colors.white,
                fontSize: 48,
              ),
            ),
          ] else ...[
            const Icon(
              Icons.local_shipping_rounded,
              color: Colors.white,
              size: 48,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            promo.title,
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            promo.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
            textAlign: TextAlign.center,
          ),
          if (!promo.isActive) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                promo.isUsed ? 'Used' : 'Expired',
                style: AppTextStyles.labelMedium.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCodeCard(BuildContext context, ColorScheme scheme) {
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
            'Promo Code',
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: scheme.outline),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    promo.code,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: scheme.onSurface,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: promo.code));
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('Code "${promo.code}" copied'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Icon(
                    Icons.copy_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
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
      ),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.discount_rounded,
            label: 'Discount',
            value: promo.discountPercent > 0
                ? '${promo.discountPercent}%'
                : 'Free Shipping',
            scheme: scheme,
          ),
          Divider(height: AppSpacing.xl, color: scheme.outline),
          if (promo.minPurchase != null) ...[
            _DetailRow(
              icon: Icons.shopping_cart_outlined,
              label: 'Min. Purchase',
              value: '${formatPrice(promo.minPurchase!)} $currency',
              scheme: scheme,
            ),
            Divider(height: AppSpacing.xl, color: scheme.outline),
          ],
          _DetailRow(
            icon: Icons.calendar_today_rounded,
            label: 'Expires',
            value: _formatDate(promo.expiresAt),
            scheme: scheme,
            valueColor: promo.daysLeft <= 3 && promo.isActive
                ? AppColors.warning
                : null,
          ),
          if (promo.isActive) ...[
            Divider(height: AppSpacing.xl, color: scheme.outline),
            _DetailRow(
              icon: Icons.timer_outlined,
              label: 'Remaining',
              value: '${promo.daysLeft} days',
              scheme: scheme,
              valueColor:
                  promo.daysLeft <= 3 ? AppColors.warning : AppColors.success,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUsedOnCard(ColorScheme scheme) {
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
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Used on purchase',
                style: AppTextStyles.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: scheme.outline),
          const SizedBox(height: AppSpacing.md),
          if (promo.usedOnOrderNumber != null)
            _InfoLine(
              label: 'Order',
              value: promo.usedOnOrderNumber!,
              scheme: scheme,
            ),
          if (promo.usedAt != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoLine(
              label: 'Date',
              value: _formatDate(promo.usedAt!),
              scheme: scheme,
            ),
          ],
          if (promo.savedAmount != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _InfoLine(
              label: 'You saved',
              value: '${formatPrice(promo.savedAmount!)} $currency',
              scheme: scheme,
              valueColor: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ColorScheme scheme) {
    if (promo.isUsed) {
      return SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeight,
        child: OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.inventory_2_outlined),
          label: const Text('View Order'),
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.primary,
            side: BorderSide(color: scheme.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            textStyle: AppTextStyles.labelLarge,
          ),
        ),
      );
    }

    if (promo.isExpired) {
      return SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeight,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            elevation: 0,
          ),
          child: const Text('Expired'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Promo code will be applied at checkout'),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
        },
        icon: const Icon(Icons.check_rounded),
        label: const Text('Use This Code'),
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: 0,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme scheme;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.scheme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.md),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.titleSmall.copyWith(
            color: valueColor ?? scheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;
  final Color? valueColor;

  const _InfoLine({
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
          style: AppTextStyles.bodySmall.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor ?? scheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
