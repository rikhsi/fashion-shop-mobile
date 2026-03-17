import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/settings/app_settings_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/animations/app_page_route.dart';
import 'change_phone_page.dart';
import 'delete_account_page.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return BlocBuilder<AppSettingsCubit, AppSettings>(
      builder: (context, settings) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              tr.settings,
              style: AppTextStyles.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ),
          body: ListView(
            padding: AppSpacing.screenPadding.copyWith(
              top: AppSpacing.sm,
              bottom: AppSpacing.xxl,
            ),
            children: [
              _SectionHeader(title: 'Appearance', scheme: scheme),
              const SizedBox(height: AppSpacing.sm),
              _buildThemeCard(context, scheme, settings, tr),
              const SizedBox(height: AppSpacing.base),
              _SectionHeader(title: tr.language, scheme: scheme),
              const SizedBox(height: AppSpacing.sm),
              _buildLanguageCard(context, scheme, settings),
              const SizedBox(height: AppSpacing.base),
              _SectionHeader(title: tr.notifications, scheme: scheme),
              const SizedBox(height: AppSpacing.sm),
              _buildNotificationsCard(scheme),
              const SizedBox(height: AppSpacing.base),
              _SectionHeader(title: 'Privacy & Security', scheme: scheme),
              const SizedBox(height: AppSpacing.sm),
              _buildPrivacyCard(context, scheme),
              const SizedBox(height: AppSpacing.base),
              _SectionHeader(title: 'About', scheme: scheme),
              const SizedBox(height: AppSpacing.sm),
              _buildAboutCard(context, scheme),
              const SizedBox(height: AppSpacing.xl),
              _buildLogoutButton(context, scheme),
              const SizedBox(height: AppSpacing.md),
              _buildDeleteAccountButton(context, scheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    ColorScheme scheme,
    AppSettings settings,
    AppLocalizations tr,
  ) {
    final cubit = context.read<AppSettingsCubit>();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.theme,
            style: AppTextStyles.titleSmall.copyWith(
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _ThemeOption(
                icon: Icons.light_mode_rounded,
                label: tr.lightMode,
                isSelected: settings.themeMode == ThemeMode.light,
                scheme: scheme,
                onTap: () => cubit.setThemeMode(ThemeMode.light),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ThemeOption(
                icon: Icons.dark_mode_rounded,
                label: tr.darkMode,
                isSelected: settings.themeMode == ThemeMode.dark,
                scheme: scheme,
                onTap: () => cubit.setThemeMode(ThemeMode.dark),
              ),
              const SizedBox(width: AppSpacing.sm),
              _ThemeOption(
                icon: Icons.settings_brightness_rounded,
                label: tr.systemMode,
                isSelected: settings.themeMode == ThemeMode.system,
                scheme: scheme,
                onTap: () => cubit.setThemeMode(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    ColorScheme scheme,
    AppSettings settings,
  ) {
    final cubit = context.read<AppSettingsCubit>();

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: AppLocale.values.map((locale) {
          final isSelected = settings.locale == locale;
          return InkWell(
            onTap: () => cubit.setLocale(locale),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                border: locale != AppLocale.values.last
                    ? Border(
                        bottom: BorderSide(
                          color: scheme.outline.withValues(alpha: 0.5),
                        ),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Text(
                    _localeFlag(locale),
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      locale.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: scheme.primary,
                      size: 22,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationsCard(ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          _SettingsSwitch(
            icon: Icons.shopping_bag_outlined,
            label: 'Order updates',
            value: true,
            scheme: scheme,
            showBorder: true,
          ),
          _SettingsSwitch(
            icon: Icons.local_offer_outlined,
            label: 'Promotions & sales',
            value: true,
            scheme: scheme,
            showBorder: true,
          ),
          _SettingsSwitch(
            icon: Icons.trending_down_rounded,
            label: 'Price drops',
            value: true,
            scheme: scheme,
            showBorder: true,
          ),
          _SettingsSwitch(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat messages',
            value: true,
            scheme: scheme,
            showBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard(BuildContext context, ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.phone_outlined,
            label: 'Change Phone Number',
            scheme: scheme,
            showBorder: true,
            onTap: () => Navigator.push(
              context,
              appSlideRoute(const ChangePhonePage()),
            ),
          ),
          _SettingsTile(
            icon: Icons.shield_outlined,
            label: 'Privacy Policy',
            scheme: scheme,
            showBorder: true,
            onTap: () => Navigator.push(
              context,
              appSlideRoute(const PrivacyPolicyPage()),
            ),
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            label: 'Terms of Service',
            scheme: scheme,
            showBorder: false,
            onTap: () => Navigator.push(
              context,
              appSlideRoute(const TermsOfServicePage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context, ColorScheme scheme) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            label: 'App Version',
            trailing: Text(
              '1.0.0',
              style: AppTextStyles.bodySmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            scheme: scheme,
            showBorder: true,
          ),
          _SettingsTile(
            icon: Icons.star_outline_rounded,
            label: 'Rate the App',
            scheme: scheme,
            showBorder: true,
            onTap: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Thank you! Opening store page...'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
          ),
          _SettingsTile(
            icon: Icons.share_outlined,
            label: 'Share with Friends',
            scheme: scheme,
            showBorder: true,
            onTap: () {
              Share.share(
                'Check out Fashion Shop — the best place to find trendy clothes!\n\nhttps://fashionshop.uz/download',
              );
            },
          ),
          _SettingsTile(
            icon: Icons.delete_sweep_outlined,
            label: 'Clear Cache',
            scheme: scheme,
            showBorder: false,
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear Cache'),
                  content: const Text(
                    'This will clear all cached images and temporary data. Your account data will not be affected.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        imageCache.clear();
                        imageCache.clearLiveImages();
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text('Cache cleared successfully'),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Log Out'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
        icon: Icon(Icons.logout_rounded, color: AppColors.error),
        label: Text(
          'Log Out',
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context, ColorScheme scheme) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: TextButton.icon(
        onPressed: () => Navigator.push(
          context,
          appSlideRoute(const DeleteAccountPage()),
        ),
        icon: Icon(
          Icons.person_remove_outlined,
          color: scheme.onSurfaceVariant,
          size: 20,
        ),
        label: Text(
          'Delete Account',
          style: AppTextStyles.labelLarge.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  String _localeFlag(AppLocale locale) {
    return switch (locale) {
      AppLocale.en => '\u{1F1EC}\u{1F1E7}',
      AppLocale.ru => '\u{1F1F7}\u{1F1FA}',
      AppLocale.uz => '\u{1F1FA}\u{1F1FF}',
    };
  }
}

// ── Section Header ──

class _SectionHeader extends StatelessWidget {
  final String title;
  final ColorScheme scheme;

  const _SectionHeader({required this.title, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs, top: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(
          color: scheme.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Theme option pill ──

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final ColorScheme scheme;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.scheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? scheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            border: Border.all(
              color: isSelected ? scheme.primary : scheme.outline,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color:
                      isSelected ? scheme.primary : scheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Settings tile with arrow ──

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme scheme;
  final bool showBorder;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.scheme,
    required this.showBorder,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          border: showBorder
              ? Border(
                  bottom: BorderSide(
                    color: scheme.outline.withValues(alpha: 0.5),
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: scheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Settings switch toggle ──

class _SettingsSwitch extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ColorScheme scheme;
  final bool showBorder;

  const _SettingsSwitch({
    required this.icon,
    required this.label,
    required this.value,
    required this.scheme,
    required this.showBorder,
  });

  @override
  State<_SettingsSwitch> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<_SettingsSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        border: widget.showBorder
            ? Border(
                bottom: BorderSide(
                  color: widget.scheme.outline.withValues(alpha: 0.5),
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 20, color: widget.scheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              widget.label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: widget.scheme.onSurface,
              ),
            ),
          ),
          Switch.adaptive(
            value: _value,
            onChanged: (v) => setState(() => _value = v),
            activeColor: widget.scheme.primary,
          ),
        ],
      ),
    );
  }
}
