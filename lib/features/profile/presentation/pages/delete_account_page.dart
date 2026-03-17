import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

enum _DeleteStep { confirm, smsVerify, deleting }

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _otpController = TextEditingController();
  _DeleteStep _step = _DeleteStep.confirm;
  bool _loading = false;
  int _timerSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _sendSms() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _step = _DeleteStep.smsVerify;
        _timerSeconds = 60;
      });
      _startTimer();
    });
  }

  void _verifyAndDelete() {
    if (_otpController.text.length < 6) return;
    setState(() {
      _loading = true;
      _step = _DeleteStep.deleting;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _timer?.cancel();
      context.go('/');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(
              'Your account has been deleted. We\'re sorry to see you go.',
            ),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
          ),
        );
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  void _resendCode() {
    setState(() => _timerSeconds = 60);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Account',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.xl,
          bottom: AppSpacing.xxl,
        ),
        child: switch (_step) {
          _DeleteStep.confirm => _buildConfirm(scheme),
          _DeleteStep.smsVerify => _buildSmsVerify(scheme),
          _DeleteStep.deleting => _buildDeleting(scheme),
        },
      ),
    );
  }

  Widget _buildConfirm(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Icon(
            Icons.warning_amber_rounded,
            size: 32,
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Are you sure?',
          style: AppTextStyles.titleLarge.copyWith(
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Deleting your account is permanent and cannot be undone. You will lose:',
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        _WarningItem(text: 'All your order history', scheme: scheme),
        _WarningItem(text: 'Saved favorites and wishlist', scheme: scheme),
        _WarningItem(text: 'Chat messages with sellers', scheme: scheme),
        _WarningItem(text: 'Active promo codes and bonuses', scheme: scheme),
        _WarningItem(text: 'Your profile and personal data', scheme: scheme),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: _loading ? null : _sendSms,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              elevation: 0,
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Continue with Deletion',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.onSurface,
              side: BorderSide(color: scheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmsVerify(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.sms_outlined,
          size: 48,
          color: AppColors.error,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Verify it\'s you',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We sent a verification code to your registered phone number. Enter it below to confirm account deletion.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              hintText: '------',
              hintStyle: AppTextStyles.displayMedium.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
                letterSpacing: 8,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.md,
              ),
            ),
            style: AppTextStyles.displayMedium.copyWith(
              color: scheme.onSurface,
              letterSpacing: 8,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: _timerSeconds > 0
              ? Text(
                  'Resend code in ${_timerSeconds}s',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                )
              : GestureDetector(
                  onTap: _resendCode,
                  child: Text(
                    'Resend code',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: _otpController.text.length == 6 && !_loading
                ? _verifyAndDelete
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              disabledBackgroundColor: scheme.outline,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              elevation: 0,
            ),
            child: Text(
              'Delete My Account',
              style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.onSurface,
              side: BorderSide(color: scheme.outline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleting(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Deleting your account...',
            style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Please wait while we process your request.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningItem extends StatelessWidget {
  final String text;
  final ColorScheme scheme;

  const _WarningItem({required this.text, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Icon(
            Icons.remove_circle_outline_rounded,
            size: 18,
            color: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
