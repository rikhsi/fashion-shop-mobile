import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';

class AgreementText extends StatelessWidget {
  final VoidCallback? onPolicyTap;

  const AgreementText({super.key, this.onPolicyTap});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.bodySmall,
        children: [
          const TextSpan(text: AppStrings.agreementPrefix),
          TextSpan(
            text: AppStrings.personalDataPolicy,
            style: AppTextStyles.link,
            recognizer: TapGestureRecognizer()..onTap = onPolicyTap,
          ),
        ],
      ),
    );
  }
}
