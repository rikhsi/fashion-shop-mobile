import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading ? _loader(context) : _label(context);

    if (isOutlined) {
      return SizedBox(
        height: AppSpacing.buttonHeight,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      );
    }

    return SizedBox(
      height: AppSpacing.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }

  Widget _label(BuildContext context) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.sm),
          Text(text),
        ],
      );
    }
    return Text(text);
  }

  Widget _loader(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
