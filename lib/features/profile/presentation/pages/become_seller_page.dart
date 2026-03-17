import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class BecomeSellerPage extends StatefulWidget {
  const BecomeSellerPage({super.key});

  @override
  State<BecomeSellerPage> createState() => _BecomeSellerPageState();
}

enum _SellerStep { intro, form, otp, done }

class _BecomeSellerPageState extends State<BecomeSellerPage> {
  _SellerStep _step = _SellerStep.intro;
  bool _loading = false;
  bool _agreedToTerms = false;

  final _nameCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _aboutCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  String _specialization = 'Women\'s Clothing';
  int _timerSeconds = 0;
  Timer? _timer;

  static const _specializations = [
    'Women\'s Clothing',
    'Men\'s Clothing',
    'Children\'s Clothing',
    'Evening & Formal Wear',
    'Traditional / National Wear',
    'Sportswear',
    'Accessories',
    'Other',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    _experienceCtrl.dispose();
    _aboutCtrl.dispose();
    _otpCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _goToForm() => setState(() => _step = _SellerStep.form);

  void _submitForm() {
    if (_nameCtrl.text.isEmpty || _cityCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please agree to the terms and conditions'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _step = _SellerStep.otp;
        _timerSeconds = 60;
      });
      _startTimer();
    });
  }

  void _verifyOtp() {
    if (_otpCtrl.text.length < 6) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _timer?.cancel();
      setState(() {
        _loading = false;
        _step = _SellerStep.done;
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
          'Become a Seller',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: switch (_step) {
        _SellerStep.intro => _buildIntro(scheme),
        _SellerStep.form => _buildForm(scheme),
        _SellerStep.otp => _buildOtp(scheme),
        _SellerStep.done => _buildDone(scheme),
      },
    );
  }

  // ── Intro ──

  Widget _buildIntro(ColorScheme scheme) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding.copyWith(
        top: AppSpacing.xl,
        bottom: AppSpacing.xxl,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Icon(Icons.storefront_rounded, size: 40, color: scheme.primary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Start Earning With\nYour Talent',
            style: AppTextStyles.displayMedium.copyWith(color: scheme.onSurface),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Join our tailor network. Sew clothing for customers '
            'and earn 40% from every sale.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _BenefitCard(
            icon: Icons.payments_outlined,
            title: '40% Revenue Share',
            description: 'You earn 40% from every custom order you complete. '
                'Payments are processed weekly to your bank account.',
            scheme: scheme,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.md),
          _BenefitCard(
            icon: Icons.shopping_bag_outlined,
            title: 'We Find Customers',
            description: 'We handle marketing, customer acquisition, and order management. '
                'You focus on what you do best — sewing.',
            scheme: scheme,
            color: AppColors.info,
          ),
          const SizedBox(height: AppSpacing.md),
          _BenefitCard(
            icon: Icons.local_shipping_outlined,
            title: 'Materials & Delivery',
            description: 'We supply fabrics and materials. Once complete, '
                'we handle packaging and delivery to the customer.',
            scheme: scheme,
            color: AppColors.accent,
          ),
          const SizedBox(height: AppSpacing.md),
          _BenefitCard(
            icon: Icons.schedule_rounded,
            title: 'Flexible Schedule',
            description: 'Accept orders that fit your schedule. '
                'Work from your own studio or workshop.',
            scheme: scheme,
            color: AppColors.warning,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _buildHowItWorks(scheme),
          const SizedBox(height: AppSpacing.xxl),
          _buildEarningsExample(scheme),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              onPressed: _goToForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                elevation: 0,
              ),
              child: Text(
                'Apply Now',
                style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks(ColorScheme scheme) {
    const steps = [
      (Icons.app_registration_rounded, 'Apply', 'Fill out the form with your details'),
      (Icons.verified_outlined, 'Get Verified', 'Our team reviews your application'),
      (Icons.content_cut_rounded, 'Receive Orders', 'Start getting custom orders from customers'),
      (Icons.payments_outlined, 'Get Paid', 'Earn 40% for each completed order'),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.base),
          ...steps.asMap().entries.map((e) {
            final isLast = e.key == steps.length - 1;
            final s = e.value;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.base),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(s.$1, size: 18, color: scheme.primary),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 24,
                          color: scheme.outline,
                        ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${e.key + 1}. ${s.$2}',
                          style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          s.$3,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEarningsExample(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.08),
            AppColors.success.withValues(alpha: 0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate_outlined, size: 20, color: AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Earnings Example',
                style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          _EarningsRow(label: 'Customer pays for a dress', value: '450 000 UZS', scheme: scheme),
          _EarningsRow(label: 'Your share (40%)', value: '180 000 UZS', scheme: scheme, highlight: true),
          _EarningsRow(label: 'Platform fee (60%)', value: '270 000 UZS', scheme: scheme),
          const Divider(height: AppSpacing.xl),
          _EarningsRow(label: '10 orders per month', value: '', scheme: scheme),
          _EarningsRow(
            label: 'Monthly earnings',
            value: '~1 800 000 UZS',
            scheme: scheme,
            highlight: true,
            bold: true,
          ),
        ],
      ),
    );
  }

  // ── Form ──

  Widget _buildForm(ColorScheme scheme) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: AppSpacing.screenPadding.copyWith(
              top: AppSpacing.base,
              bottom: AppSpacing.xl,
            ),
            children: [
              Text(
                'Tell us about yourself',
                style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Fill in your details so we can process your application.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildTextField(
                scheme,
                controller: _nameCtrl,
                label: 'Full Name *',
                hint: 'Your full name',
                icon: Icons.person_outline_rounded,
              ),
              _buildTextField(
                scheme,
                controller: _cityCtrl,
                label: 'City *',
                hint: 'e.g. Tashkent, Samarkand...',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Specialization',
                style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _specializations.map((s) {
                  final selected = s == _specialization;
                  return GestureDetector(
                    onTap: () => setState(() => _specialization = s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? scheme.primary : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(
                          color: selected ? scheme.primary : scheme.outline,
                        ),
                      ),
                      child: Text(
                        s,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: selected ? scheme.onPrimary : scheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildTextField(
                scheme,
                controller: _experienceCtrl,
                label: 'Years of Experience',
                hint: 'e.g. 5',
                icon: Icons.work_outline_rounded,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                scheme,
                controller: _aboutCtrl,
                label: 'About You',
                hint: 'Describe your skills, equipment, and what makes you stand out...',
                icon: Icons.info_outline_rounded,
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.md),
              GestureDetector(
                onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _agreedToTerms ? scheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                        border: Border.all(
                          color: _agreedToTerms ? scheme.primary : scheme.outline,
                          width: 2,
                        ),
                      ),
                      child: _agreedToTerms
                          ? Icon(Icons.check, size: 14, color: scheme.onPrimary)
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'I agree to the Seller Terms & Conditions, including '
                        'the 40/60 revenue sharing model and production standards.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding.copyWith(
              top: AppSpacing.md,
              bottom: AppSpacing.md,
            ),
            child: SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitForm,
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
                        'Submit Application',
                        style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    ColorScheme scheme, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: scheme.outline),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppSpacing.base),
                prefixIcon: maxLines == 1
                    ? Icon(icon, color: scheme.primary, size: 20)
                    : null,
              ),
              style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  // ── OTP ──

  Widget _buildOtp(ColorScheme scheme) {
    return Padding(
      padding: AppSpacing.screenPadding.copyWith(
        top: AppSpacing.xl,
        bottom: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sms_outlined, size: 48, color: scheme.primary),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Verify your identity',
            style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'We sent a 6-digit code to your registered phone number. '
            'Enter it below to complete your seller application.',
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
              controller: _otpCtrl,
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
                    style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                  )
                : GestureDetector(
                    onTap: _resendCode,
                    child: Text(
                      'Resend code',
                      style: AppTextStyles.labelMedium.copyWith(color: scheme.primary),
                    ),
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              onPressed: _otpCtrl.text.length == 6 && !_loading ? _verifyOtp : null,
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
                      'Verify & Submit',
                      style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Done ──

  Widget _buildDone(ColorScheme scheme) {
    return Center(
      child: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded, color: AppColors.success, size: 48),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Application Submitted!',
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Thank you, ${_nameCtrl.text}! Your application to become a seller '
              'has been received. Our team will review it within 1–3 business days.\n\n'
              'You will receive an SMS notification once your account is approved.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: scheme.outline),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Application',
                    style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SummaryLine(label: 'Name', value: _nameCtrl.text, scheme: scheme),
                  _SummaryLine(label: 'City', value: _cityCtrl.text, scheme: scheme),
                  _SummaryLine(label: 'Specialization', value: _specialization, scheme: scheme),
                  if (_experienceCtrl.text.isNotEmpty)
                    _SummaryLine(
                      label: 'Experience',
                      value: '${_experienceCtrl.text} years',
                      scheme: scheme,
                    ),
                  _SummaryLine(label: 'Revenue Share', value: '40%', scheme: scheme),
                ],
              ),
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
                  style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Widgets ──

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final ColorScheme scheme;
  final Color color;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.scheme,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningsRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;
  final bool highlight;
  final bool bold;

  const _EarningsRow({
    required this.label,
    required this.value,
    required this.scheme,
    this.highlight = false,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (bold ? AppTextStyles.titleSmall : AppTextStyles.bodySmall).copyWith(
              color: scheme.onSurface,
            ),
          ),
          if (value.isNotEmpty)
            Text(
              value,
              style: (bold ? AppTextStyles.titleSmall : AppTextStyles.bodySmall).copyWith(
                color: highlight ? AppColors.success : scheme.onSurface,
                fontWeight: highlight || bold ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;

  const _SummaryLine({required this.label, required this.value, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
