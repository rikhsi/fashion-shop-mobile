import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppSpacing.radiusMd,
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseColor = scheme.outline.withValues(alpha: 0.15);
    final highlightColor = scheme.outline.withValues(alpha: 0.05);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class SkeletonCategoryGrid extends StatelessWidget {
  const SkeletonCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.9,
        ),
        itemCount: 9,
        itemBuilder: (_, _) => const _SkeletonCategoryCard(),
      ),
    );
  }
}

class _SkeletonCategoryCard extends StatelessWidget {
  const _SkeletonCategoryCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerBox(
          width: 56,
          height: 56,
          borderRadius: AppSpacing.radiusFull,
        ),
        const SizedBox(height: AppSpacing.sm),
        ShimmerBox(
          width: 60,
          height: 12,
          borderRadius: AppSpacing.radiusXs,
        ),
      ],
    );
  }
}

class SkeletonSubcategoryList extends StatelessWidget {
  const SkeletonSubcategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: List.generate(
          6,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: [
                ShimmerBox(
                  width: 40,
                  height: 40,
                  borderRadius: AppSpacing.radiusSm,
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 16,
                    borderRadius: AppSpacing.radiusXs,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkeletonProductGrid extends StatelessWidget {
  final int count;
  const SkeletonProductGrid({super.key, this.count = 4});

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
        itemBuilder: (_, _) => const _SkeletonProductCard(),
      ),
    );
  }
}

class _SkeletonProductCard extends StatelessWidget {
  const _SkeletonProductCard();

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
