import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/animations/app_page_route.dart';
import '../../../cart/data/cart_service.dart';
import '../../../favorites/data/favorites_service.dart';
import '../../../home/data/models/card_model.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/data/repositories/home_repository.dart';
import '../../../product/presentation/pages/product_detail_page.dart';
import '../widgets/filter_bottom_sheet.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _repository = sl<HomeRepository>();
  final _favorites = sl<FavoritesService>();
  final _cart = sl<CartService>();
  final _controller = TextEditingController();

  List<CardModel> _allCards = [];
  List<CategoryModel> _categories = [];
  List<CardModel> _results = [];
  bool _loading = true;

  String? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 2000000);
  double _maxPrice = 2000000;
  String _sortBy = 'newest';
  bool _hasActiveFilters = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _favorites.addListener(_refresh);
  }

  @override
  void dispose() {
    _favorites.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() async {
    final catsFuture = _repository.getCategories();
    final cardsFuture = _repository.getAllCards();
    final cats = await catsFuture;
    final cards = await cardsFuture;
    if (!mounted) return;
    _maxPrice = cards.map((c) => c.price).reduce(max);
    _priceRange = RangeValues(0, _maxPrice);
    setState(() {
      _categories = cats;
      _allCards = cards;
      _results = cards;
      _loading = false;
    });
  }

  void _applyFilters() {
    final query = _controller.text.toLowerCase();
    var filtered = _allCards.where((card) {
      if (query.isNotEmpty && !card.title.toLowerCase().contains(query)) {
        return false;
      }
      if (_selectedCategory != null && card.categoryId != _selectedCategory) {
        return false;
      }
      if (card.price < _priceRange.start || card.price > _priceRange.end) {
        return false;
      }
      return true;
    }).toList();

    switch (_sortBy) {
      case 'price_asc':
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case 'price_desc':
        filtered.sort((a, b) => b.price.compareTo(a.price));
      default:
        break;
    }

    _hasActiveFilters =
        _selectedCategory != null ||
        _priceRange.start > 0 ||
        _priceRange.end < _maxPrice ||
        _sortBy != 'newest';

    setState(() => _results = filtered);
  }

  void _showFilters() async {
    final result = await showModalBottomSheet<FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        categories: _categories,
        selectedCategory: _selectedCategory,
        priceRange: _priceRange,
        maxPrice: _maxPrice,
        sortBy: _sortBy,
      ),
    );
    if (result != null) {
      _selectedCategory = result.category;
      _priceRange = result.priceRange;
      _sortBy = result.sortBy;
      _applyFilters();
    }
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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (_) => _applyFilters(),
          style: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurface),
          decoration: InputDecoration(
            hintText: tr.searchHint,
            hintStyle: AppTextStyles.bodyLarge.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: _showFilters,
              ),
              if (_hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: _buildBody(tr),
    );
  }

  Widget _buildBody(AppLocalizations tr) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_results.isEmpty) {
      return AppEmptyState(
        icon: Icons.search_off_rounded,
        title: tr.noResults,
        description: tr.noResultsDescription,
      );
    }

    return GridView.builder(
      padding: AppSpacing.screenPadding.copyWith(top: AppSpacing.base),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.base,
        childAspectRatio: 0.58,
      ),
      itemCount: _results.length,
      itemBuilder: (_, i) {
        final card = _results[i];
        return ProductCard(
          product: cardToProduct(
            card,
            isFavorite: _favorites.isFavorite(card.id),
          ),
          onTap: () => Navigator.push(
            context,
            appSlideRoute(ProductDetailPage(card: card)),
          ),
          onFavoriteTap: () {
            _favorites.toggle(card.id);
          },
          onAddToCart: () => _addToCart(card),
        );
      },
    );
  }
}
