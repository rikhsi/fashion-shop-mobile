import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';
import '../../../home/data/models/category_model.dart';

class FilterResult {
  final String? category;
  final RangeValues priceRange;
  final String sortBy;

  const FilterResult({
    required this.category,
    required this.priceRange,
    required this.sortBy,
  });
}

class FilterBottomSheet extends StatefulWidget {
  final List<CategoryModel> categories;
  final String? selectedCategory;
  final RangeValues priceRange;
  final double maxPrice;
  final String sortBy;

  const FilterBottomSheet({
    super.key,
    required this.categories,
    this.selectedCategory,
    required this.priceRange,
    required this.maxPrice,
    required this.sortBy,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _category;
  late RangeValues _priceRange;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory;
    _priceRange = widget.priceRange;
    _sortBy = widget.sortBy;
  }

  void _reset() {
    setState(() {
      _category = null;
      _priceRange = RangeValues(0, widget.maxPrice);
      _sortBy = 'newest';
    });
  }

  void _apply() {
    Navigator.pop(
      context,
      FilterResult(
        category: _category,
        priceRange: _priceRange,
        sortBy: _sortBy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              tr.filters,
              style: AppTextStyles.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Categories ──
            Text(
              tr.categories,
              style: AppTextStyles.titleSmall.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _FilterChip(
                  label: tr.allCategories,
                  isSelected: _category == null,
                  onTap: () => setState(() => _category = null),
                ),
                for (final cat in widget.categories)
                  _FilterChip(
                    label: cat.title,
                    isSelected: _category == cat.id,
                    onTap: () => setState(() {
                      _category = _category == cat.id ? null : cat.id;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Price range ──
            Text(
              tr.priceRange,
              style: AppTextStyles.titleSmall.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: widget.maxPrice,
              divisions: 50,
              labels: RangeLabels(
                formatPrice(_priceRange.start),
                formatPrice(_priceRange.end),
              ),
              onChanged: (v) => setState(() => _priceRange = v),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${formatPrice(_priceRange.start)} ${tr.currency}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${formatPrice(_priceRange.end)} ${tr.currency}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Sort ──
            Text(
              tr.sortBy,
              style: AppTextStyles.titleSmall.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _SortOption(
              label: tr.sortNewest,
              value: 'newest',
              groupValue: _sortBy,
              onChanged: (v) => setState(() => _sortBy = v),
            ),
            _SortOption(
              label: tr.sortPriceAsc,
              value: 'price_asc',
              groupValue: _sortBy,
              onChanged: (v) => setState(() => _sortBy = v),
            ),
            _SortOption(
              label: tr.sortPriceDesc,
              value: 'price_desc',
              groupValue: _sortBy,
              onChanged: (v) => setState(() => _sortBy = v),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      side: BorderSide(color: scheme.outline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                    ),
                    child: Text(
                      tr.resetFilters,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMd,
                        ),
                      ),
                    ),
                    child: Text(
                      tr.applyFilters,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : scheme.outlineVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: isSelected ? scheme.onPrimary : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _SortOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(
              value == groupValue
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 22,
              color: value == groupValue
                  ? scheme.primary
                  : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
