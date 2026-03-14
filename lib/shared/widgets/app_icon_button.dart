import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: scheme.outlineVariant,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(
          icon,
          size: AppSpacing.iconSm,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
