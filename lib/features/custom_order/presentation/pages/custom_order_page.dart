import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/mocks/mock_custom_orders.dart';

enum CustomOrderMode { fromProduct, ownDesign }

class CustomOrderPage extends StatefulWidget {
  final CustomOrderMode mode;
  final String? productTitle;
  final String? productImageUrl;
  final double? productPrice;

  const CustomOrderPage({
    super.key,
    required this.mode,
    this.productTitle,
    this.productImageUrl,
    this.productPrice,
  });

  @override
  State<CustomOrderPage> createState() => _CustomOrderPageState();
}

enum _Step { measurements, details, confirm, done }

class _CustomOrderPageState extends State<CustomOrderPage> {
  _Step _step = _Step.measurements;
  bool _useSavedMeasurements = true;
  bool _loading = false;

  // Measurement controllers (pre-filled from saved)
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _chestCtrl = TextEditingController();
  final _waistCtrl = TextEditingController();
  final _hipsCtrl = TextEditingController();
  final _shoulderCtrl = TextEditingController();
  final _armCtrl = TextEditingController();
  final _legCtrl = TextEditingController();
  final _neckCtrl = TextEditingController();

  // Design details
  final _descriptionCtrl = TextEditingController();
  String _fabricChoice = 'Cotton';
  String _colorChoice = '';
  final List<String> _designImages = [];

  static const _fabrics = ['Cotton', 'Silk', 'Linen', 'Wool Blend', 'Polyester', 'Denim', 'Velvet'];

  @override
  void initState() {
    super.initState();
    _loadSavedMeasurements();
  }

  void _loadSavedMeasurements() {
    final m = MockCustomOrders.savedMeasurements;
    _heightCtrl.text = m.height?.toString() ?? '';
    _weightCtrl.text = m.weight?.toString() ?? '';
    _chestCtrl.text = m.chest?.toString() ?? '';
    _waistCtrl.text = m.waist?.toString() ?? '';
    _hipsCtrl.text = m.hips?.toString() ?? '';
    _shoulderCtrl.text = m.shoulderWidth?.toString() ?? '';
    _armCtrl.text = m.armLength?.toString() ?? '';
    _legCtrl.text = m.legLength?.toString() ?? '';
    _neckCtrl.text = m.neckCirc?.toString() ?? '';
  }

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _chestCtrl.dispose();
    _waistCtrl.dispose();
    _hipsCtrl.dispose();
    _shoulderCtrl.dispose();
    _armCtrl.dispose();
    _legCtrl.dispose();
    _neckCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  bool get _measurementsValid =>
      _chestCtrl.text.isNotEmpty &&
      _waistCtrl.text.isNotEmpty &&
      _hipsCtrl.text.isNotEmpty;

  void _goToDetails() {
    if (!_measurementsValid) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Please fill in at least Chest, Waist, and Hips'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }
    setState(() => _step = _Step.details);
  }

  void _goToConfirm() {
    setState(() => _step = _Step.confirm);
  }

