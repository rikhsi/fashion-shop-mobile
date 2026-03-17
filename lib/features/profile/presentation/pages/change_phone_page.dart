import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class ChangePhonePage extends StatefulWidget {
  const ChangePhonePage({super.key});

  @override
  State<ChangePhonePage> createState() => _ChangePhonePageState();
}

enum _Step { enterNew, verifyOtp, done }

class _ChangePhonePageState extends State<ChangePhonePage> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  _Step _step = _Step.enterNew;
  bool _loading = false;
  int _timerSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  bool get _isPhoneValid {
    final digits = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length >= 9;
  }

  void _sendCode() {
    if (!_isPhoneValid) return;
    setState(() => _loading = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _step = _Step.verifyOtp;
        _timerSeconds = 60;
      });
      _startTimer();
    });
  }

  void _verifyCode() {
    if (_otpController.text.length < 6) return;
    setState(() => _loading = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _timer?.cancel();
      setState(() {
        _loading = false;
        _step = _Step.done;
      });
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
          'Change Phone Number',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.xl,
          bottom: AppSpacing.xxl,
        ),
        child: switch (_step) {
          _Step.enterNew => _buildEnterPhone(scheme),
          _Step.verifyOtp => _buildVerifyOtp(scheme),
          _Step.done => _buildDone(scheme),
        },
      ),
    );
  }

  Widget _buildEnterPhone(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.phone_android_rounded,
          size: 48,
          color: scheme.primary,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Enter new phone number',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We will send a verification code to this number to confirm the change.',
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: scheme.outline),
                  ),
                ),
                child: Text(
                  '+998',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  decoration: InputDecoration(
                    hintText: '00 000 00 00',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  style: AppTextStyles.titleSmall.copyWith(
                    color: scheme.onSurface,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: _isPhoneValid && !_loading ? _sendCode : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              disabledBackgroundColor: scheme.outline,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              elevation: 0,
            ),
            child: _loading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.onPrimary,
                    ),
                  )
                : Text(
                    'Send Code',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: scheme.onPrimary,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyOtp(ColorScheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.sms_outlined,
          size: 48,
          color: scheme.primary,
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          'Enter verification code',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'We sent a 6-digit code to +998 ${_phoneController.text}',
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
            onPressed:
                _otpController.text.length == 6 && !_loading ? _verifyCode : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              disabledBackgroundColor: scheme.outline,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              elevation: 0,
            ),
            child: _loading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.onPrimary,
                    ),
                  )
                : Text(
                    'Verify',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: scheme.onPrimary,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDone(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF22C55E),
              size: 48,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Phone number changed!',
            style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your phone number has been updated to\n+998 ${_phoneController.text}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                elevation: 0,
              ),
              child: Text(
                'Done',
                style: AppTextStyles.labelLarge.copyWith(
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
