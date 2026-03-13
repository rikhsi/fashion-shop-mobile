import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.color,
    this.textColor = Colors.white,
  });
}

class BannerCarousel extends StatefulWidget {
  final List<BannerItem> items;
  final double height;

  const BannerCarousel({
    super.key,
    required this.items,
    this.height = 170,
  });

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _controller;
  int _current = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.92);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_current + 1) % widget.items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => _BannerCard(item: widget.items[i]),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _PageDots(count: widget.items.length, current: _current),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final BannerItem item;
  const _BannerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Container(
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.title,
              style: TextStyle(
                color: item.textColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              item.subtitle,
              style: TextStyle(
                color: item.textColor.withValues(alpha: 0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int count;
  final int current;
  const _PageDots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: isActive ? 20 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: isActive ? scheme.primary : scheme.outline,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
