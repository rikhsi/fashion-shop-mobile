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

class CategoryDetailPage extends StatefulWidget {
  final String categoryId;

  const CategoryDetailPage({super.key, required this.categoryId});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final _api = sl<CatalogApiService>();

  bool _isLoading = true;
  CatalogCategory? _category;
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
    final categoryFuture = _api.getCategoryById(widget.categoryId);
    final productsFuture = _api.getProductsByCategory(widget.categoryId);
    final recommendedFuture = _api.getRecommendedForCategory(widget.categoryId);

    final category = await categoryFuture;
    final products = await productsFuture;
    final recommended = await recommendedFuture;

    if (!mounted) return;
    setState(() {
      _category = category;
      _recommended = recommended;
      _allProducts = products;
      _loadedCount = _pageSize.clamp(0, products.length);
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
    final title = _category != null ? tr.get(_category!.nameKey) : tr.catalog;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: _isLoading
          ? const _DetailSkeleton()
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
                  if (_category != null && _category!.hasChildren)
                    SliverToBoxAdapter(
                      child: _SubcategoryList(
                        children: _category!.children,
                        tr: tr,
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: AppSectionHeader(title: tr.recommendedForYou),
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
                          final productIndex = index - _recommended.length;
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

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSpacing.base),
          SkeletonSubcategoryList(),
          SizedBox(height: AppSpacing.xl),
          SkeletonProductGrid(),
        ],
      ),
    );
  }
}

class _SubcategoryList extends StatelessWidget {
  final List<CatalogCategory> children;
  final AppLocalizations tr;

  const _SubcategoryList({required this.children, required this.tr});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          InkWell(
            onTap: () => context.push('/catalog/${children[i].id}'),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: children[i].color,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    child: Icon(
                      children[i].icon,
                      size: AppSpacing.iconSm,
                      color: scheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      tr.get(children[i].nameKey),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: AppSpacing.iconMd,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (i < children.length - 1)
            Divider(
              height: 0,
              indent: AppSpacing.base + 40 + AppSpacing.md,
              color: scheme.outline,
            ),
        ],
      ],
    );
  }
}
