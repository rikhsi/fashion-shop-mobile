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
  final VoidCallback? onAddToCart;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onAddToCart,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(scheme, tr),
            const SizedBox(height: AppSpacing.sm),
            _buildName(scheme),
            const SizedBox(height: AppSpacing.xs),
            _buildPrice(scheme, tr.currency),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme scheme, AppLocalizations tr) {
    return AspectRatio(
      aspectRatio: 1 / AppSpacing.productCardImageRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImageContent(scheme),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _AnimatedFavoriteButton(
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
            if (product.isNew && product.discountPercent == null)
              Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: _NewBadge(label: tr.newBadge),
              ),
            if (onAddToCart != null)
              Positioned(
                bottom: AppSpacing.sm,
                right: AppSpacing.sm,
                child: _AnimatedAddToCartButton(onTap: onAddToCart!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent(ColorScheme scheme) {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return Image.network(
        product.imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(color: product.placeholderColor);
        },
        errorBuilder: (_, _, _) => _colorPlaceholder(),
      );
    }
    return _colorPlaceholder();
  }

  Widget _colorPlaceholder() {
    return Container(
      color: product.placeholderColor,
      child: Center(
        child: Icon(
          product.icon,
          size: AppSpacing.xxxl,
          color: Colors.white.withValues(alpha: 0.6),
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

// ── Animated favorite button with heart-pop effect ──

class _AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const _AnimatedFavoriteButton({required this.isFavorite, this.onTap});

  @override
  State<_AnimatedFavoriteButton> createState() =>
      _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<_AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _AnimatedFavoriteButton old) {
    super.didUpdateWidget(old);
    if (old.isFavorite != widget.isFavorite) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: scheme.surface.withValues(alpha: 0.9),
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Icon(
              widget.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              key: ValueKey(widget.isFavorite),
              size: 18,
              color: widget.isFavorite
                  ? AppColors.error
                  : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated add-to-cart button with press scale ──

class _AnimatedAddToCartButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AnimatedAddToCartButton({required this.onTap});

  @override
  State<_AnimatedAddToCartButton> createState() =>
      _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<_AnimatedAddToCartButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.75), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.75, end: 1.12), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: scheme.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add_shopping_cart_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ── Badges ──

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
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        '-$percent%',
        style: AppTextStyles.badge.copyWith(color: Colors.white),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  final String label;
  const _NewBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        label,
        style: AppTextStyles.badge.copyWith(color: Colors.white),
      ),
    );
  }
}
