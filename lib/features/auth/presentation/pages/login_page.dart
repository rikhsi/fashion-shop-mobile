import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../bloc/login_bloc.dart';
import '../widgets/otp_input_field.dart';
import '../widgets/phone_input_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: _loginListener,
          builder: (context, state) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.step == LoginStep.phone
                  ? _PhoneStepBody(key: const ValueKey('phone'), state: state)
                  : _OtpStepBody(key: const ValueKey('otp'), state: state),
            );
          },
        ),
      ),
    );
  }

  void _loginListener(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.failure && state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    if (state.status == LoginStatus.success) {
      // TODO: Navigate to home page
    }
  }
}

class _PhoneStepBody extends StatefulWidget {
  final LoginState state;

  const _PhoneStepBody({super.key, required this.state});

  @override
  State<_PhoneStepBody> createState() => _PhoneStepBodyState();
}

class _PhoneStepBodyState extends State<_PhoneStepBody> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          _buildLogo(),
          const SizedBox(height: 40),
          const Text(
            AppStrings.welcomeBack,
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.loginSubtitle,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 40),
          PhoneInputField(
            controller: _phoneController,
            countryCode: widget.state.countryCode,
            onChanged: (value) {
              context.read<LoginBloc>().add(LoginPhoneNumberChanged(value));
            },
            errorText: widget.state.status == LoginStatus.failure
                ? widget.state.errorMessage
                : null,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: AppStrings.sendCode,
            isLoading: widget.state.status == LoginStatus.loading,
            onPressed: widget.state.isPhoneValid
                ? () => context
                    .read<LoginBloc>()
                    .add(const LoginSendOtpRequested())
                : null,
          ),
          const Spacer(),
          _buildFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'Fashion Shop',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _OtpStepBody extends StatelessWidget {
  final LoginState state;

  const _OtpStepBody({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildBackButton(context),
          const SizedBox(height: 32),
          const Text(
            AppStrings.enterOtp,
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Code sent to ${state.countryCode} ${state.phoneNumber}',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 40),
          OtpInputField(
            onChanged: (otp) {
              context.read<LoginBloc>().add(LoginOtpChanged(otp));
            },
            onCompleted: (_) {
              context.read<LoginBloc>().add(const LoginVerifyOtpRequested());
            },
          ),
          const SizedBox(height: 32),
          AppButton(
            text: AppStrings.verify,
            isLoading: state.status == LoginStatus.loading,
            onPressed: state.isOtpValid
                ? () => context
                    .read<LoginBloc>()
                    .add(const LoginVerifyOtpRequested())
                : null,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                context.read<LoginBloc>().add(const LoginSendOtpRequested());
              },
              child: Text(
                AppStrings.resendCode,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<LoginBloc>().add(const LoginBackToPhoneRequested());
      },
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.inputBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
