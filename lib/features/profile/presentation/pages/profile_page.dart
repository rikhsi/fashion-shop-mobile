import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/settings/app_settings_cubit.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../auth/presentation/pages/login_bottom_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.profile,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.lg),
          _LoginBanner(tr: tr, scheme: scheme),
          const SizedBox(height: AppSpacing.xxl),
          _SettingsSection(tr: tr, scheme: scheme),
        ],
      ),
    );
  }
}

class _LoginBanner extends StatelessWidget {
  final AppLocalizations tr;
  final ColorScheme scheme;

  const _LoginBanner({required this.tr, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_outline, size: 36, color: scheme.primary),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          tr.loginToAccount,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          tr.loginDescription,
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          text: tr.login,
          onPressed: () => showLoginBottomSheet(context),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final AppLocalizations tr;
  final ColorScheme scheme;

  const _SettingsSection({required this.tr, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.settings,
          style: AppTextStyles.titleMedium.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.base),
        _ThemeTile(tr: tr, scheme: scheme),
        const Divider(height: 1),
        _LanguageTile(tr: tr, scheme: scheme),
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final AppLocalizations tr;
  final ColorScheme scheme;

  const _ThemeTile({required this.tr, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettings>(
      builder: (context, settings) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.palette_outlined, color: scheme.onSurfaceVariant),
          title: Text(tr.theme, style: AppTextStyles.bodyLarge),
          trailing: SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.light,
                icon: const Icon(Icons.light_mode_outlined, size: 18),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                icon: const Icon(Icons.phone_android_outlined, size: 18),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: const Icon(Icons.dark_mode_outlined, size: 18),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (s) =>
                context.read<AppSettingsCubit>().setThemeMode(s.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        );
      },
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final AppLocalizations tr;
  final ColorScheme scheme;

  const _LanguageTile({required this.tr, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettings>(
      builder: (context, settings) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.language_rounded,
            color: scheme.onSurfaceVariant,
          ),
          title: Text(tr.language, style: AppTextStyles.bodyLarge),
          trailing: DropdownButton<AppLocale>(
            value: settings.locale,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            items: AppLocale.values
                .map((l) => DropdownMenuItem(
                      value: l,
                      child: Text(l.label, style: AppTextStyles.bodyMedium),
                    ))
                .toList(),
            onChanged: (l) {
              if (l != null) context.read<AppSettingsCubit>().setLocale(l);
            },
          ),
        );
      },
    );
  }
}
