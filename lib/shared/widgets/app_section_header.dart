import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const AppSectionHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: AppSpacing.screenPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: scheme.onSurface,
            ),
          ),
          if (onViewAll != null)
            GestureDetector(
              onTap: onViewAll,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Text(
                  context.tr.viewAll,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: scheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
