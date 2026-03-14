import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/settings/app_settings_cubit.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_menu_tile.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../auth/presentation/pages/login_bottom_sheet.dart';
import '../cubit/profile_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!state.isAuthenticated) {
          return _GuestProfileView(tr: tr);
        }

        return _AuthenticatedProfileView(state: state, tr: tr);
      },
    );
  }
}

// ─── Guest view ──────────────────────────────────────────────────────────────

class _GuestProfileView extends StatelessWidget {
  final AppLocalizations tr;

  const _GuestProfileView({required this.tr});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.xl,
          ),
          children: [
            const SizedBox(height: AppSpacing.xxl),
            Container(
              width: AppSpacing.avatarLg,
              height: AppSpacing.avatarLg,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline_rounded,
                size: 36,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              tr.loginToAccount,
              style: AppTextStyles.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
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
              onPressed: () async {
                final auth = await showLoginBottomSheet(context);
                if (auth != null && context.mounted) {
                  context.read<ProfileCubit>().onAuthenticated(auth);
                }
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            _SettingsCard(tr: tr),
          ],
        ),
      ),
    );
  }
}

// ─── Authenticated view with collapsible header ──────────────────────────────

class _AuthenticatedProfileView extends StatelessWidget {
  final ProfileState state;
  final AppLocalizations tr;

  const _AuthenticatedProfileView({required this.state, required this.tr});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: scheme.surface,
            title: Text(
              tr.profile,
              style: AppTextStyles.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => context.push('/profile/edit'),
                icon: const Icon(Icons.edit_outlined),
                tooltip: tr.editProfile,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.base,
                      0,
                      AppSpacing.base,
                      AppSpacing.base,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: AppSpacing.avatarMd / 2,
                          backgroundColor: scheme.primaryContainer,
                          child: Icon(
                            Icons.person_rounded,
                            size: AppSpacing.iconLg,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.isNewUser
                                    ? tr.newUserName
                                    : tr.defaultUserName,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: scheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                state.phoneNumber.isEmpty
                                    ? tr.phonePlaceholder
                                    : state.phoneNumber,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                AppSpacing.sm,
                AppSpacing.base,
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  _MenuSection(tr: tr),
                  const SizedBox(height: AppSpacing.base),
                  _SettingsCard(tr: tr),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Menu section ────────────────────────────────────────────────────────────

class _MenuSection extends StatelessWidget {
  final AppLocalizations tr;

  const _MenuSection({required this.tr});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        children: [
          AppMenuTile(
            icon: Icons.receipt_long_outlined,
            title: tr.myOrders,
            onTap: () => context.push('/profile/orders'),
          ),
          Divider(height: 0, color: scheme.outline),
          AppMenuTile(
            icon: Icons.rate_review_outlined,
            title: tr.myReviews,
            onTap: () => context.push('/profile/reviews'),
          ),
          Divider(height: 0, color: scheme.outline),
          AppMenuTile(
            icon: Icons.storefront_outlined,
            title: tr.becomeASeller,
            onTap: () => context.push('/profile/seller'),
          ),
          Divider(height: 0, color: scheme.outline),
          AppMenuTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: tr.myChats,
            onTap: () => context.push('/profile/chats'),
          ),
          Divider(height: 0, color: scheme.outline),
          AppMenuTile(
            icon: Icons.notifications_none_rounded,
            title: tr.notifications,
            onTap: () => context.push('/profile/notifications'),
          ),
          Divider(height: 0, color: scheme.outline),
          AppMenuTile(
            icon: Icons.discount_outlined,
            title: tr.myPromoCodes,
            onTap: () => context.push('/profile/promo-codes'),
          ),
          Divider(height: 0, color: scheme.outline),
          AppMenuTile(
            icon: Icons.settings_outlined,
            title: tr.settings,
            onTap: () => context.push('/profile/settings'),
          ),
          Divider(height: 0, color: scheme.outline),
          AppMenuTile(
            icon: Icons.support_agent_outlined,
            title: tr.contactUs,
            onTap: () => context.push('/profile/contact'),
          ),
        ],
      ),
    );
  }
}

// ─── Settings (theme + language) ─────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final AppLocalizations tr;

  const _SettingsCard({required this.tr});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        children: [
          _ThemeToggleTile(tr: tr),
          Divider(height: 0, color: scheme.outline),
          _LanguageTile(tr: tr),
        ],
      ),
    );
  }
}

class _ThemeToggleTile extends StatelessWidget {
  final AppLocalizations tr;

  const _ThemeToggleTile({required this.tr});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<AppSettingsCubit, AppSettings>(
      builder: (context, settings) {
        final isDark = settings.themeMode == ThemeMode.dark;
        return AppMenuTile(
          icon: Icons.dark_mode_outlined,
          title: tr.theme,
          subtitle: Text(
            isDark ? tr.darkMode : tr.lightMode,
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          trailing: Switch(
            value: isDark,
            onChanged: (value) {
              context.read<AppSettingsCubit>().setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),
        );
      },
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final AppLocalizations tr;

  const _LanguageTile({required this.tr});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<AppSettingsCubit, AppSettings>(
      builder: (context, settings) {
        return AppMenuTile(
          icon: Icons.language_rounded,
          title: tr.language,
          trailing: DropdownButton<AppLocale>(
            value: settings.locale,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            isDense: true,
            items: AppLocale.values
                .map(
                  (locale) => DropdownMenuItem<AppLocale>(
                    value: locale,
                    child: Text(
                      locale.label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (next) {
              if (next != null) {
                context.read<AppSettingsCubit>().setLocale(next);
              }
            },
          ),
        );
      },
    );
  }
}
