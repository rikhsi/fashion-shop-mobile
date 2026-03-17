import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/animations/app_page_route.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../../cart/data/cart_service.dart';
import '../../../favorites/data/favorites_service.dart';
import '../../../home/data/models/card_model.dart';
import '../../data/mocks/mock_product_detail.dart';
import '../../data/models/product_detail_model.dart';
import '../../../custom_order/presentation/pages/custom_order_page.dart';
import '../../../tryon/presentation/pages/tryon_page.dart';
import 'all_reviews_page.dart';
import 'fullscreen_gallery_page.dart';

class ProductDetailPage extends StatefulWidget {
  final CardModel card;

  const ProductDetailPage({super.key, required this.card});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _favorites = sl<FavoritesService>();
  final _cart = sl<CartService>();
  late PageController _pageController;

  late final ProductDetailModel _detail;
  int _currentImage = 0;
  final Map<String, String> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _detail = MockProductDetail.fromCard(widget.card);
    for (final group in _detail.optionGroups) {
      final firstInStock = group.options.where((o) => o.inStock).firstOrNull;
      if (firstInStock != null) {
        _selectedOptions[group.name] = firstInStock.id;
      }
    }
    _favorites.addListener(_rebuild);
  }

  @override
  void dispose() {
    _favorites.removeListener(_rebuild);
    _pageController.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  /// Returns the gallery filtered by selected option images.
  /// If any selected option has its own images, use those;
  /// otherwise fall back to the full product gallery.
  List<String> get _activeGallery {
    for (final group in _detail.optionGroups) {
      final selectedId = _selectedOptions[group.name];
      if (selectedId == null) continue;
      final option = group.options.where((o) => o.id == selectedId).firstOrNull;
      if (option?.images != null && option!.images!.isNotEmpty) {
        return option.images!;
      }
    }
    return _detail.gallery;
  }

  void _onOptionSelected(String groupName, String optionId) {
    final prev = _selectedOptions[groupName];
    if (prev == optionId) return;
    _selectedOptions[groupName] = optionId;
    _resetGalleryPosition();
    setState(() {});
  }

  void _resetGalleryPosition() {
    _currentImage = 0;
    _pageController.dispose();
    _pageController = PageController();
  }

  double get _currentPrice {
    double price = _detail.basePrice;
    for (final group in _detail.optionGroups) {
      final selectedId = _selectedOptions[group.name];
      if (selectedId == null) continue;
      final option = group.options.where((o) => o.id == selectedId).firstOrNull;
      if (option != null) price += option.priceModifier;
    }
    return price;
  }

  void _addToCart() {
    _cart.addItem(widget.card);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.tr.addedToCart),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _share() {
    final price = formatPrice(_currentPrice);
    final currency = context.tr.currency;
    final text = '${_detail.title} — ${_detail.brand}\n'
        '$price $currency\n\n'
        'https://fashionshop.uz/product/${_detail.id}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;
    final isFav = _favorites.isFavorite(_detail.id);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildGallery(scheme, isFav)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.base),
                      _buildBrandAndTitle(scheme),
                      const SizedBox(height: AppSpacing.sm),
                      _buildRatingRow(scheme, tr),
                      const SizedBox(height: AppSpacing.base),
                      _buildPriceSection(scheme, tr),
                      const SizedBox(height: AppSpacing.xl),
                      _buildDivider(scheme),
                      const SizedBox(height: AppSpacing.base),
                      ..._buildOptionGroups(scheme),
                      _buildCustomOrderBanner(scheme),
                      _buildDivider(scheme),
                      const SizedBox(height: AppSpacing.base),
                      _buildDescription(scheme, tr),
                      const SizedBox(height: AppSpacing.xl),
                      _buildSpecs(scheme, tr),
                      const SizedBox(height: AppSpacing.xl),
                      _buildDivider(scheme),
                      const SizedBox(height: AppSpacing.base),
                      _buildReviewsSection(scheme, tr),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomBar(scheme, tr, isFav),
          _buildBackButton(scheme),
        ],
      ),
    );
  }

  void _openFullscreen(int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, _, _) => FullscreenGalleryPage(
          images: _activeGallery,
          initialIndex: index,
        ),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  // ── Gallery ──

  Widget _buildGallery(ColorScheme scheme, bool isFav) {
    final gallery = _activeGallery;
    const double mainImageHeight = 380;
    const double thumbHeight = 72;
    const double thumbWidth = 56;

    return SizedBox(
      height: mainImageHeight + thumbHeight + AppSpacing.sm + AppSpacing.md,
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () => _openFullscreen(_currentImage),
                child: SizedBox(
                  height: mainImageHeight,
                  width: double.infinity,
                  child: PageView.builder(
                    key: ValueKey(gallery.hashCode),
                    controller: _pageController,
                    itemCount: gallery.length,
                    onPageChanged: (i) => setState(() => _currentImage = i),
                    itemBuilder: (_, i) => Image.network(
                      gallery[i],
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: scheme.surfaceContainerHighest,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (_, _, _) => Container(
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (gallery.length > 1)
                SizedBox(
                  height: thumbHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                    ),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: gallery.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (_, i) {
                        final isActive = i == _currentImage;
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              i,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: thumbWidth,
                            height: thumbHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm,
                              ),
                              border: Border.all(
                                color: isActive
                                    ? scheme.primary
                                    : scheme.outline,
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusSm - 1,
                              ),
                              child: Image.network(
                                gallery[i],
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: scheme.surfaceContainerHighest,
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 16,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          Positioned(
            top: AppSpacing.base,
            right: AppSpacing.base,
            child: _CircleButton(
              icon: Icons.share_outlined,
              onTap: _share,
              scheme: scheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(ColorScheme scheme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppSpacing.sm,
      left: AppSpacing.base,
      child: _CircleButton(
        icon: Icons.arrow_back_rounded,
        onTap: () => Navigator.pop(context),
        scheme: scheme,
      ),
    );
  }

  // ── Brand & Title ──

  Widget _buildBrandAndTitle(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _detail.brand,
          style: AppTextStyles.bodySmall.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _detail.title,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ],
    );
  }

  // ── Rating ──

  Widget _buildRatingRow(ColorScheme scheme, AppLocalizations tr) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final starValue = i + 1;
          if (_detail.rating >= starValue) {
            return const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC107));
          } else if (_detail.rating >= starValue - 0.5) {
            return const Icon(Icons.star_half_rounded, size: 18, color: Color(0xFFFFC107));
          }
          return Icon(Icons.star_border_rounded, size: 18, color: scheme.onSurfaceVariant.withValues(alpha: 0.4));
        }),
        const SizedBox(width: AppSpacing.sm),
        Text(
          _detail.rating.toStringAsFixed(1),
          style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '(${_detail.reviewCount} ${tr.get('reviews')})',
          style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
        ),
        const Spacer(),
        Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.warning),
        const SizedBox(width: 3),
        Text(
          '${_detail.soldCount} ${tr.get('sold')}',
          style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }

  // ── Price ──

  Widget _buildPriceSection(ColorScheme scheme, AppLocalizations tr) {
    final price = _currentPrice;
    final hasDiscount = _detail.originalPrice != null && _detail.originalPrice! > price;
    final discountPercent = hasDiscount
        ? ((1 - price / _detail.originalPrice!) * 100).round()
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
          child: Text(
            '${formatPrice(price)} ${tr.currency}',
            key: ValueKey(price),
            style: AppTextStyles.displayMedium.copyWith(color: scheme.onSurface),
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${formatPrice(_detail.originalPrice!)} ${tr.currency}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.discount,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
            child: Text(
              '-$discountPercent%',
              style: AppTextStyles.badge.copyWith(color: Colors.white),
            ),
          ),
        ],
      ],
    );
  }

  // ── Option groups ──

  List<Widget> _buildOptionGroups(ColorScheme scheme) {
    return _detail.optionGroups.expand((group) {
      return [
        Text(group.name, style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface)),
        const SizedBox(height: AppSpacing.sm),
        if (group.type == 'color')
          _buildColorOptions(group, scheme)
        else
          _buildSizeOptions(group, scheme),
        const SizedBox(height: AppSpacing.lg),
      ];
    }).toList();
  }

  Widget _buildSizeOptions(ProductOptionGroup group, ColorScheme scheme) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: group.options.map((option) {
        final selected = _selectedOptions[group.name] == option.id;
        return GestureDetector(
          onTap: option.inStock
              ? () => _onOptionSelected(group.name, option.id)
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary.withValues(alpha: 0.1)
                  : scheme.surfaceContainerHighest,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outline,
                width: selected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Text(
              option.label,
              style: AppTextStyles.labelMedium.copyWith(
                color: !option.inStock
                    ? scheme.onSurfaceVariant.withValues(alpha: 0.4)
                    : selected
                        ? scheme.primary
                        : scheme.onSurface,
                decoration: option.inStock ? null : TextDecoration.lineThrough,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorOptions(ProductOptionGroup group, ColorScheme scheme) {
    return Row(
      children: group.options.map((option) {
        final selected = _selectedOptions[group.name] == option.id;
        final color = Color(option.colorValue ?? 0xFF000000);
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: GestureDetector(
            onTap: option.inStock
                ? () => _onOptionSelected(group.name, option.id)
                : null,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? scheme.primary : scheme.outline,
                      width: selected ? 2.5 : 1,
                    ),
                  ),
                  child: !option.inStock
                      ? CustomPaint(painter: _CrossPainter(scheme.onSurfaceVariant))
                      : selected
                          ? Icon(Icons.check_rounded, size: 18,
                              color: _isLightColor(color) ? Colors.black87 : Colors.white)
                          : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  option.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: !option.inStock
                        ? scheme.onSurfaceVariant.withValues(alpha: 0.4)
                        : scheme.onSurface,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  bool _isLightColor(Color c) =>
      (0.299 * c.r + 0.587 * c.g + 0.114 * c.b) > 0.6;

  // ── Description ──

  Widget _buildDescription(ColorScheme scheme, AppLocalizations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.get('description'), style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface)),
        const SizedBox(height: AppSpacing.sm),
        Text(_detail.description, style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant, height: 1.6)),
      ],
    );
  }

  // ── Specifications ──

  Widget _buildSpecs(ColorScheme scheme, AppLocalizations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.get('details'), style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface)),
        const SizedBox(height: AppSpacing.sm),
        ...ListTile.divideTiles(
          context: context,
          color: scheme.outline.withValues(alpha: 0.5),
          tiles: _detail.specs.map((spec) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(spec.label, style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
                ),
                Expanded(
                  child: Text(spec.value, style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          )),
        ),
      ],
    );
  }

  // ── Reviews section ──

  Widget _buildReviewsSection(ColorScheme scheme, AppLocalizations tr) {
    final reviews = _detail.reviews;
    final previewCount = reviews.length > 2 ? 2 : reviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${tr.get('reviews')} (${_detail.reviewCount})',
              style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
            ),
            const Spacer(),
            if (reviews.length > 2)
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  appSlideRoute(AllReviewsPage(
                    reviews: reviews,
                    averageRating: _detail.rating,
                    totalCount: _detail.reviewCount,
                  )),
                ),
                child: Text(tr.viewAll, style: AppTextStyles.labelMedium.copyWith(color: scheme.primary)),
              ),
          ],
        ),
        _buildRatingSummaryCompact(scheme),
        const SizedBox(height: AppSpacing.base),
        ...List.generate(previewCount, (i) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.base),
          child: _ReviewCard(review: reviews[i]),
        )),
      ],
    );
  }

  Widget _buildRatingSummaryCompact(ColorScheme scheme) {
    return Row(
      children: [
        Text(
          _detail.rating.toStringAsFixed(1),
          style: AppTextStyles.displayLarge.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (i) {
                final val = i + 1;
                if (_detail.rating >= val) return const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFC107));
                if (_detail.rating >= val - 0.5) return const Icon(Icons.star_half_rounded, size: 16, color: Color(0xFFFFC107));
                return Icon(Icons.star_border_rounded, size: 16, color: scheme.onSurfaceVariant.withValues(alpha: 0.4));
              }),
            ),
            const SizedBox(height: 2),
            Text(
              '${_detail.reviewCount} ${context.tr.get('reviews')}',
              style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }

  // ── Custom order banner ──

  Widget _buildCustomOrderBanner(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            appSlideRoute(
              CustomOrderPage(
                mode: CustomOrderMode.fromProduct,
                productTitle: _detail.title,
                productImageUrl: _activeGallery.first,
                productPrice: _currentPrice,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                scheme.primary.withValues(alpha: 0.08),
                scheme.primary.withValues(alpha: 0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(Icons.content_cut_rounded, color: scheme.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No size? Custom tailoring!',
                      style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'We\'ll sew this exactly to your measurements',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  // ── Bottom bar ──

  Widget _buildBottomBar(ColorScheme scheme, AppLocalizations tr, bool isFav) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: AppSpacing.base,
          right: AppSpacing.base,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(top: BorderSide(color: scheme.outline.withValues(alpha: 0.5))),
          boxShadow: [BoxShadow(color: scheme.shadow, blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: Row(
          children: [
            _AnimatedFavButton(
              isFavorite: isFav,
              onTap: () => _favorites.toggle(_detail.id),
            ),
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  appSlideRoute(
                    TryOnPage(
                      productTitle: _detail.title,
                      productImageUrl: _activeGallery.first,
                    ),
                  ),
                );
              },
              child: Container(
                height: AppSpacing.buttonHeight,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: scheme.primary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 18, color: scheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Try On',
                      style: AppTextStyles.labelMedium.copyWith(color: scheme.primary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SizedBox(
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  onPressed: _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                    elevation: 0,
                  ),
                  child: Text(
                    '${tr.addToCart}  ·  ${formatPrice(_currentPrice)} ${tr.currency}',
                    style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme scheme) {
    return Divider(color: scheme.outline.withValues(alpha: 0.5), height: 1);
  }
}

// ── Circle button ──

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _CircleButton({required this.icon, required this.onTap, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: scheme.shadow, blurRadius: 6)],
        ),
        child: Icon(icon, size: 20, color: scheme.onSurface),
      ),
    );
  }
}

// ── Animated favorite for bottom bar ──

class _AnimatedFavButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  const _AnimatedFavButton({required this.isFavorite, required this.onTap});

  @override
  State<_AnimatedFavButton> createState() => _AnimatedFavButtonState();
}

class _AnimatedFavButtonState extends State<_AnimatedFavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.85), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _AnimatedFavButton old) {
    super.didUpdateWidget(old);
    if (old.isFavorite != widget.isFavorite) _ctrl.forward(from: 0);
  }

  @override
  void dispose() {
    _ctrl.dispose();
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
          width: AppSpacing.buttonHeight,
          height: AppSpacing.buttonHeight,
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(widget.isFavorite),
              color: widget.isFavorite ? AppColors.error : scheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Review card ──

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final daysAgo = DateTime.now().difference(review.date).inDays;
    final timeText = daysAgo == 0
        ? 'Today'
        : daysAgo == 1
            ? 'Yesterday'
            : '$daysAgo days ago';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: scheme.primary.withValues(alpha: 0.15),
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0] : '?',
                  style: AppTextStyles.labelMedium.copyWith(color: scheme.primary),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  review.userName,
                  style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                ),
              ),
              Text(timeText, style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: List.generate(5, (i) => Icon(
              i < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
              size: 14,
              color: i < review.rating ? const Color(0xFFFFC107) : scheme.onSurfaceVariant.withValues(alpha: 0.3),
            )),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            review.comment,
            style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface, height: 1.5),
          ),
          if (review.images != null && review.images!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images!.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, _, _) => FullscreenGalleryPage(
                        images: review.images!,
                        initialIndex: i,
                      ),
                      transitionsBuilder: (_, animation, _, child) =>
                          FadeTransition(opacity: animation, child: child),
                      transitionDuration: const Duration(milliseconds: 250),
                      reverseTransitionDuration: const Duration(milliseconds: 200),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Image.network(
                      review.images![i],
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Cross painter for out-of-stock color circles ──

class _CrossPainter extends CustomPainter {
  final Color color;
  _CrossPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width * 0.25, size.height * 0.25),
        Offset(size.width * 0.75, size.height * 0.75), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
