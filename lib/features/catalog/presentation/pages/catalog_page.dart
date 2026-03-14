import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/app_section_header.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/skeleton_loading.dart';
import '../../data/api/catalog_api_service.dart';
import '../../data/models/catalog_category.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _api = sl<CatalogApiService>();

  bool _isLoading = true;
  List<CatalogCategory> _categories = [];
  List<Product> _recommended = [];
  List<Product> _allProducts = [];
  int _loadedCount = 0;
  static const _pageSize = 6;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final categoriesFuture = _api.getRootCategories();
    final recommendedFuture = _api.getRecommendedForCategory(null);
    final productsFuture = _api.getProductsByCategory(null);

    final categories = await categoriesFuture;
    final recommended = await recommendedFuture;
    final allProducts = await productsFuture;

    if (!mounted) return;
    setState(() {
      _categories = categories;
      _recommended = recommended;
      _allProducts = allProducts;
      _loadedCount = _pageSize.clamp(0, _allProducts.length);
      _isLoading = false;
    });
  }

  void _loadMore() {
    if (_loadedCount >= _allProducts.length) return;
    setState(() {
      _loadedCount = (_loadedCount + _pageSize).clamp(0, _allProducts.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.catalog,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
        centerTitle: false,
      ),
      body: _isLoading
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
                  SliverToBoxAdapter(
                    child: _CategoryGrid(
                      categories: _categories,
                      tr: tr,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xl),
                      child: AppSectionHeader(
                        title: tr.recommendedForYou,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.base,
                      AppSpacing.base,
                      AppSpacing.base,
                      AppSpacing.xl,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.base,
                        childAspectRatio: 0.58,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < _recommended.length) {
                            return ProductCard(
                              product: _recommended[index],
                              onTap: () {},
                            );
                          }
                          final productIndex =
                              index - _recommended.length;
                          if (productIndex < _loadedCount) {
                            return ProductCard(
                              product: _allProducts[productIndex],
                              onTap: () {},
                            );
                          }
                          return null;
                        },
                        childCount: _recommended.length + _loadedCount,
                      ),
                    ),
                  ),
                  if (_loadedCount < _allProducts.length)
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
    );
  }
}

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

class _CategoryGrid extends StatelessWidget {
  final List<CatalogCategory> categories;
  final AppLocalizations tr;

  const _CategoryGrid({
    required this.categories,
    required this.tr,
  });

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
              border: Border.all(
                color: scheme.outline.withValues(alpha: 0.3),
              ),
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
            style: AppTextStyles.labelMedium.copyWith(
              color: scheme.onSurface,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
