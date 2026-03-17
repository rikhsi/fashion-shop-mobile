import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/mocks/mock_custom_orders.dart';

class BodyMeasurementsPage extends StatefulWidget {
  const BodyMeasurementsPage({super.key});

  @override
  State<BodyMeasurementsPage> createState() => _BodyMeasurementsPageState();
}

class _BodyMeasurementsPageState extends State<BodyMeasurementsPage> {
  late final Map<String, TextEditingController> _controllers;
  bool _saved = false;

  static const _fields = [
    ('height', 'Height', 'cm', Icons.height_rounded),
    ('weight', 'Weight', 'kg', Icons.monitor_weight_outlined),
    ('chest', 'Chest', 'cm', Icons.accessibility_new_rounded),
    ('waist', 'Waist', 'cm', Icons.straighten_rounded),
    ('hips', 'Hips', 'cm', Icons.circle_outlined),
    ('shoulderWidth', 'Shoulder Width', 'cm', Icons.open_with_rounded),
    ('armLength', 'Arm Length', 'cm', Icons.back_hand_outlined),
    ('legLength', 'Leg Length', 'cm', Icons.directions_walk_rounded),
    ('neckCirc', 'Neck Circumference', 'cm', Icons.radio_button_unchecked),
  ];

  @override
  void initState() {
    super.initState();
    final m = MockCustomOrders.savedMeasurements;
    _controllers = {
      'height': TextEditingController(text: m.height?.toString() ?? ''),
      'weight': TextEditingController(text: m.weight?.toString() ?? ''),
      'chest': TextEditingController(text: m.chest?.toString() ?? ''),
      'waist': TextEditingController(text: m.waist?.toString() ?? ''),
      'hips': TextEditingController(text: m.hips?.toString() ?? ''),
      'shoulderWidth': TextEditingController(
        text: m.shoulderWidth?.toString() ?? '',
      ),
      'armLength': TextEditingController(text: m.armLength?.toString() ?? ''),
      'legLength': TextEditingController(text: m.legLength?.toString() ?? ''),
      'neckCirc': TextEditingController(text: m.neckCirc?.toString() ?? ''),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    setState(() => _saved = true);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Measurements saved'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Measurements',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: ListView(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.base,
          bottom: AppSpacing.xxl + 80,
        ),
        children: [
          _buildInfoBanner(scheme),
          const SizedBox(height: AppSpacing.xl),
          _buildBodyVisual(scheme),
          const SizedBox(height: AppSpacing.xl),
          ..._fields.map(
            (f) => _buildField(
              scheme,
              key: f.$1,
              label: f.$2,
              unit: f.$3,
              icon: f.$4,
            ),
          ),
          if (_saved)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Your measurements are saved. They will be auto-filled when you place a custom order.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.success,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding.copyWith(
            top: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          child: SizedBox(
            height: AppSpacing.buttonHeight,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save Measurements',
                style: AppTextStyles.labelLarge.copyWith(
                  color: scheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: scheme.primary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why do we need this?',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Your body measurements help us tailor clothes that fit you perfectly. '
                  'Measure yourself or visit a tailor for accurate numbers.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onPrimaryContainer,
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

  Widget _buildBodyVisual(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.accessibility_new_rounded,
            size: 80,
            color: scheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Enter your measurements below',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'All values are in centimeters (cm) except weight (kg)',
            style: AppTextStyles.bodySmall.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    ColorScheme scheme, {
    required String key,
    required String label,
    required String unit,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: scheme.outline),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
              child: Icon(icon, size: 22, color: scheme.primary),
            ),
            Expanded(
              child: TextField(
                controller: _controllers[key],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  suffixText: unit,
                  suffixStyle: AppTextStyles.labelMedium.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                ),
                style: AppTextStyles.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
