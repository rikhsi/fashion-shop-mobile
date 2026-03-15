import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/mappers/card_mapper.dart';

class CatalogFilterResult {
  final RangeValues priceRange;
  final String sortBy;
  final bool onlyDiscounts;
  final bool onlyNew;

  const CatalogFilterResult({
    required this.priceRange,
    required this.sortBy,
    required this.onlyDiscounts,
    required this.onlyNew,
  });

  int get activeCount {
    int c = 0;
    if (sortBy != 'default') c++;
    if (onlyDiscounts) c++;
    if (onlyNew) c++;
    return c;
  }
}

class CatalogFilterSheet extends StatefulWidget {
  final RangeValues priceRange;
  final double maxPrice;
  final String sortBy;
  final bool onlyDiscounts;
  final bool onlyNew;

  const CatalogFilterSheet({
    super.key,
    required this.priceRange,
    required this.maxPrice,
    required this.sortBy,
    required this.onlyDiscounts,
    required this.onlyNew,
  });

  @override
  State<CatalogFilterSheet> createState() => _CatalogFilterSheetState();
}

class _CatalogFilterSheetState extends State<CatalogFilterSheet> {
  late RangeValues _priceRange;
  late String _sortBy;
  late bool _onlyDiscounts;
  late bool _onlyNew;

  @override
  void initState() {
    super.initState();
    _priceRange = widget.priceRange;
    _sortBy = widget.sortBy;
    _onlyDiscounts = widget.onlyDiscounts;
    _onlyNew = widget.onlyNew;
  }

  void _reset() {
    setState(() {
      _priceRange = RangeValues(0, widget.maxPrice);
      _sortBy = 'default';
      _onlyDiscounts = false;
      _onlyNew = false;
    });
  }

  void _apply() {
    Navigator.pop(
      context,
      CatalogFilterResult(
        priceRange: _priceRange,
        sortBy: _sortBy,
        onlyDiscounts: _onlyDiscounts,
        onlyNew: _onlyNew,
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
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          MediaQuery.of(context).padding.bottom + AppSpacing.xl,
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
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Sort ──
            Text(
              tr.sortBy,
              style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            _SortOption(label: tr.get('sortDefault'), value: 'default', groupValue: _sortBy, onChanged: (v) => setState(() => _sortBy = v)),
            _SortOption(label: tr.get('sortPopular'), value: 'popular', groupValue: _sortBy, onChanged: (v) => setState(() => _sortBy = v)),
            _SortOption(label: tr.sortNewest, value: 'newest', groupValue: _sortBy, onChanged: (v) => setState(() => _sortBy = v)),
            _SortOption(label: tr.sortPriceAsc, value: 'price_asc', groupValue: _sortBy, onChanged: (v) => setState(() => _sortBy = v)),
            _SortOption(label: tr.sortPriceDesc, value: 'price_desc', groupValue: _sortBy, onChanged: (v) => setState(() => _sortBy = v)),
            _SortOption(label: tr.get('sortDiscount'), value: 'discount', groupValue: _sortBy, onChanged: (v) => setState(() => _sortBy = v)),
            const SizedBox(height: AppSpacing.xl),

            // ── Price range ──
            Text(
              tr.priceRange,
              style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
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
                  Text('${formatPrice(_priceRange.start)} ${tr.currency}', style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
                  Text('${formatPrice(_priceRange.end)} ${tr.currency}', style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Toggles ──
            _ToggleRow(
              label: tr.get('onlyDiscounts'),
              value: _onlyDiscounts,
              onChanged: (v) => setState(() => _onlyDiscounts = v),
              scheme: scheme,
            ),
            const SizedBox(height: AppSpacing.md),
            _ToggleRow(
              label: tr.get('onlyNew'),
              value: _onlyNew,
              onChanged: (v) => setState(() => _onlyNew = v),
              scheme: scheme,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // ── Buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      side: BorderSide(color: scheme.outline),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                    ),
                    child: Text(tr.resetFilters, style: AppTextStyles.labelLarge.copyWith(color: scheme.onSurface)),
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
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
                      elevation: 0,
                    ),
                    child: Text(tr.applyFilters, style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary)),
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

class _SortOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _SortOption({required this.label, required this.value, required this.groupValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              size: 22,
              color: selected ? scheme.primary : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Text(label, style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface)),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final ColorScheme scheme;

  const _ToggleRow({required this.label, required this.value, required this.onChanged, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurface)),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: scheme.primary,
        ),
      ],
    );
  }
}
