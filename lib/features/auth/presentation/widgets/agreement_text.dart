import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';

class AgreementText extends StatelessWidget {
  final VoidCallback? onPolicyTap;

  const AgreementText({super.key, this.onPolicyTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTextStyles.bodySmall.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        children: [
          TextSpan(text: tr.agreementPrefix),
          TextSpan(
            text: tr.personalDataPolicy,
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
              decorationColor: scheme.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPolicyTap,
          ),
        ],
      ),
    );
  }
}
