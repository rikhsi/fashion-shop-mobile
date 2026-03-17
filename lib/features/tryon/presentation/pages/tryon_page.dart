import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/tryon_service.dart';

class TryOnPage extends StatefulWidget {
  final String productTitle;
  final String productImageUrl;

  const TryOnPage({
    super.key,
    required this.productTitle,
    required this.productImageUrl,
  });

  @override
  State<TryOnPage> createState() => _TryOnPageState();
}

enum _TryOnStep { selectPhoto, processing, result, error }

class _TryOnPageState extends State<TryOnPage> {
  final _service = sl<TryOnService>();
  _TryOnStep _step = _TryOnStep.selectPhoto;
  String? _selectedPhoto;
  String? _resultUrl;

  void _onPhotoSelected(String url) {
    setState(() {
      _selectedPhoto = url;
    });
  }

  Future<void> _startTryOn() async {
    if (_selectedPhoto == null) return;

    setState(() => _step = _TryOnStep.processing);

    final result = await _service.tryOn(
      personImageUrl: _selectedPhoto!,
      garmentImageUrl: widget.productImageUrl,
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        _resultUrl = result;
        _step = _TryOnStep.result;
      });
    } else {
      setState(() => _step = _TryOnStep.error);
    }
  }

  void _retry() {
    setState(() {
      _step = _TryOnStep.selectPhoto;
      _selectedPhoto = null;
      _resultUrl = null;
    });
  }

  void _addPhoto() {
    _service.addPhoto(
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=600&fit=crop',
    );
    setState(() {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Photo added'),
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Virtual Try-On',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: switch (_step) {
        _TryOnStep.selectPhoto => _buildSelectPhoto(scheme),
        _TryOnStep.processing => _buildProcessing(scheme),
        _TryOnStep.result => _buildResult(scheme),
        _TryOnStep.error => _buildError(scheme),
      },
    );
  }

  Widget _buildSelectPhoto(ColorScheme scheme) {
    final photos = _service.savedPhotos;

    return Column(
      children: [
        Container(
          margin: AppSpacing.screenPadding.copyWith(top: AppSpacing.base),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Image.network(
                  widget.productImageUrl,
                  width: 56,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 56,
                    height: 70,
                    color: scheme.outline,
                    child: Icon(Icons.checkroom_rounded,
                        color: scheme.onSurfaceVariant),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productTitle,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: scheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Select your photo below',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Padding(
          padding: AppSpacing.screenPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Photos',
                style: AppTextStyles.titleSmall.copyWith(
                  color: scheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: _addPhoto,
                child: Row(
                  children: [
                    Icon(Icons.add_rounded, size: 18, color: scheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Add Photo',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: photos.isEmpty
              ? _buildEmptyPhotos(scheme)
              : GridView.builder(
                  padding: AppSpacing.screenPadding.copyWith(bottom: 100),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: photos.length,
                  itemBuilder: (_, i) {
                    final isSelected = _selectedPhoto == photos[i];
                    return GestureDetector(
                      onTap: () => _onPhotoSelected(photos[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                          border: Border.all(
                            color: isSelected
                                ? scheme.primary
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd - 2),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                photos[i],
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Container(
                                  color: scheme.surfaceContainerHighest,
                                  child: Icon(Icons.person_outline_rounded,
                                      color: scheme.onSurfaceVariant),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  color: scheme.primary.withValues(alpha: 0.2),
                                  child: Center(
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: scheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: scheme.onPrimary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
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
              child: ElevatedButton.icon(
                onPressed: _selectedPhoto != null ? _startTryOn : null,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text('Try On'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  disabledBackgroundColor: scheme.outline,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  elevation: 0,
                  textStyle: AppTextStyles.labelLarge,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPhotos(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add_a_photo_outlined,
            size: 48,
            color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Add a photo to get started',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessing(ColorScheme scheme) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: scheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 40,
                    color: scheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'AI is dressing you up...',
              style: AppTextStyles.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Nano Banana is processing your virtual try-on. '
              'This may take a few seconds.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult(ColorScheme scheme) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: AppSpacing.screenPadding.copyWith(top: AppSpacing.base),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _ResultImage(
                          label: 'Before',
                          imageUrl: _selectedPhoto!,
                          scheme: scheme,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _ResultImage(
                          label: 'After',
                          imageUrl: _resultUrl!,
                          scheme: scheme,
                          highlight: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Powered by Nano Banana AI',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding.copyWith(
              top: AppSpacing.md,
              bottom: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: AppSpacing.buttonHeight,
                    child: OutlinedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.onSurface,
                        side: BorderSide(color: scheme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        textStyle: AppTextStyles.labelLarge,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SizedBox(
                    height: AppSpacing.buttonHeight,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Done'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.primary,
                        foregroundColor: scheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        elevation: 0,
                        textStyle: AppTextStyles.labelLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(ColorScheme scheme) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'Something went wrong',
              style: AppTextStyles.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'The AI could not process your try-on request. '
              'Please try again or use a different photo.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: _retry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  elevation: 0,
                  textStyle: AppTextStyles.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultImage extends StatelessWidget {
  final String label;
  final String imageUrl;
  final ColorScheme scheme;
  final bool highlight;

  const _ResultImage({
    required this.label,
    required this.imageUrl,
    required this.scheme,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: highlight ? scheme.primary : scheme.onSurfaceVariant,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: highlight ? scheme.primary : scheme.outline,
                width: highlight ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg - 1),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.primary,
                    ),
                  );
                },
                errorBuilder: (_, _, _) => Container(
                  color: scheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: scheme.onSurfaceVariant,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
