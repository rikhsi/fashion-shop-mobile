import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/skeleton_loading.dart';

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          child: ShimmerBox(
            width: double.infinity,
            height: AppSpacing.bannerHeight,
            borderRadius: AppSpacing.radiusXl,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
              child: ShimmerBox(
                width: 6,
                height: 6,
                borderRadius: AppSpacing.radiusFull,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
