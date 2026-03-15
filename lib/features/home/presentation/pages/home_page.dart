import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/animations/app_page_route.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/app_section_header.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../cart/data/cart_service.dart';
import '../../../favorites/data/favorites_service.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../data/models/banner_model.dart';
import '../../data/models/card_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/home_repository.dart';
import '../widgets/banner_skeleton.dart';
import '../widgets/card_skeleton.dart';
import '../widgets/promotions_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = sl<HomeRepository>();
  final _favorites = sl<FavoritesService>();
  final _cart = sl<CartService>();

  bool _bannersLoading = true;
  bool _categoriesLoading = true;
  List<BannerModel> _banners = [];
  final List<_Section> _sections = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _favorites.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favorites.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadInitialData() async {
    final bannersFuture = _repository.getBanners();
    final categoriesFuture = _repository.getCategories();

    final banners = await bannersFuture;
    if (mounted) {
      setState(() {
        _banners = banners;
        _bannersLoading = false;
      });
    }

    final categories = await categoriesFuture;
    if (!mounted) return;

    for (final cat in categories) {
      _sections.add(_Section(category: cat));
    }
    setState(() => _categoriesLoading = false);

    for (int i = 0; i < _sections.length; i++) {
      _loadSectionCards(i);
    }
  }

  Future<void> _loadSectionCards(int index) async {
    final cards = await _repository.getCards(_sections[index].category.id);
    if (!mounted) return;
    setState(() {
      _sections[index].cards = cards;
      _sections[index].isLoading = false;
    });
  }

  void _toggleExpanded(int index) {
    setState(() => _sections[index].isExpanded = !_sections[index].isExpanded);
  }

  void _addToCart(CardModel card) {
    _cart.addItem(card);
    if (!mounted) return;
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

  void _openSearch() {
    Navigator.push(context, appSlideRoute(const SearchPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              toolbarHeight: 60,
              title: _HomeAppBar(
                onSearchTap: _openSearch,
                onFilterTap: _openSearch,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
            SliverToBoxAdapter(
              child: _bannersLoading
                  ? const BannerSkeleton()
                  : PromotionsSection(banners: _banners),
            ),
            if (_categoriesLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xxl),
                  child: CardGridSkeleton(count: 4),
                ),
              )
            else
              for (int i = 0; i < _sections.length; i++) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xl),
                    child: AppSectionHeader(
                      title: _sections[i].category.title,
                      onViewAll: () {},
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.base),
                ),
                _buildSectionContent(i),
              ],
            const SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContent(int index) {
    final section = _sections[index];

    if (section.isLoading) {
      return SliverToBoxAdapter(
        child: section.category.layout == CategoryLayout.horizontal
            ? const CardHorizontalSkeleton()
            : const CardGridSkeleton(count: 8),
      );
    }

    if (section.category.layout == CategoryLayout.horizontal) {
      return SliverToBoxAdapter(
        child: _HorizontalCardList(
          cards: section.cards,
          favorites: _favorites,
          onFavoriteTap: (id) => _favorites.toggle(id),
          onAddToCart: _addToCart,
        ),
      );
    }

    return SliverToBoxAdapter(
      child: _VerticalCardGrid(
        cards: section.cards,
        isExpanded: section.isExpanded,
        favorites: _favorites,
        onShowMore: () => _toggleExpanded(index),
        onFavoriteTap: (id) => _favorites.toggle(id),
        onAddToCart: _addToCart,
      ),
    );
  }
}

// ── Section state ──

class _Section {
  final CategoryModel category;
  List<CardModel> cards = const [];
  bool isLoading = true;
  bool isExpanded = false;

  _Section({required this.category});
}

// ── Horizontal card list ──

class _HorizontalCardList extends StatelessWidget {
  final List<CardModel> cards;
  final FavoritesService favorites;
  final ValueChanged<String> onFavoriteTap;
  final ValueChanged<CardModel> onAddToCart;

  const _HorizontalCardList({
    required this.cards,
    required this.favorites,
    required this.onFavoriteTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screenPadding,
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, i) {
          final card = cards[i];
          return ProductCard(
            product: cardToProduct(
              card,
              isFavorite: favorites.isFavorite(card.id),
            ),
            width: 150,
            onTap: () => Navigator.push(
              context,
              appSlideRoute(ProductDetailPage(card: card)),
            ),
            onFavoriteTap: () => onFavoriteTap(card.id),
            onAddToCart: () => onAddToCart(card),
          );
        },
      ),
    );
  }
}

// ── Vertical card grid with "Show more" ──

class _VerticalCardGrid extends StatelessWidget {
  final List<CardModel> cards;
  final bool isExpanded;
  final FavoritesService favorites;
  final VoidCallback onShowMore;
  final ValueChanged<String> onFavoriteTap;
  final ValueChanged<CardModel> onAddToCart;

  static const _collapsedCount = 8;

  const _VerticalCardGrid({
    required this.cards,
    required this.isExpanded,
    required this.favorites,
    required this.onShowMore,
    required this.onFavoriteTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visibleCount = isExpanded
        ? min(cards.length, 60)
        : min(cards.length, _collapsedCount);
    final hasMore = cards.length > _collapsedCount && !isExpanded;

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.base,
                childAspectRatio: 0.58,
              ),
              itemCount: visibleCount,
              itemBuilder: (context, i) {
                final card = cards[i];
                return ProductCard(
                  product: cardToProduct(
                    card,
                    isFavorite: favorites.isFavorite(card.id),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    appSlideRoute(ProductDetailPage(card: card)),
                  ),
                  onFavoriteTap: () => onFavoriteTap(card.id),
                  onAddToCart: () => onAddToCart(card),
                );
              },
            ),
          ),
          if (hasMore) ...[
            const SizedBox(height: AppSpacing.base),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onShowMore,
                icon: const Icon(Icons.expand_more_rounded, size: 20),
                label: Text(
                  'Show more',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: scheme.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.primary,
                  side: BorderSide(color: scheme.outline),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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

// ── App bar ──

class _HomeAppBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const _HomeAppBar({required this.onSearchTap, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSearchBar(
            hintText: context.tr.searchHint,
            onTap: onSearchTap,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppIconButton(icon: Icons.tune_rounded, onTap: onFilterTap),
        const SizedBox(width: AppSpacing.xs),
        AppIconButton(icon: Icons.favorite_border_rounded, onTap: () {}),
      ],
    );
  }
}
