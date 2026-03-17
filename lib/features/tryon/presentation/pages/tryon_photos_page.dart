import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/tryon_service.dart';

class TryOnPhotosPage extends StatefulWidget {
  const TryOnPhotosPage({super.key});

  @override
  State<TryOnPhotosPage> createState() => _TryOnPhotosPageState();
}

class _TryOnPhotosPageState extends State<TryOnPhotosPage> {
  final _service = sl<TryOnService>();

  @override
  void initState() {
    super.initState();
    _service.addListener(_rebuild);
  }

  @override
  void dispose() {
    _service.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  void _addPhoto() {
    _service.addPhoto(
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=600&fit=crop',
    );
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

  void _removePhoto(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Photo'),
        content: const Text('Remove this photo from your try-on collection?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _service.removePhoto(index);
            },
            child: Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final photos = _service.savedPhotos;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Try-On Photos',
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: photos.isEmpty ? _buildEmpty(scheme) : _buildGrid(scheme, photos),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPhoto,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        icon: const Icon(Icons.add_a_photo_rounded),
        label: const Text('Add Photo'),
      ),
    );
  }

  Widget _buildEmpty(ColorScheme scheme) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_pin_outlined,
              size: 80,
              color: scheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              'No photos yet',
              style: AppTextStyles.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add your photos to try on clothes virtually. '
              'These photos will be used when you tap "Try On" on any product.',
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

  Widget _buildGrid(ColorScheme scheme, List<String> photos) {
    return GridView.builder(
      padding: AppSpacing.screenPadding.copyWith(
        top: AppSpacing.base,
        bottom: 100,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.7,
      ),
      itemCount: photos.length,
      itemBuilder: (_, i) => _PhotoCard(
        imageUrl: photos[i],
        onRemove: () => _removePhoto(i),
        scheme: scheme,
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onRemove;
  final ColorScheme scheme;

  const _PhotoCard({
    required this.imageUrl,
    required this.onRemove,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                color: scheme.surfaceContainerHighest,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (_, _, _) => Container(
              color: scheme.surfaceContainerHighest,
              child: Icon(
                Icons.person_outline_rounded,
                size: 48,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
