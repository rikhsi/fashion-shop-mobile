import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/skeleton_loading.dart';

class CardGridSkeleton extends StatelessWidget {
  final int count;

  const CardGridSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.base,
          childAspectRatio: 0.58,
        ),
        itemCount: count,
        itemBuilder: (_, _) => const _CardItemSkeleton(),
      ),
    );
  }
}

class CardHorizontalSkeleton extends StatelessWidget {
  final int count;

  const CardHorizontalSkeleton({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screenPadding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, _) => const SizedBox(
          width: 150,
          child: _CardItemSkeleton(),
        ),
      ),
    );
  }
}

class _CardItemSkeleton extends StatelessWidget {
  const _CardItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1 / AppSpacing.productCardImageRatio,
          child: ShimmerBox(
            width: double.infinity,
            height: double.infinity,
            borderRadius: AppSpacing.radiusLg,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ShimmerBox(
          width: double.infinity,
          height: 14,
          borderRadius: AppSpacing.radiusXs,
        ),
        const SizedBox(height: AppSpacing.xs),
        ShimmerBox(
          width: 80,
          height: 14,
          borderRadius: AppSpacing.radiusXs,
        ),
      ],
    );
  }
}

class CategoryChipsSkeleton extends StatelessWidget {
  const CategoryChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.screenPadding,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (_, _) => const _CategoryChipSkeleton(),
      ),
    );
  }
}

class _CategoryChipSkeleton extends StatelessWidget {
  const _CategoryChipSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerBox(
          width: 64,
          height: 64,
          borderRadius: AppSpacing.radiusFull,
        ),
        const SizedBox(height: AppSpacing.sm),
        ShimmerBox(
          width: 48,
          height: 12,
          borderRadius: AppSpacing.radiusXs,
        ),
      ],
    );
  }
}
