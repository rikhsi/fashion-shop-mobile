import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_search_bar.dart';
import '../widgets/categories_section.dart';
import '../widgets/new_arrivals_section.dart';
import '../widgets/popular_products_section.dart';
import '../widgets/promotions_section.dart';
import '../widgets/recommended_section.dart';
import '../widgets/special_offers_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              title: _HomeAppBar(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
            const SliverToBoxAdapter(child: PromotionsSection()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
            const SliverToBoxAdapter(child: CategoriesSection()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
            const SliverToBoxAdapter(child: PopularProductsSection()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
            const SliverToBoxAdapter(child: NewArrivalsSection()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
            const SliverToBoxAdapter(child: SpecialOffersSection()),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
            const SliverToBoxAdapter(child: RecommendedSection()),
            const SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: AppSearchBar(hintText: context.tr.searchHint),
        ),
        const SizedBox(width: AppSpacing.sm),
        _IconBtn(
          icon: Icons.tune_rounded,
          onTap: () {},
          scheme: scheme,
        ),
        const SizedBox(width: AppSpacing.xs),
        _IconBtn(
          icon: Icons.favorite_border_rounded,
          onTap: () {},
          scheme: scheme,
        ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: scheme.outlineVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(icon, size: 20, color: scheme.onSurfaceVariant),
      ),
    );
  }
}
