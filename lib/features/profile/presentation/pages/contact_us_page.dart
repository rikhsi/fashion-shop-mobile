import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.contactUs,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.base,
          bottom: AppSpacing.xxl,
        ),
        children: [
          _ContactCard(
            icon: Icons.phone_rounded,
            color: AppColors.success,
            title: 'Phone',
            value: '+998 71 200 00 00',
            subtitle: 'Mon–Sat, 9:00 – 18:00',
            onTap: () => _copy(context, '+998712000000'),
          ),
          const SizedBox(height: AppSpacing.md),
          _ContactCard(
            icon: Icons.email_rounded,
            color: AppColors.info,
            title: 'Email',
            value: 'support@fashionshop.uz',
            subtitle: 'We reply within 24 hours',
            onTap: () => _copy(context, 'support@fashionshop.uz'),
          ),
          const SizedBox(height: AppSpacing.md),
          _ContactCard(
            icon: Icons.location_on_rounded,
            color: AppColors.discount,
            title: 'Address',
            value: 'Tashkent, Amir Temur str. 15',
            subtitle: 'Fashion Shop HQ',
            onTap: () => _copy(context, 'Tashkent, Amir Temur str. 15'),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Social Media',
            style: AppTextStyles.titleMedium.copyWith(
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _SocialRow(scheme: scheme),
          const SizedBox(height: AppSpacing.xl),
          _WorkingHoursCard(scheme: scheme),
        ],
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    value,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.content_copy_rounded,
              size: 18,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  final ColorScheme scheme;
  const _SocialRow({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialChip(icon: Icons.telegram, label: 'Telegram', color: const Color(0xFF0088CC), scheme: scheme),
        const SizedBox(width: AppSpacing.sm),
        _SocialChip(icon: Icons.camera_alt_rounded, label: 'Instagram', color: const Color(0xFFE4405F), scheme: scheme),
        const SizedBox(width: AppSpacing.sm),
        _SocialChip(icon: Icons.facebook_rounded, label: 'Facebook', color: const Color(0xFF1877F2), scheme: scheme),
      ],
    );
  }
}

class _SocialChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final ColorScheme scheme;

  const _SocialChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkingHoursCard extends StatelessWidget {
  final ColorScheme scheme;
  const _WorkingHoursCard({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_rounded, size: 20, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Working Hours',
                style: AppTextStyles.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _hourRow('Monday – Friday', '09:00 – 18:00', scheme),
          const SizedBox(height: AppSpacing.sm),
          _hourRow('Saturday', '10:00 – 16:00', scheme),
          const SizedBox(height: AppSpacing.sm),
          _hourRow('Sunday', 'Closed', scheme, isClosed: true),
        ],
      ),
    );
  }

  Widget _hourRow(String day, String hours, ColorScheme scheme, {bool isClosed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(day, style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface)),
        Text(
          hours,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isClosed ? AppColors.error : scheme.onSurfaceVariant,
            fontWeight: isClosed ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
  }
}
