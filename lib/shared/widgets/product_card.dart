import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cur = context.tr.currency;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(scheme),
            const SizedBox(height: AppSpacing.sm),
            _buildName(scheme),
            const SizedBox(height: AppSpacing.xs),
            _buildPrice(scheme, cur),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme scheme) {
    return AspectRatio(
      aspectRatio: 1 / AppSpacing.productCardImageRatio,
      child: Container(
        decoration: BoxDecoration(
          color: product.placeholderColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                product.icon,
                size: 48,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _FavoriteButton(
                isFavorite: product.isFavorite,
                onTap: onFavoriteTap,
              ),
            ),
            if (product.discountPercent != null)
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: _DiscountBadge(percent: product.discountPercent!),
              ),
            if (product.isNew)
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: _NewBadge(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildName(ColorScheme scheme) {
    return Text(
      product.name,
      style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPrice(ColorScheme scheme, String cur) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${product.formattedPrice} $cur',
          style: AppTextStyles.price.copyWith(color: scheme.onSurface),
        ),
        if (product.formattedOriginalPrice != null)
          Text(
            '${product.formattedOriginalPrice} $cur',
            style: AppTextStyles.priceOld.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const _FavoriteButton({required this.isFavorite, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: 18,
          color: isFavorite ? AppColors.error : Colors.grey,
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final int percent;
  const _DiscountBadge({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.discount,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        '-$percent%',
        style: AppTextStyles.badge.copyWith(color: Colors.white),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        'NEW',
        style: AppTextStyles.badge.copyWith(color: Colors.white),
      ),
    );
  }
}
