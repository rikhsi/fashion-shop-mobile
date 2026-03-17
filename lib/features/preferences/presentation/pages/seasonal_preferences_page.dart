import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/seasonal_preferences_service.dart';

const _seasons = [
  ('Spring', '🌸', Color(0xFFE91E63)),
  ('Summer', '☀️', Color(0xFFF59E0B)),
  ('Autumn', '🍂', Color(0xFFEF6C00)),
  ('Winter', '❄️', Color(0xFF42A5F5)),
];

/// Options for each preference category (label, emoji).
const _styleOptions = [
  ('Old Money', '🏛️'), ('Streetwear', '🔥'), ('Minimalist', '◻️'),
  ('Casual', '👕'), ('Bohemian', '🌸'), ('Classic', '👔'),
  ('Sporty', '⚡'), ('Romantic', '🌹'), ('Grunge', '🎸'),
  ('Y2K', '💿'), ('Cottagecore', '🌿'), ('Gothic', '🖤'),
  ('Preppy', '🎓'), ('Avant-Garde', '🎨'), ('Scandinavian', '❄️'),
  ('Korean (K-Fashion)', '🇰🇷'),
];

const _colorOptions = [
  ('Black', '⬛'), ('White', '⬜'), ('Navy Blue', '🔵'),
  ('Beige / Nude', '🟫'), ('Gray', '🩶'), ('Brown / Camel', '🟤'),
  ('Red', '🔴'), ('Pink', '🩷'), ('Green', '🟢'),
  ('Pastel Tones', '🌈'), ('Earth Tones', '🍂'), ('Bright / Neon', '💛'),
];

const _fabricOptions = [
  ('Cotton', '🌱'), ('Linen', '🌾'), ('Silk', '✨'),
  ('Wool', '🐑'), ('Denim', '👖'), ('Cashmere', '🏔️'),
  ('Polyester', '🔄'), ('Velvet', '🎭'), ('Leather', '🧥'),
  ('Chiffon', '🦋'), ('Satin', '💎'), ('Organic / Eco', '♻️'),
];

const _categoryOptions = [
  ('Dresses', '👗'), ('T-Shirts & Tops', '👕'), ('Shirts', '👔'),
  ('Pants & Jeans', '👖'), ('Skirts', '🩳'), ('Jackets & Coats', '🧥'),
  ('Sweaters & Knits', '🧶'), ('Suits', '🤵'), ('Activewear', '🏃'),
  ('Loungewear', '🛋️'), ('Accessories', '👜'), ('Shoes', '👟'),
];

const _occasionOptions = [
  ('Everyday', '🏠'), ('Work / Office', '💼'), ('Date Night', '🌙'),
  ('Party / Club', '🎉'), ('Wedding Guest', '💍'), ('Travel', '✈️'),
  ('Sport / Gym', '🏋️'), ('Beach / Pool', '🏖️'),
  ('Traditional Events', '🎊'), ('Job Interview', '🤝'),
];

const _fitOptions = [
  ('Slim Fit', '📏'), ('Regular Fit', '👔'), ('Relaxed Fit', '😌'),
  ('Oversized', '📦'), ('Cropped', '✂️'), ('High-Waisted', '⬆️'),
  ('Flared', '🔔'), ('Bodycon', '🎯'),
];

/// All category configs: (key, label, options)
const _categoryConfigs = [
  ('styles', 'Styles', _styleOptions),
  ('colors', 'Colors', _colorOptions),
  ('fabrics', 'Fabrics', _fabricOptions),
  ('categories', 'Categories', _categoryOptions),
  ('occasions', 'Occasions', _occasionOptions),
  ('fits', 'Fit', _fitOptions),
];

class SeasonalPreferencesPage extends StatefulWidget {
  const SeasonalPreferencesPage({super.key});

  @override
  State<SeasonalPreferencesPage> createState() =>
      _SeasonalPreferencesPageState();
}

class _SeasonalPreferencesPageState extends State<SeasonalPreferencesPage> {
  late SeasonalPreferencesService _service;
  late Map<String, SeasonalPrefs> _data;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _service = sl<SeasonalPreferencesService>();
    _data = Map.from(_service.getAll());
  }

  void _toggle(String season, String category, String value) {
    setState(() {
      _service.toggle(season, category, value);
      _data = Map.from(_service.getAll());
    });
  }

  void _save() {
    setState(() => _saving = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(
              'Seasonal preferences saved! Your feed will adapt to each season.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preferences by Season',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.base,
          bottom: AppSpacing.xxl + AppSpacing.buttonHeight,
        ),
        children: [
          Text(
            'Set your favorite styles, colors, fabrics and more for each season. We\'ll show relevant items based on the weather.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._seasons.map((s) => _SeasonSection(
                seasonLabel: s.$1,
                emoji: s.$2,
                accentColor: s.$3,
                prefs: _data[s.$1] ?? const SeasonalPrefs(),
                scheme: scheme,
                onToggle: (cat, val) => _toggle(s.$1, cat, val),
              )),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding.copyWith(top: AppSpacing.md),
          child: GestureDetector(
            onTap: _saving ? null : _save,
            child: Container(
              height: AppSpacing.buttonHeight,
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
                  : Center(
                      child: Text(
                        'Save',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SeasonSection extends StatefulWidget {
  final String seasonLabel;
  final String emoji;
  final Color accentColor;
  final SeasonalPrefs prefs;
  final ColorScheme scheme;
  final void Function(String category, String value) onToggle;

  const _SeasonSection({
    required this.seasonLabel,
    required this.emoji,
    required this.accentColor,
    required this.prefs,
    required this.scheme,
    required this.onToggle,
  });

  @override
  State<_SeasonSection> createState() => _SeasonSectionState();
}

class _SeasonSectionState extends State<_SeasonSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final scheme = widget.scheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Row(
                children: [
                  Text(widget.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.seasonLabel,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      '${widget.prefs.totalSelected}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: widget.accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                0,
                AppSpacing.base,
                AppSpacing.base,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _categoryConfigs.map((cfg) {
                  final (key, label, options) = cfg;
                  final selected = widget.prefs.getByKey(key);
                  return _CategoryChips(
                    label: label,
                    options: options,
                    selected: selected,
                    accentColor: widget.accentColor,
                    scheme: scheme,
                    onToggle: (v) => widget.onToggle(key, v),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final String label;
  final List<(String, String)> options;
  final Set<String> selected;
  final Color accentColor;
  final ColorScheme scheme;
  final ValueChanged<String> onToggle;

  const _CategoryChips({
    required this.label,
    required this.options,
    required this.selected,
    required this.accentColor,
    required this.scheme,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.titleSmall.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: options.map((opt) {
              final (lbl, emoji) = opt;
              final isSelected = selected.contains(lbl);
              return GestureDetector(
                onTap: () => onToggle(lbl),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accentColor.withValues(alpha: 0.15)
                        : scheme.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                    border: Border.all(
                      color: isSelected ? accentColor : scheme.outline,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text(
                        lbl,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isSelected
                              ? accentColor
                              : scheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
