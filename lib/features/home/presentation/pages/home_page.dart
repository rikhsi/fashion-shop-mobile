import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/widgets/app_icon_button.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../../../../shared/widgets/app_section_header.dart';
import '../../../../shared/widgets/product_card.dart';
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

  bool _bannersLoading = true;
  bool _categoriesLoading = true;
  List<BannerModel> _banners = [];
  final List<_Section> _sections = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final bannersFuture = _repository.getBanners();
    final categoriesFuture = _repository.getCategories();

    final banners = await bannersFuture;
    if (mounted) setState(() { _banners = banners; _bannersLoading = false; });

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
              title: const _HomeAppBar(),
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
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.base)),
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
        child: _HorizontalCardList(cards: section.cards),
      );
    }

    return SliverToBoxAdapter(
      child: _VerticalCardGrid(
        cards: section.cards,
        isExpanded: section.isExpanded,
        onShowMore: () => _toggleExpanded(index),
      ),
    );
  }
}

// ── Section state ──

class _Section {
  final CategoryModel category;
  List<CardModel> cards;
  bool isLoading;
  bool isExpanded;

  _Section({
    required this.category,
    this.cards = const [],
    this.isLoading = true,
    this.isExpanded = false,
  });
}

// ── Horizontal card list ──

class _HorizontalCardList extends StatelessWidget {
  final List<CardModel> cards;
  const _HorizontalCardList({required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screenPadding,
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, i) => ProductCard(
          product: _cardToProduct(cards[i]),
          width: 150,
          onTap: () {},
        ),
      ),
    );
  }
}

// ── Vertical card grid with "Show more" ──

class _VerticalCardGrid extends StatelessWidget {
  final List<CardModel> cards;
  final bool isExpanded;
  final VoidCallback onShowMore;

  static const _collapsedCount = 8;

  const _VerticalCardGrid({
    required this.cards,
    required this.isExpanded,
    required this.onShowMore,
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.base,
              childAspectRatio: 0.58,
            ),
            itemCount: visibleCount,
            itemBuilder: (_, i) => ProductCard(
              product: _cardToProduct(cards[i]),
              onTap: () {},
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

// ── Helpers ──

Product _cardToProduct(CardModel card) {
  const colors = [
    Color(0xFFE8D5C4), Color(0xFF4A6FA5), Color(0xFF2D3436),
    Color(0xFFF5F0E8), Color(0xFF6B7B3C), Color(0xFF5C7AEA),
    Color(0xFFE17055), Color(0xFF00B894), Color(0xFFE8A0BF),
    Color(0xFF636E72),
  ];
  const categoryIcons = <String, IconData>{
    'women': Icons.dry_cleaning_outlined,
    'men': Icons.checkroom_outlined,
    'shoes': Icons.ice_skating_outlined,
    'accessories': Icons.watch_outlined,
    'new': Icons.auto_awesome_outlined,
  };
  return Product(
    id: card.id,
    name: card.title,
    price: card.price,
    originalPrice: card.originalPrice,
    placeholderColor: colors[card.id.hashCode.abs() % colors.length],
    icon: categoryIcons[card.categoryId] ?? Icons.checkroom_outlined,
    category: card.categoryId,
    isNew: card.isNew,
    isFavorite: card.isFavorite,
    imageUrl: card.imageUrl,
  );
}

// ── App bar ──

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSearchBar(hintText: context.tr.searchHint),
        ),
        const SizedBox(width: AppSpacing.sm),
        AppIconButton(
          icon: Icons.tune_rounded,
          onTap: () {},
        ),
        const SizedBox(width: AppSpacing.xs),
        AppIconButton(
          icon: Icons.favorite_border_rounded,
          onTap: () {},
        ),
      ],
    );
  }
}
