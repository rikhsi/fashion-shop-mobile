import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/animations/app_page_route.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/skeleton_loading.dart';
import '../../../cart/data/cart_service.dart';
import '../../../favorites/data/favorites_service.dart';
import '../../../home/data/models/card_model.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../data/api/catalog_api_service.dart';
import '../../data/models/catalog_category.dart';
import '../widgets/catalog_filter_bar.dart';
import '../widgets/catalog_filter_sheet.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _api = sl<CatalogApiService>();
  final _favorites = sl<FavoritesService>();
  final _cart = sl<CartService>();

  bool _isLoading = true;
  List<CatalogCategory> _categories = [];
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  int _loadedCount = 0;
  static const _pageSize = 6;

  // Filter state
  RangeValues _priceRange = const RangeValues(0, 15000000);
  double _maxPrice = 15000000;
  String _sortBy = 'default';
  bool _onlyDiscounts = false;
  bool _onlyNew = false;
  CatalogViewMode _viewMode = CatalogViewMode.grid;

  @override
  void initState() {
    super.initState();
    _loadData();
    _favorites.addListener(_rebuild);
  }

  @override
  void dispose() {
    _favorites.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() async {
    final categoriesFuture = _api.getRootCategories();
    final productsFuture = _api.getProductsByCategory(null);

    final categories = await categoriesFuture;
    final allProducts = await productsFuture;

    if (!mounted) return;

    final prices = allProducts.map((p) => p.price);
    _maxPrice = prices.isEmpty ? 15000000 : prices.reduce(max);
    _priceRange = RangeValues(0, _maxPrice);

    setState(() {
      _categories = categories;
      _allProducts = allProducts;
      _filteredProducts = allProducts;
      _loadedCount = _pageSize.clamp(0, allProducts.length);
      _isLoading = false;
    });
  }

  void _applyFilters() {
    var result = _allProducts.where((p) {
      if (p.price < _priceRange.start || p.price > _priceRange.end) return false;
      if (_onlyDiscounts && p.originalPrice == null) return false;
      if (_onlyNew && !p.isNew) return false;
      return true;
    }).toList();

    switch (_sortBy) {
      case 'popular':
        result.shuffle();
      case 'newest':
        result = result.reversed.toList();
      case 'price_asc':
        result.sort((a, b) => a.price.compareTo(b.price));
      case 'price_desc':
        result.sort((a, b) => b.price.compareTo(a.price));
      case 'discount':
        result.sort((a, b) => (b.discountPercent ?? 0).compareTo(a.discountPercent ?? 0));
    }

    setState(() {
      _filteredProducts = result;
      _loadedCount = _pageSize.clamp(0, result.length);
    });
  }

  int get _activeFilterCount {
    int c = 0;
    if (_sortBy != 'default') c++;
    if (_onlyDiscounts) c++;
    if (_onlyNew) c++;
    if (_priceRange.start > 0 || _priceRange.end < _maxPrice) c++;
    return c;
  }

  void _showFilterSheet() async {
    final result = await showModalBottomSheet<CatalogFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CatalogFilterSheet(
        priceRange: _priceRange,
        maxPrice: _maxPrice,
        sortBy: _sortBy,
        onlyDiscounts: _onlyDiscounts,
        onlyNew: _onlyNew,
      ),
    );
    if (result != null) {
      _priceRange = result.priceRange;
      _sortBy = result.sortBy;
      _onlyDiscounts = result.onlyDiscounts;
      _onlyNew = result.onlyNew;
      _applyFilters();
    }
  }

  String get _sortLabel {
    final tr = context.tr;
    return switch (_sortBy) {
      'popular' => tr.get('sortPopular'),
      'newest' => tr.sortNewest,
      'price_asc' => tr.sortPriceAsc,
      'price_desc' => tr.sortPriceDesc,
      'discount' => tr.get('sortDiscount'),
      _ => tr.get('sortDefault'),
    };
  }

  void _loadMore() {
    if (_loadedCount >= _filteredProducts.length) return;
    setState(() {
      _loadedCount = (_loadedCount + _pageSize).clamp(0, _filteredProducts.length);
    });
  }

  void _onProductTap(Product product) {
    final card = _productToCard(product);
    Navigator.push(context, appSlideRoute(ProductDetailPage(card: card)));
  }

  void _onFavoriteTap(String id) => _favorites.toggle(id);

  void _onAddToCart(Product product) {
    _cart.addItem(_productToCard(product));
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

  CardModel _productToCard(Product p) => CardModel(
        id: p.id,
        title: p.name,
        imageUrl: p.imageUrl,
        price: p.price,
        originalPrice: p.originalPrice,
        categoryId: p.category,
        isNew: p.isNew,
      );

  void _openSearch() {
    Navigator.push(context, appSlideRoute(const SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const _CatalogSkeleton()
            : NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.extentAfter < 200) {
                    _loadMore();
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      backgroundColor: scheme.surface,
                      toolbarHeight: 60,
                      automaticallyImplyLeading: false,
                      title: Row(
                        children: [
                          Expanded(
                            child: AppSearchBar(
                              hintText: tr.searchHint,
                              onTap: _openSearch,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          AppIconButton(icon: Icons.tune_rounded, onTap: _openSearch),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _CategoryGrid(categories: _categories, tr: tr),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: CatalogFilterBar(
                        sortLabel: _sortLabel,
                        activeFilterCount: _activeFilterCount,
                        viewMode: _viewMode,
                        onFilterTap: _showFilterSheet,
                        onViewModeChanged: (m) => setState(() => _viewMode = m),
                      ),
                    ),
                  ),
                  if (_filteredProducts.isEmpty && !_isLoading)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxxl),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.filter_list_off_rounded, size: 48, color: scheme.onSurfaceVariant.withValues(alpha: 0.4)),
                              const SizedBox(height: AppSpacing.base),
                              Text(tr.noResults, style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface)),
                              const SizedBox(height: AppSpacing.xs),
                              Text(tr.noResultsDescription, style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (_viewMode == CatalogViewMode.grid)
                    _buildGridProducts()
                  else
                    _buildListProducts(),
                  if (_loadedCount < _filteredProducts.length)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.xxl),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildGridProducts() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base, AppSpacing.base, AppSpacing.base, AppSpacing.xl,
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.base,
          childAspectRatio: 0.58,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _loadedCount) return null;
            final product = _filteredProducts[index];
            return ProductCard(
              product: product.copyWith(isFavorite: _favorites.isFavorite(product.id)),
              onTap: () => _onProductTap(product),
              onFavoriteTap: () => _onFavoriteTap(product.id),
              onAddToCart: () => _onAddToCart(product),
            );
          },
          childCount: _loadedCount,
        ),
      ),
    );
  }

  Widget _buildListProducts() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base, AppSpacing.sm, AppSpacing.base, AppSpacing.xl,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= _loadedCount) return null;
            final product = _filteredProducts[index];
            final isFav = _favorites.isFavorite(product.id);
            return _ProductListTile(
              product: product.copyWith(isFavorite: isFav),
              onTap: () => _onProductTap(product),
              onFavoriteTap: () => _onFavoriteTap(product.id),
              onAddToCart: () => _onAddToCart(product),
            );
          },
          childCount: _loadedCount,
        ),
      ),
    );
  }
}

