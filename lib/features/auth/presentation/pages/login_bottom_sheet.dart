import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/login_bloc.dart';
import '../widgets/agreement_text.dart';
import '../widgets/auth_button.dart';
import '../widgets/phone_input.dart';
import 'otp_page.dart';

Future<bool?> showLoginBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.bottomSheetBarrier,
    builder: (_) => BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: const _LoginBottomSheetShell(),
    ),
  );
}

class _LoginBottomSheetShell extends StatelessWidget {
  const _LoginBottomSheetShell();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pop(true);
        }
        if (state.status == LoginStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BlocBuilder<LoginBloc, LoginState>(
            buildWhen: (prev, curr) => prev.step != curr.step,
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  final isOtp = state.step == LoginStep.otp;
                  final offset = isOtp
                      ? Tween(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        )
                      : Tween(
                          begin: const Offset(-1, 0),
                          end: Offset.zero,
                        );
                  return SlideTransition(
                    position: offset.animate(animation),
                    child: child,
                  );
                },
                child: state.step == LoginStep.phone
                    ? const _PhoneScreen(key: ValueKey('phone'))
                    : const OtpPage(key: ValueKey('otp')),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PhoneScreen extends StatefulWidget {
  const _PhoneScreen({super.key});

  @override
  State<_PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<_PhoneScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
            _buildCloseRow(context),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppStrings.enterPhoneNumber,
                style: AppTextStyles.headlineLarge,
              ),
            ),
            const SizedBox(height: 24),
            PhoneInput(
              controller: _phoneController,
              onChanged: (value) {
                context.read<LoginBloc>().add(LoginPhoneNumberChanged(value));
              },
            ),
            const SizedBox(height: 24),
            BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (prev, curr) =>
                  prev.isPhoneValid != curr.isPhoneValid ||
                  prev.status != curr.status,
              builder: (context, state) {
                return AuthButton(
                  text: AppStrings.getCode,
                  isLoading: state.status == LoginStatus.loading,
                  onPressed: state.isPhoneValid
                      ? () => context
                          .read<LoginBloc>()
                          .add(const LoginSendOtpRequested())
                      : null,
                );
              },
            ),
            const SizedBox(height: 20),
            AgreementText(
              onPolicyTap: () => _openPrivacyPolicy(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseRow(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
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
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    // TODO: Open privacy policy URL via url_launcher
    debugPrint('Open: ${AppConstants.dataPolicyUrl}');
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
