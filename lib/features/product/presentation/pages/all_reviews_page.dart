import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/product_detail_model.dart';
import 'fullscreen_gallery_page.dart';

class AllReviewsPage extends StatelessWidget {
  final List<ReviewModel> reviews;
  final double averageRating;
  final int totalCount;

  const AllReviewsPage({
    super.key,
    required this.reviews,
    required this.averageRating,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text('${tr.get('reviews')} ($totalCount)'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.base),
          _RatingSummary(
            average: averageRating,
            totalCount: totalCount,
            reviews: reviews,
            scheme: scheme,
          ),
          const SizedBox(height: AppSpacing.xl),
          Divider(color: scheme.outline.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.base),
          ...reviews.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.base),
            child: _ReviewTile(review: r, scheme: scheme),
          )),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

// ── Rating summary with bar distribution ──

class _RatingSummary extends StatelessWidget {
  final double average;
  final int totalCount;
  final List<ReviewModel> reviews;
  final ColorScheme scheme;

  const _RatingSummary({
    required this.average,
    required this.totalCount,
    required this.reviews,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final distribution = _computeDistribution();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Text(
              average.toStringAsFixed(1),
              style: AppTextStyles.displayLarge.copyWith(
                color: scheme.onSurface,
                fontSize: 48,
              ),
            ),
            Row(
              children: List.generate(5, (i) {
                final val = i + 1;
                if (average >= val) return const Icon(Icons.star_rounded, size: 18, color: Color(0xFFFFC107));
                if (average >= val - 0.5) return const Icon(Icons.star_half_rounded, size: 18, color: Color(0xFFFFC107));
                return Icon(Icons.star_border_rounded, size: 18, color: scheme.onSurfaceVariant.withValues(alpha: 0.4));
              }),
            ),
            const SizedBox(height: 4),
            Text(
              '$totalCount ${context.tr.get('reviews')}',
              style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: Column(
            children: List.generate(5, (i) {
              final star = 5 - i;
              final pct = distribution[star] ?? 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text('$star', style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
                    const SizedBox(width: 4),
                    const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFC107)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 6,
                          backgroundColor: scheme.outline.withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation(scheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Map<int, double> _computeDistribution() {
    if (reviews.isEmpty) return {};
    final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      counts[r.rating.round()] = (counts[r.rating.round()] ?? 0) + 1;
    }
    return counts.map((k, v) => MapEntry(k, v / reviews.length));
  }
}

// ── Individual review tile ──

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  final ColorScheme scheme;

  const _ReviewTile({required this.review, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final daysAgo = DateTime.now().difference(review.date).inDays;
    final timeText = daysAgo == 0
        ? 'Today'
        : daysAgo == 1
            ? 'Yesterday'
            : '$daysAgo days ago';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: scheme.primary.withValues(alpha: 0.15),
                child: Text(
                  review.userName.isNotEmpty ? review.userName[0] : '?',
                  style: AppTextStyles.labelLarge.copyWith(color: scheme.primary),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: AppTextStyles.titleSmall.copyWith(color: scheme.onSurface)),
                    const SizedBox(height: 2),
                    Text(timeText, style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _ratingColor(review.rating).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 14, color: _ratingColor(review.rating)),
                    const SizedBox(width: 2),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: AppTextStyles.labelMedium.copyWith(color: _ratingColor(review.rating)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(review.comment, style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurface, height: 1.6)),
          if (review.images != null && review.images!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images!.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, _, _) => FullscreenGalleryPage(
                        images: review.images!,
                        initialIndex: i,
                      ),
                      transitionsBuilder: (_, animation, _, child) =>
                          FadeTransition(opacity: animation, child: child),
                      transitionDuration: const Duration(milliseconds: 250),
                      reverseTransitionDuration: const Duration(milliseconds: 200),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    child: Image.network(
                      review.images![i],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 80,
                        height: 80,
                        color: scheme.outline.withValues(alpha: 0.3),
                        child: Icon(Icons.broken_image_outlined, color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _ratingColor(double rating) {
    if (rating >= 4.0) return AppColors.success;
    if (rating >= 3.0) return AppColors.warning;
    return AppColors.error;
  }
}
