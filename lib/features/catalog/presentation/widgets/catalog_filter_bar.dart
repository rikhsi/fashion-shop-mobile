import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

enum CatalogViewMode { grid, list }

class CatalogFilterBar extends StatelessWidget {
  final String sortLabel;
  final int activeFilterCount;
  final CatalogViewMode viewMode;
  final VoidCallback onFilterTap;
  final ValueChanged<CatalogViewMode> onViewModeChanged;

  const CatalogFilterBar({
    super.key,
    required this.sortLabel,
    required this.activeFilterCount,
    required this.viewMode,
    required this.onFilterTap,
    required this.onViewModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Sort + Filter button
          Expanded(
            child: GestureDetector(
              onTap: onFilterTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: activeFilterCount > 0
                      ? Border.all(color: scheme.primary.withValues(alpha: 0.4))
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 18,
                      color: activeFilterCount > 0 ? scheme.primary : scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '${tr.filters}${activeFilterCount > 0 ? ' ($activeFilterCount)' : ''}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: activeFilterCount > 0 ? scheme.primary : scheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      sortLabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(Icons.expand_more_rounded, size: 18, color: scheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // View mode toggle
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ViewToggleButton(
                  icon: Icons.grid_view_rounded,
                  isActive: viewMode == CatalogViewMode.grid,
                  onTap: () => onViewModeChanged(CatalogViewMode.grid),
                  scheme: scheme,
                ),
                _ViewToggleButton(
                  icon: Icons.view_list_rounded,
                  isActive: viewMode == CatalogViewMode.list,
                  onTap: () => onViewModeChanged(CatalogViewMode.list),
                  scheme: scheme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _ViewToggleButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isActive ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
