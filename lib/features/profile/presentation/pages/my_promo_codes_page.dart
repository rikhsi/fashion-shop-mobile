import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/mocks/mock_profile_data.dart';
import '../../data/models/promo_code_model.dart';

class MyPromoCodesPage extends StatelessWidget {
  const MyPromoCodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.myPromoCodes,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: ListView.separated(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.sm,
          bottom: AppSpacing.xxl,
        ),
        itemCount: MockProfileData.promoCodes.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, i) => _PromoCodeTile(
          promo: MockProfileData.promoCodes[i],
          currency: tr.currency,
        ),
      ),
    );
  }
}

class _PromoCodeTile extends StatelessWidget {
  final PromoCodeModel promo;
  final String currency;

  const _PromoCodeTile({required this.promo, required this.currency});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isActive = promo.isActive;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.55,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: isActive
              ? Border.all(color: scheme.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (promo.discountPercent > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    ),
                    child: Text(
                      '-${promo.discountPercent}%',
                      style: AppTextStyles.badge.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                  )
                else
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
                      'FREE',
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    promo.title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                ),
                if (promo.isUsed)
                  Text(
                    'Used',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  )
                else if (promo.isExpired)
                  Text(
                    'Expired',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              promo.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: scheme.outline,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            promo.code,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: scheme.onSurface,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        if (isActive)
                          GestureDetector(
                            onTap: () => _copy(context, promo.code),
                            child: Icon(
                              Icons.content_copy_rounded,
                              size: 18,
                              color: scheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: scheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  isActive ? '${promo.daysLeft} days left' : _formatDate(promo.expiresAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: promo.daysLeft <= 3 && isActive
                        ? AppColors.warning
                        : scheme.onSurfaceVariant,
                  ),
                ),
                if (promo.minPurchase != null) ...[
                  const Spacer(),
                  Text(
                    'Min: ${_formatPrice(promo.minPurchase!)} $currency',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Code "$code" copied'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _formatDate(DateTime d) =>
      '${d.day}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  String _formatPrice(double v) {
    final s = v.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
