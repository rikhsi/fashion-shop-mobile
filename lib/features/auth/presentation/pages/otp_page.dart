import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/login_bloc.dart';
import '../widgets/otp_input.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _DragHandle(),
            const SizedBox(height: AppSpacing.xs),
            _buildHeader(context, scheme),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tr.enterOtp,
                style: AppTextStyles.displayMedium.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildSubtitle(scheme, tr),
            const SizedBox(height: AppSpacing.xxl),
            OtpInput(
              onChanged: (otp) {
                context.read<LoginBloc>().add(LoginOtpChanged(otp));
              },
              onCompleted: (_) {
                context
                    .read<LoginBloc>()
                    .add(const LoginVerifyOtpRequested());
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildResendTimer(scheme, tr),
            const SizedBox(height: AppSpacing.xl),
            _buildConfirmButton(tr),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme scheme) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context
              .read<LoginBloc>()
              .add(const LoginBackToPhoneRequested()),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.outlineVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.outlineVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
            ),
            child: Icon(
              Icons.close,
              size: 20,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(ColorScheme scheme, AppLocalizations tr) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p, c) => p.formattedPhone != c.formattedPhone,
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${tr.otpSubtitle}\n${state.formattedPhone}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        );
      },
    );
  }

  Widget _buildResendTimer(ColorScheme scheme, AppLocalizations tr) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p, c) => p.resendTimerSeconds != c.resendTimerSeconds,
      builder: (context, state) {
        if (state.canResend) {
          return GestureDetector(
            onTap: () => context
                .read<LoginBloc>()
                .add(const LoginResendOtpRequested()),
            child: Text(
              tr.resendCode,
              style: AppTextStyles.titleSmall.copyWith(
                color: scheme.primary,
              ),
            ),
          );
        }
        return Text(
          '${tr.resendCodeIn} ${state.timerDisplay}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton(AppLocalizations tr) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p, c) =>
          p.isOtpValid != c.isOtpValid || p.status != c.status,
      builder: (context, state) {
        return PrimaryButton(
          text: tr.confirm,
          isLoading: state.status == LoginStatus.loading,
          onPressed: state.isOtpValid
              ? () => context
                  .read<LoginBloc>()
                  .add(const LoginVerifyOtpRequested())
              : null,
        );
      },
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
