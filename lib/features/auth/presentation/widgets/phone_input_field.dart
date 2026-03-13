import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String countryCode;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.countryCode = '+7',
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(16),
            border: errorText != null
                ? Border.all(color: AppColors.error, width: 1.5)
                : null,
          ),
          child: Row(
            children: [
              _buildCountryCodePrefix(),
              _buildDivider(),
              Expanded(child: _buildTextField()),
            ],
          ),
        ),
        if (errorText != null) _buildErrorText(),
      ],
    );
  }

  Widget _buildCountryCodePrefix() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        countryCode,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: AppColors.divider,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(15),
      ],
      style: AppTextStyles.bodyLarge,
      decoration: const InputDecoration(
        hintText: 'Phone number',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 6),
      child: Text(
        errorText!,
        style: AppTextStyles.caption.copyWith(color: AppColors.error),
      ),
    );
  }
}
