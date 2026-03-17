import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.base,
          bottom: AppSpacing.xxl,
        ),
        children: [
          Text(
            'Fashion Shop Privacy Policy',
            style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Last updated: March 1, 2026',
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._sections.map((s) => _PolicySection(
                title: s.$1,
                body: s.$2,
                scheme: scheme,
              )),
        ],
      ),
    );
  }

  static const _sections = [
    (
      'Information We Collect',
      'We collect information you provide directly, including your phone number for authentication, name and profile details, delivery addresses, and order history. We also automatically collect device information, usage data, and location data (with your permission) to improve our services.',
    ),
    (
      'How We Use Your Information',
      'Your data is used to process and deliver orders, provide customer support through in-app chat, send order updates and notifications, personalize product recommendations, process payments through our partners (Click, Payme, Uzum Bank, Paynet), and improve our app experience.',
    ),
    (
      'Data Sharing',
      'We share your information only with delivery partners to fulfill orders, payment processors to handle transactions, and analytics providers to improve the app. We never sell your personal data to third parties for advertising purposes.',
    ),
    (
      'Data Security',
      'We implement industry-standard security measures including encrypted data transmission (TLS/SSL), secure storage of personal information, regular security audits, and access controls for our team members.',
    ),
    (
      'Your Rights',
      'You have the right to access your personal data, request correction of inaccurate data, delete your account and all associated data, opt out of promotional notifications, and export your order history.',
    ),
    (
      'Data Retention',
      'We retain your data for as long as your account is active. Order history is kept for 3 years for legal compliance. Upon account deletion, personal data is removed within 30 days, though anonymized analytics data may be retained.',
    ),
    (
      'Cookies & Tracking',
      'Our mobile app uses local storage for session management and preferences. We use analytics to understand app usage patterns. You can control notification preferences in the app settings.',
    ),
    (
      'Changes to This Policy',
      'We may update this privacy policy from time to time. We will notify you of significant changes through in-app notifications. Continued use of the app after changes constitutes acceptance.',
    ),
    (
      'Contact Us',
      'If you have questions about this privacy policy or your data, contact us at privacy@fashionshop.uz or through the "Contact Us" section in the app.',
    ),
  ];
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String body;
  final ColorScheme scheme;

  const _PolicySection({
    required this.title,
    required this.body,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
