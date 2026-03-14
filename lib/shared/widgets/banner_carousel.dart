import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class BannerItem {
  final String title;
  final String subtitle;
  final Color color;
  final Color textColor;
  final String? imageUrl;

  const BannerItem({
    required this.title,
    required this.subtitle,
    required this.color,
    this.textColor = Colors.white,
    this.imageUrl,
  });
}

class BannerCarousel extends StatefulWidget {
  final List<BannerItem> items;
  final double height;

  const BannerCarousel({
    super.key,
    required this.items,
    this.height = AppSpacing.bannerHeight,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackground(),
            _buildGradientOverlay(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.bannerTitle.copyWith(
                      color: item.textColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.subtitle,
                    style: AppTextStyles.bannerSubtitle.copyWith(
                      color: item.textColor.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return Image.network(
        item.imageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return Container(color: item.color);
        },
        errorBuilder: (_, __, ___) => Container(color: item.color),
      );
    }
    return Container(color: item.color);
  }

  Widget _buildGradientOverlay() {
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.65),
            ],
            stops: const [0.3, 1.0],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
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
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          decoration: BoxDecoration(
            color: isActive ? scheme.primary : scheme.outline,
            borderRadius: BorderRadius.circular(AppSpacing.xxs + 1),
          ),
        );
      }),
    );
  }
}
