import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/login_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/otp_input.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _DragHandle(),
            const SizedBox(height: 4),
            _buildHeader(context),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.enterOtp,
                style: AppTextStyles.headlineLarge,
              ),
            ),
            const SizedBox(height: 8),
            _buildSubtitle(),
            const SizedBox(height: 32),
            OtpInput(
              onChanged: (otp) {
                context.read<LoginBloc>().add(LoginOtpChanged(otp));
              },
              onCompleted: (_) {
                context.read<LoginBloc>().add(const LoginVerifyOtpRequested());
              },
            ),
            const SizedBox(height: 24),
            _buildResendTimer(),
            const SizedBox(height: 24),
            _buildConfirmButton(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.read<LoginBloc>().add(const LoginBackToPhoneRequested());
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.inputBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(36, 36),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close, size: 22),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.inputBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(36, 36),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (prev, curr) => prev.formattedPhone != curr.formattedPhone,
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '${AppStrings.otpSubtitle}\n${state.formattedPhone}',
            style: AppTextStyles.bodyMedium,
          ),
        );
      },
    );
  }

  Widget _buildResendTimer() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (prev, curr) =>
          prev.resendTimerSeconds != curr.resendTimerSeconds,
      builder: (context, state) {
        if (state.canResend) {
          return GestureDetector(
            onTap: () {
              context.read<LoginBloc>().add(const LoginResendOtpRequested());
            },
            child: Text(
              AppStrings.resendCode,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        return Text(
          '${AppStrings.resendCodeIn} ${state.timerDisplay}',
          style: AppTextStyles.timer,
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (prev, curr) =>
          prev.isOtpValid != curr.isOtpValid ||
          prev.status != curr.status,
      builder: (context, state) {
        return AuthButton(
          text: AppStrings.confirm,
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
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.dragHandle,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
