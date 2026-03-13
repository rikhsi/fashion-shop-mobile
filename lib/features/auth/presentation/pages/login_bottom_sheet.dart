import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/login_bloc.dart';
import '../widgets/agreement_text.dart';
import '../widgets/phone_input.dart';
import 'otp_page.dart';

Future<bool?> showLoginBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
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
    final scheme = Theme.of(context).colorScheme;

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
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              margin: const EdgeInsets.all(AppSpacing.base),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXxl),
          ),
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
                  final offset = Tween(
                    begin: Offset(isOtp ? 1 : -1, 0),
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
            _buildCloseRow(context, scheme),
            const SizedBox(height: AppSpacing.base),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tr.enterPhoneNumber,
                style: AppTextStyles.displayMedium.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            PhoneInput(
              controller: _phoneController,
              onChanged: (v) {
                context.read<LoginBloc>().add(LoginPhoneNumberChanged(v));
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (p, c) =>
                  p.isPhoneValid != c.isPhoneValid ||
                  p.status != c.status,
              builder: (context, state) {
                return PrimaryButton(
                  text: tr.getCode,
                  isLoading: state.status == LoginStatus.loading,
                  onPressed: state.isPhoneValid
                      ? () => context
                          .read<LoginBloc>()
                          .add(const LoginSendOtpRequested())
                      : null,
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AgreementText(
              onPolicyTap: () =>
                  debugPrint('Open: ${AppConstants.dataPolicyUrl}'),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseRow(BuildContext context, ColorScheme scheme) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: scheme.outlineVariant,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
          ),
          child: Icon(Icons.close, size: 20, color: scheme.onSurfaceVariant),
        ),
      ),
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