  void _submitOrder() {
    setState(() => _loading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _step = _Step.done;
      });
    });
  }

  void _addDesignImage() {
    _designImages.add(
      'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400&h=500&fit=crop',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == CustomOrderMode.fromProduct
              ? 'Custom Tailoring'
              : 'Custom Design Order',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: switch (_step) {
        _Step.measurements => _buildMeasurements(scheme),
        _Step.details => _buildDetails(scheme),
        _Step.confirm => _buildConfirm(scheme),
        _Step.done => _buildDone(scheme),
      },
    );
  }

  // ── Step 1: Measurements ──

  Widget _buildMeasurements(ColorScheme scheme) {
    return Column(
      children: [
        _buildStepIndicator(scheme, 0),
        Expanded(
          child: ListView(
            padding: AppSpacing.screenPadding.copyWith(
              top: AppSpacing.base,
              bottom: AppSpacing.xl,
            ),
            children: [
              if (widget.mode == CustomOrderMode.fromProduct &&
                  widget.productImageUrl != null)
                _buildProductHeader(scheme),
              if (!MockCustomOrders.savedMeasurements.isEmpty)
                _buildSavedMeasurementsToggle(scheme),
              const SizedBox(height: AppSpacing.base),
              Text(
                'Body Measurements',
                style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Required fields: Chest, Waist, Hips',
                style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.base),
              _MeasurementRow(label: 'Height (cm)', ctrl: _heightCtrl, scheme: scheme),
              _MeasurementRow(label: 'Weight (kg)', ctrl: _weightCtrl, scheme: scheme),
              _MeasurementRow(label: 'Chest (cm) *', ctrl: _chestCtrl, scheme: scheme, required_: true),
              _MeasurementRow(label: 'Waist (cm) *', ctrl: _waistCtrl, scheme: scheme, required_: true),
              _MeasurementRow(label: 'Hips (cm) *', ctrl: _hipsCtrl, scheme: scheme, required_: true),
              _MeasurementRow(label: 'Shoulder Width (cm)', ctrl: _shoulderCtrl, scheme: scheme),
              _MeasurementRow(label: 'Arm Length (cm)', ctrl: _armCtrl, scheme: scheme),
              _MeasurementRow(label: 'Leg Length (cm)', ctrl: _legCtrl, scheme: scheme),
              _MeasurementRow(label: 'Neck (cm)', ctrl: _neckCtrl, scheme: scheme),
            ],
          ),
        ),
        _buildBottomButton(scheme, 'Continue', _goToDetails),
      ],
    );
  }

  Widget _buildProductHeader(ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.base),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            child: Image.network(
              widget.productImageUrl!,
              width: 56,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 56, height: 70,
                color: scheme.outline,
                child: Icon(Icons.checkroom_rounded, color: scheme.onSurfaceVariant),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productTitle ?? 'Product',
                  style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.productPrice != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Base: ${_formatPrice(widget.productPrice!)} UZS',
                    style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              'Custom Fit',
              style: AppTextStyles.labelSmall.copyWith(color: scheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedMeasurementsToggle(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.person_pin_rounded, color: AppColors.success, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Use saved measurements',
              style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
            ),
          ),
          Switch.adaptive(
            value: _useSavedMeasurements,
            activeColor: AppColors.success,
            onChanged: (v) {
              setState(() {
                _useSavedMeasurements = v;
                if (v) _loadSavedMeasurements();
              });
            },
          ),
        ],
      ),
    );
  }

  // ── Step 2: Details (fabric, color, design description/images) ──

  Widget _buildDetails(ColorScheme scheme) {
    return Column(
      children: [
        _buildStepIndicator(scheme, 1),
        Expanded(
          child: ListView(
            padding: AppSpacing.screenPadding.copyWith(
              top: AppSpacing.base,
              bottom: AppSpacing.xl,
            ),
            children: [
              Text(
                'Choose Fabric',
                style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _fabrics.map((f) {
                  final selected = f == _fabricChoice;
                  return GestureDetector(
                    onTap: () => setState(() => _fabricChoice = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.base,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: selected ? scheme.primary : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        border: Border.all(
                          color: selected ? scheme.primary : scheme.outline,
                        ),
                      ),
                      child: Text(
                        f,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: selected ? scheme.onPrimary : scheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Preferred Color',
                style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: scheme.outline),
                ),
                child: TextField(
                  onChanged: (v) => _colorChoice = v,
                  decoration: InputDecoration(
                    hintText: 'e.g. Navy Blue, Black, Ivory...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppSpacing.base),
                    prefixIcon: Icon(Icons.palette_outlined, color: scheme.primary),
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (widget.mode == CustomOrderMode.ownDesign) ...[
                Text(
                  'Upload Design Reference',
                  style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Add photos or sketches of the design you want us to create',
                  style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._designImages.asMap().entries.map((e) => Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.sm),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                  child: Image.network(
                                    e.value,
                                    width: 90,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      _designImages.removeAt(e.key);
                                      setState(() {});
                                    },
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      GestureDetector(
                        onTap: _addDesignImage,
                        child: Container(
                          width: 90,
                          height: 120,
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                            border: Border.all(color: scheme.outline, style: BorderStyle.solid),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, color: scheme.primary, size: 28),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Add Photo',
                                style: AppTextStyles.labelSmall.copyWith(color: scheme.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              Text(
                'Additional Notes',
                style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(color: scheme.outline),
                ),
                child: TextField(
                  controller: _descriptionCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: widget.mode == CustomOrderMode.ownDesign
                        ? 'Describe the design in detail: style, fit, length, special requests...'
                        : 'Any special requests? Different length, modified collar, etc...',
                    hintStyle: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppSpacing.base),
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
        ),
        _buildBottomButton(scheme, 'Review Order', _goToConfirm),
      ],
    );
  }

  // ── Step 3: Confirm ──

  Widget _buildConfirm(ColorScheme scheme) {
    final basePrice = widget.productPrice ?? 0;
    final tailoringFee = basePrice > 0 ? 100000.0 : 200000.0;
    final totalPrice = basePrice + tailoringFee;

    return Column(
      children: [
        _buildStepIndicator(scheme, 2),
        Expanded(
          child: ListView(
            padding: AppSpacing.screenPadding.copyWith(
              top: AppSpacing.base,
              bottom: AppSpacing.xl,
            ),
            children: [
              if (widget.mode == CustomOrderMode.fromProduct &&
                  widget.productImageUrl != null)
                _buildProductHeader(scheme),
              if (widget.mode == CustomOrderMode.ownDesign &&
                  _designImages.isNotEmpty)
                _buildDesignPreview(scheme),
              _buildSummaryCard(scheme, [
                ('Chest', '${_chestCtrl.text} cm'),
                ('Waist', '${_waistCtrl.text} cm'),
                ('Hips', '${_hipsCtrl.text} cm'),
                if (_shoulderCtrl.text.isNotEmpty)
                  ('Shoulders', '${_shoulderCtrl.text} cm'),
                if (_heightCtrl.text.isNotEmpty) ('Height', '${_heightCtrl.text} cm'),
              ], 'Measurements', Icons.straighten_rounded),
              const SizedBox(height: AppSpacing.md),
              _buildSummaryCard(scheme, [
                ('Fabric', _fabricChoice),
                if (_colorChoice.isNotEmpty) ('Color', _colorChoice),
                if (_descriptionCtrl.text.isNotEmpty)
                  ('Notes', _descriptionCtrl.text),
              ], 'Details', Icons.design_services_outlined),
              const SizedBox(height: AppSpacing.md),
              Container(
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
                      'Price Estimate',
                      style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (basePrice > 0)
                      _PriceRow(label: 'Product', value: '${_formatPrice(basePrice)} UZS', scheme: scheme),
                    _PriceRow(
                      label: 'Tailoring Fee',
                      value: '${_formatPrice(tailoringFee)} UZS',
                      scheme: scheme,
                    ),
                    const Divider(height: AppSpacing.xl),
                    _PriceRow(
                      label: 'Total',
                      value: '${_formatPrice(totalPrice)} UZS',
                      scheme: scheme,
                      bold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.schedule_rounded, color: AppColors.info, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Estimated production time: 7–14 business days. '
                        'You will be contacted by our tailor to confirm details.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
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
              height: AppSpacing.buttonHeight,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitOrder,
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
                        'Place Custom Order',
                        style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesignPreview(ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.base),
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _designImages.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, i) => ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Image.network(_designImages[i], width: 75, height: 100, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    ColorScheme scheme,
    List<(String, String)> items,
    String title,
    IconData icon,
  ) {
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
          Row(
            children: [
              Icon(icon, size: 18, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        item.$1,
                        style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.$2,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ── Step 4: Done ──

  Widget _buildDone(ColorScheme scheme) {
    return Center(
      child: Padding(
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
              'Order Placed!',
              style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your custom order has been submitted. Our tailor team will review '
              'your measurements and contact you within 24 hours to confirm details.',
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
                child: Text('Done', style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Common Widgets ──

  Widget _buildStepIndicator(ColorScheme scheme, int activeStep) {
    const steps = ['Measurements', 'Details', 'Confirm'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(bottom: BorderSide(color: scheme.outline)),
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                color: (i ~/ 2) < activeStep
                    ? scheme.primary
                    : scheme.outline,
              ),
            );
          }
          final stepIdx = i ~/ 2;
          final isActive = stepIdx == activeStep;
          final isDone = stepIdx < activeStep;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone
                      ? scheme.primary
                      : isActive
                          ? scheme.primary
                          : scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone || isActive ? scheme.primary : scheme.outline,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? Icon(Icons.check, size: 14, color: scheme.onPrimary)
                      : Text(
                          '${stepIdx + 1}',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                steps[stepIdx],
                style: AppTextStyles.labelSmall.copyWith(
                  color: isActive || isDone ? scheme.primary : scheme.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBottomButton(ColorScheme scheme, String label, VoidCallback onTap) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.md,
          bottom: AppSpacing.md,
        ),
        child: SizedBox(
          width: double.infinity,
          height: AppSpacing.buttonHeight,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              elevation: 0,
            ),
            child: Text(label, style: AppTextStyles.labelLarge.copyWith(color: scheme.onPrimary)),
          ),
        ),
      ),
    );
  }

  String _formatPrice(double v) {
    final s = v.toInt().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

class _MeasurementRow extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final ColorScheme scheme;
  final bool required_;

  const _MeasurementRow({
    required this.label,
    required this.ctrl,
    required this.scheme,
    this.required_ = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: required_ ? scheme.onSurface : scheme.onSurfaceVariant,
                fontWeight: required_ ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: required_ ? scheme.primary.withValues(alpha: 0.4) : scheme.outline),
              ),
              child: TextField(
                controller: ctrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                ),
                style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme scheme;
  final bool bold;

  const _PriceRow({
    required this.label,
    required this.value,
    required this.scheme,
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
            style: (bold ? AppTextStyles.titleSmall : AppTextStyles.bodyMedium).copyWith(
              color: scheme.onSurface,
            ),
          ),
          Text(
            value,
            style: (bold ? AppTextStyles.titleSmall : AppTextStyles.bodyMedium).copyWith(
              color: scheme.onSurface,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
