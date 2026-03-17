import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
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
            'Terms of Service',
            style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Effective: March 1, 2026',
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._sections.map((s) => _TermsSection(
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
      '1. Acceptance of Terms',
      'By downloading, accessing, or using the Fashion Shop mobile application, you agree to be bound by these Terms of Service. If you do not agree, please do not use the app.',
    ),
    (
      '2. Account Registration',
      'To use our services, you must register with a valid phone number. You are responsible for maintaining the confidentiality of your account. You must be at least 16 years old to create an account. One account per person is allowed.',
    ),
    (
      '3. Orders & Payments',
      'All prices are displayed in Uzbekistani Sum (UZS). We accept payments via Click, Payme, Uzum Bank, and Paynet. Orders are confirmed only after successful payment. We reserve the right to cancel orders due to pricing errors or stock issues, with a full refund.',
    ),
    (
      '4. Delivery',
      'Delivery times are estimates and may vary. Free delivery is available for orders above the specified threshold. You must provide an accurate delivery address. Failed deliveries due to incorrect addresses may incur additional charges.',
    ),
    (
      '5. Returns & Refunds',
      'Items can be returned within 14 days of delivery if unused and in original packaging. Refunds are processed to the original payment method within 3-5 business days. Sale items and undergarments are not eligible for return.',
    ),
    (
      '6. User Conduct',
      'You agree not to use the app for fraudulent purposes, harass sellers or other users, post false reviews, attempt to circumvent payment systems, or use automated tools to access the platform.',
    ),
    (
      '7. Promo Codes',
      'Promo codes are subject to their specific terms and conditions. They cannot be combined unless explicitly stated. We reserve the right to revoke promo codes used fraudulently. Expired codes cannot be reactivated.',
    ),
    (
      '8. Intellectual Property',
      'All content in the app, including logos, images, and text, is owned by Fashion Shop or its licensors. You may not reproduce or distribute any content without written permission.',
    ),
    (
      '9. Limitation of Liability',
      'Fashion Shop is not liable for indirect, incidental, or consequential damages. Our total liability is limited to the amount paid for the specific order in question. We are not responsible for seller product quality — disputes should be resolved through our chat system.',
    ),
    (
      '10. Account Termination',
      'We may suspend or terminate accounts that violate these terms. You may delete your account at any time through the app settings. Upon termination, pending orders will be fulfilled or refunded.',
    ),
    (
      '11. Changes to Terms',
      'We reserve the right to modify these terms at any time. Continued use after modifications constitutes acceptance. Significant changes will be communicated via in-app notification.',
    ),
    (
      '12. Contact',
      'For questions regarding these terms, contact us at legal@fashionshop.uz or through the in-app support.',
    ),
  ];
}

class _TermsSection extends StatelessWidget {
  final String title;
  final String body;
  final ColorScheme scheme;

  const _TermsSection({
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
