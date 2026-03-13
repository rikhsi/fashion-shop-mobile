import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
    this.onChanged,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: readOnly ? onTap : null,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: scheme.outlineVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.sm,
              ),
              child: Icon(
                Icons.search_rounded,
                size: AppSpacing.iconSm,
                color: scheme.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: readOnly
                  ? Text(
                      hintText,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  : TextField(
                      onChanged: onChanged,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
