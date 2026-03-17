import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/settings/app_settings_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class StylePreferencesPage extends StatefulWidget {
  final bool isOnboarding;

  const StylePreferencesPage({super.key, this.isOnboarding = false});

  @override
  State<StylePreferencesPage> createState() => _StylePreferencesPageState();
}

class _StylePreferencesPageState extends State<StylePreferencesPage>
    with SingleTickerProviderStateMixin {
  late final PageController _pageCtrl;
  int _currentPage = 0;
  bool _saving = false;

  final Set<AppGender> _selectedGenders = {};
  final Set<AppWeatherFilter> _selectedWeatherFilters = {};
  final Set<String> _selectedStyles = {};
  final Set<String> _selectedSeasons = {};
  final Set<String> _selectedOccasions = {};
  final Set<String> _selectedFabrics = {};
  final Set<String> _selectedColors = {};
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedFits = {};

  static const _totalPages = 9; // Gender + Weather + 7 style steps

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    if (!widget.isOnboarding) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final settings = context.read<AppSettingsCubit>().state;
        if (settings.genders.isNotEmpty || settings.weatherFilters.isNotEmpty) {
          setState(() {
            _selectedGenders.addAll(settings.genders);
            _selectedWeatherFilters.addAll(settings.weatherFilters);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _totalPages - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _save();
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _save() {
    setState(() => _saving = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      final cubit = context.read<AppSettingsCubit>();
      cubit.setGenders(_selectedGenders);
      cubit.setWeatherFilters(_selectedWeatherFilters);
      if (widget.isOnboarding) cubit.completeOnboarding();
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Preferences saved! Your feed will be personalized.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
      Navigator.pop(context);
    });
  }

  int get _totalSelected =>
      _selectedGenders.length +
      _selectedWeatherFilters.length +
      _selectedStyles.length +
      _selectedSeasons.length +
      _selectedOccasions.length +
      _selectedFabrics.length +
      _selectedColors.length +
      _selectedCategories.length +
      _selectedFits.length;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(scheme),
            _buildProgressBar(scheme),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildGenderPage(scheme),
                  _buildWeatherSeasonsPage(scheme),
                  _buildStylesPage(scheme),
                  _buildSeasonsPage(scheme),
                  _buildOccasionsPage(scheme),
                  _buildCategoriesPage(scheme),
                  _buildFabricsPage(scheme),
                  _buildColorsPage(scheme),
                  _buildFitPage(scheme),
                ],
              ),
            ),
            _buildBottomBar(scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm, AppSpacing.sm, AppSpacing.base, 0,
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            IconButton(
              onPressed: _back,
              icon: const Icon(Icons.arrow_back_rounded),
            )
          else if (!widget.isOnboarding)
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
            )
          else
            const SizedBox(width: 48),
          const Spacer(),
          if (_currentPage < _totalPages - 1)
            TextButton(
              onPressed: _next,
              child: Text(
                'Skip',
                style: AppTextStyles.labelMedium.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
      child: Row(
        children: List.generate(_totalPages, (i) {
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 3,
              margin: EdgeInsets.only(right: i < _totalPages - 1 ? 4 : 0),
              decoration: BoxDecoration(
                color: i <= _currentPage
                    ? scheme.primary
                    : scheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme scheme) {
    final isLast = _currentPage == _totalPages - 1;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.md,
        AppSpacing.base,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(top: BorderSide(color: scheme.outline)),
      ),
      child: Row(
        children: [
          if (_totalSelected > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                '$_totalSelected selected',
                style: AppTextStyles.labelMedium.copyWith(color: scheme.primary),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          const Spacer(),
          GestureDetector(
            onTap: _saving ? null : _next,
            child: Container(
              height: AppSpacing.buttonHeight,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              decoration: BoxDecoration(
                color: _saving ? scheme.outline : scheme.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: _saving
                  ? Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLast ? 'Done' : 'Continue',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: scheme.onPrimary,
                          ),
                        ),
                        if (!isLast) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Icon(Icons.arrow_forward_rounded, size: 18, color: scheme.onPrimary),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 0: Gender (multiple)
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildGenderPage(ColorScheme scheme) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding.copyWith(top: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Who is this for?',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Select all that apply. We\'ll show clothes that match.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.xl),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.4,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final g = AppGender.values[i];
                final isSelected = _selectedGenders.contains(g);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedGenders.contains(g)) {
                        _selectedGenders.remove(g);
                      } else {
                        _selectedGenders.add(g);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? scheme.primary.withValues(alpha: 0.12)
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                        color: isSelected ? scheme.primary : scheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          g == AppGender.male
                              ? Icons.face_rounded
                              : g == AppGender.female
                                  ? Icons.face_2_rounded
                                  : Icons.person_rounded,
                          size: 36,
                          color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          g.label,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: isSelected ? scheme.primary : scheme.onSurface,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: AppGender.values.length,
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 1: Season & Weather (multiple, cards)
  // ══════════════════════════════════════════════════════════════════════

  static const _weatherCards = [
    (AppWeatherFilter.all, 'All', '🌐', 'All products'),
    (AppWeatherFilter.spring, 'Spring', '🌸', 'Весна'),
    (AppWeatherFilter.summer, 'Summer', '☀️', 'Лето'),
    (AppWeatherFilter.autumn, 'Autumn', '🍂', 'Осень'),
    (AppWeatherFilter.winter, 'Winter', '❄️', 'Зима'),
    (AppWeatherFilter.rainy, 'Rainy', '💧', 'Дождливая погода'),
    (AppWeatherFilter.snowy, 'Snowy', '❄', 'Снег'),
    (AppWeatherFilter.dryHot, 'Dry & Hot', '🔥', 'Жарко и сухо'),
  ];

  Widget _buildWeatherSeasonsPage(ColorScheme scheme) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding.copyWith(top: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Season & Weather',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Pick all conditions you shop for. We\'ll prioritize matching items.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.xl),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final (filter, label, emoji, desc) = _weatherCards[i];
                final isSelected = _selectedWeatherFilters.contains(filter);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedWeatherFilters.contains(filter)) {
                        _selectedWeatherFilters.remove(filter);
                      } else {
                        _selectedWeatherFilters.add(filter);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? scheme.primary.withValues(alpha: 0.12)
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(
                        color: isSelected ? scheme.primary : scheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 24)),
                            const Spacer(),
                            Text(
                              label,
                              style: AppTextStyles.titleSmall.copyWith(
                                color: isSelected ? scheme.primary : scheme.onSurface,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              desc,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: scheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        if (isSelected)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: scheme.onPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _weatherCards.length,
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 2: Styles
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildStylesPage(ColorScheme scheme) {
    const items = [
      _PrefItem('Old Money', '🏛️', 'Elegant, timeless, quiet luxury'),
      _PrefItem('Streetwear', '🔥', 'Urban, bold, sneaker culture'),
      _PrefItem('Minimalist', '◻️', 'Clean lines, neutral tones'),
      _PrefItem('Casual', '👕', 'Relaxed, everyday comfort'),
      _PrefItem('Bohemian', '🌸', 'Free-spirited, flowy, earthy'),
      _PrefItem('Classic', '👔', 'Timeless, polished, preppy'),
      _PrefItem('Sporty', '⚡', 'Athleisure, active, dynamic'),
      _PrefItem('Romantic', '🌹', 'Soft, feminine, delicate'),
      _PrefItem('Grunge', '🎸', 'Edgy, distressed, dark'),
      _PrefItem('Y2K', '💿', 'Retro futuristic, bold colors'),
      _PrefItem('Cottagecore', '🌿', 'Rural, vintage, nature-inspired'),
      _PrefItem('Gothic', '🖤', 'Dark, dramatic, mysterious'),
      _PrefItem('Preppy', '🎓', 'Academic, clean-cut, polished'),
      _PrefItem('Avant-Garde', '🎨', 'Experimental, artistic, unique'),
      _PrefItem('Scandinavian', '❄️', 'Hygge, cozy, functional'),
      _PrefItem('Korean (K-Fashion)', '🇰🇷', 'Trendy, layered, oversized'),
    ];

    return _buildSelectionPage(
      scheme: scheme,
      title: 'What\'s your style?',
      subtitle: 'Pick styles that match your vibe. We\'ll curate your feed accordingly.',
      items: items,
      selected: _selectedStyles,
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 2: Seasons & Weather
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildSeasonsPage(ColorScheme scheme) {
    const items = [
      _PrefItem('Spring', '🌷', 'Light layers, fresh colors'),
      _PrefItem('Summer', '☀️', 'Breathable, light, vibrant'),
      _PrefItem('Autumn', '🍂', 'Warm tones, cozy layers'),
      _PrefItem('Winter', '❄️', 'Insulated, heavy, layered'),
      _PrefItem('Hot Climate', '🔥', 'Lightweight, UV-protective'),
      _PrefItem('Rainy Season', '🌧️', 'Water-resistant, quick-dry'),
      _PrefItem('All-Season', '🌍', 'Versatile, transitional'),
    ];

    return _buildSelectionPage(
      scheme: scheme,
      title: 'Season & Weather',
      subtitle: 'What weather do you usually dress for? We\'ll prioritize seasonal items.',
      items: items,
      selected: _selectedSeasons,
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 3: Occasions
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildOccasionsPage(ColorScheme scheme) {
    const items = [
      _PrefItem('Everyday', '🏠', 'Home, errands, casual outings'),
      _PrefItem('Work / Office', '💼', 'Professional, business casual'),
      _PrefItem('Date Night', '🌙', 'Elegant, attractive, special'),
      _PrefItem('Party / Club', '🎉', 'Bold, glamorous, eye-catching'),
      _PrefItem('Wedding Guest', '💍', 'Formal, festive, sophisticated'),
      _PrefItem('Travel', '✈️', 'Wrinkle-free, versatile, comfy'),
      _PrefItem('Sport / Gym', '🏋️', 'Performance, flexible, breathable'),
      _PrefItem('Beach / Pool', '🏖️', 'Swimwear, cover-ups, light'),
      _PrefItem('Traditional Events', '🎊', 'National, cultural celebrations'),
      _PrefItem('Job Interview', '🤝', 'Sharp, confident, polished'),
    ];

    return _buildSelectionPage(
      scheme: scheme,
      title: 'Where do you wear it?',
      subtitle: 'Tell us about your lifestyle. We\'ll suggest clothes for the right moments.',
      items: items,
      selected: _selectedOccasions,
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 4: Categories
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildCategoriesPage(ColorScheme scheme) {
    const items = [
      _PrefItem('Dresses', '👗', 'Midi, maxi, mini, cocktail'),
      _PrefItem('T-Shirts & Tops', '👕', 'Tees, blouses, crop tops'),
      _PrefItem('Shirts', '👔', 'Dress shirts, flannel, linen'),
      _PrefItem('Pants & Jeans', '👖', 'Denim, chinos, trousers'),
      _PrefItem('Skirts', '🩳', 'A-line, pleated, wrap'),
      _PrefItem('Jackets & Coats', '🧥', 'Blazers, puffer, trench'),
      _PrefItem('Sweaters & Knits', '🧶', 'Pullovers, cardigans, hoodies'),
      _PrefItem('Suits', '🤵', 'Two-piece, tuxedo, separates'),
      _PrefItem('Activewear', '🏃', 'Leggings, sports bra, shorts'),
      _PrefItem('Loungewear', '🛋️', 'Pajamas, robes, house sets'),
      _PrefItem('Accessories', '👜', 'Bags, scarves, belts, hats'),
      _PrefItem('Shoes', '👟', 'Sneakers, boots, heels'),
    ];

    return _buildSelectionPage(
      scheme: scheme,
      title: 'What do you wear?',
      subtitle: 'Pick categories you shop for most. Select as many as you like.',
      items: items,
      selected: _selectedCategories,
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 5: Fabrics
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildFabricsPage(ColorScheme scheme) {
    const items = [
      _PrefItem('Cotton', '🌱', 'Breathable, natural, everyday'),
      _PrefItem('Linen', '🌾', 'Lightweight, textured, summer'),
      _PrefItem('Silk', '✨', 'Luxurious, smooth, elegant'),
      _PrefItem('Wool', '🐑', 'Warm, insulating, premium'),
      _PrefItem('Denim', '👖', 'Durable, casual, classic'),
      _PrefItem('Cashmere', '🏔️', 'Ultra-soft, warm, luxury'),
      _PrefItem('Polyester', '🔄', 'Wrinkle-resistant, durable'),
      _PrefItem('Velvet', '🎭', 'Rich texture, elegant, evening'),
      _PrefItem('Leather', '🧥', 'Durable, edgy, statement'),
      _PrefItem('Chiffon', '🦋', 'Sheer, flowy, delicate'),
      _PrefItem('Satin', '💎', 'Glossy, smooth, formal'),
      _PrefItem('Organic / Eco', '♻️', 'Sustainable, earth-friendly'),
    ];

    return _buildSelectionPage(
      scheme: scheme,
      title: 'Fabric preferences',
      subtitle: 'What materials do you love wearing? This helps us find the right products.',
      items: items,
      selected: _selectedFabrics,
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 6: Colors
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildColorsPage(ColorScheme scheme) {
    const items = [
      _PrefItem('Black', '⬛', 'Universal, slimming, bold'),
      _PrefItem('White', '⬜', 'Fresh, clean, crisp'),
      _PrefItem('Navy Blue', '🔵', 'Classic, versatile, smart'),
      _PrefItem('Beige / Nude', '🟫', 'Neutral, soft, effortless'),
      _PrefItem('Gray', '🩶', 'Modern, understated, chic'),
      _PrefItem('Brown / Camel', '🟤', 'Earthy, warm, rich'),
      _PrefItem('Red', '🔴', 'Bold, passionate, attention'),
      _PrefItem('Pink', '🩷', 'Playful, feminine, soft'),
      _PrefItem('Green', '🟢', 'Natural, fresh, calming'),
      _PrefItem('Pastel Tones', '🌈', 'Soft, delicate, spring-like'),
      _PrefItem('Earth Tones', '🍂', 'Olive, rust, terracotta'),
      _PrefItem('Bright / Neon', '💛', 'Vibrant, energetic, daring'),
    ];

    return _buildSelectionPage(
      scheme: scheme,
      title: 'Color palette',
      subtitle: 'Which colors dominate your wardrobe? Select your favorites.',
      items: items,
      selected: _selectedColors,
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Page 7: Fit
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildFitPage(ColorScheme scheme) {
    const items = [
      _PrefItem('Slim Fit', '📏', 'Close to body, tailored'),
      _PrefItem('Regular Fit', '👔', 'Standard, comfortable'),
      _PrefItem('Relaxed Fit', '😌', 'Loose, easy-going'),
      _PrefItem('Oversized', '📦', 'Extra roomy, streetwear'),
      _PrefItem('Cropped', '✂️', 'Shorter length, modern'),
      _PrefItem('High-Waisted', '⬆️', 'Flattering, elongating'),
      _PrefItem('Flared', '🔔', 'Wide at bottom, retro'),
      _PrefItem('Bodycon', '🎯', 'Figure-hugging, bold'),
    ];

    return _buildSelectionPage(
      scheme: scheme,
      title: 'How do you like the fit?',
      subtitle: 'Last step! Tell us about your preferred silhouettes.',
      items: items,
      selected: _selectedFits,
    );
  }

  // ══════════════════════════════════════════════════════════════════════
  // Reusable grid page
  // ══════════════════════════════════════════════════════════════════════

  Widget _buildSelectionPage({
    required ColorScheme scheme,
    required String title,
    required String subtitle,
    required List<_PrefItem> items,
    required Set<String> selected,
  }) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: AppSpacing.screenPadding.copyWith(top: AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.xl),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.55,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) => _PrefCard(
                item: items[i],
                isSelected: selected.contains(items[i].label),
                scheme: scheme,
                onTap: () {
                  setState(() {
                    if (selected.contains(items[i].label)) {
                      selected.remove(items[i].label);
                    } else {
                      selected.add(items[i].label);
                    }
                  });
                },
              ),
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// Data class
// ══════════════════════════════════════════════════════════════════════════

class _PrefItem {
  final String label;
  final String emoji;
  final String description;

  const _PrefItem(this.label, this.emoji, this.description);
}

// ══════════════════════════════════════════════════════════════════════════
// Yandex Music-style preference card
// ══════════════════════════════════════════════════════════════════════════

class _PrefCard extends StatelessWidget {
  final _PrefItem item;
  final bool isSelected;
  final ColorScheme scheme;
  final VoidCallback onTap;

  const _PrefCard({
    required this.item,
    required this.isSelected,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? scheme.primary.withValues(alpha: 0.12)
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? scheme.primary : scheme.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const Spacer(),
                Text(
                  item.label,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isSelected ? scheme.primary : scheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 14,
                    color: scheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