// ── Skeleton ──

class _CatalogSkeleton extends StatelessWidget {
  const _CatalogSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.base),
          SkeletonCategoryGrid(),
          SizedBox(height: AppSpacing.xl),
          SkeletonProductGrid(),
        ],
      ),
    );
  }
}

// ── Category grid ──

class _CategoryGrid extends StatelessWidget {
  final List<CatalogCategory> categories;
  final AppLocalizations tr;

  const _CategoryGrid({required this.categories, required this.tr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.base,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _CategoryCard(
            category: cat,
            label: tr.get(cat.nameKey),
            onTap: () => context.push('/catalog/${cat.id}'),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CatalogCategory category;
  final String label;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
              border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
            ),
            child: Icon(
              category.icon,
              size: AppSpacing.iconLg,
              color: scheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(color: scheme.onSurface),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── List view tile ──

class _ProductListTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddToCart;

  const _ProductListTile({
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: SizedBox(
                width: 100,
                height: 120,
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _placeholder(scheme),
                      )
                    : _placeholder(scheme),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${product.formattedPrice} ${tr.currency}',
                    style: AppTextStyles.price.copyWith(color: scheme.onSurface),
                  ),
                  if (product.formattedOriginalPrice != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${product.formattedOriginalPrice} ${tr.currency}',
                          style: AppTextStyles.priceOld.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.discount,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: AppTextStyles.badge.copyWith(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 22,
                          color: product.isFavorite ? AppColors.error : scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.base),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add_shopping_cart_rounded, size: 14, color: Colors.white),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                tr.addToCart,
                                style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme scheme) {
    return Container(
      color: product.placeholderColor,
      child: Center(
        child: Icon(product.icon, size: 28, color: Colors.white.withValues(alpha: 0.6)),
      ),
    );
  }
}
