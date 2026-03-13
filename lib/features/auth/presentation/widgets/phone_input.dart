import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const PhoneInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: AppSpacing.inputHeight,
      decoration: BoxDecoration(
        color: scheme.outlineVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.base,
              right: AppSpacing.md,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🇺🇿', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
                Text(
                  AppConstants.defaultCountryCode,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 28, color: scheme.outline),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              enabled: enabled,
              autofocus: true,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _PhoneMaskFormatter(),
                LengthLimitingTextInputFormatter(12),
              ],
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
                color: scheme.onSurface,
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                hintText: '00 000 00 00',
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final limited = digits.length > AppConstants.phoneDigitsLength
        ? digits.substring(0, AppConstants.phoneDigitsLength)
        : digits;

    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 2 || i == 5 || i == 7) buffer.write(' ');
      buffer.write(limited[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
