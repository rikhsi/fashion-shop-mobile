import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/banner_carousel.dart';

class PromotionsSection extends StatelessWidget {
  const PromotionsSection({super.key});

  static const _banners = [
    BannerItem(
      title: 'Spring Sale\nUp to 50% Off',
      subtitle: 'New spring collection available now',
      color: AppColors.primary,
    ),
    BannerItem(
      title: 'Free Delivery',
      subtitle: 'On orders over 200 000 sum',
      color: Color(0xFFE17055),
    ),
    BannerItem(
      title: 'New Arrivals',
      subtitle: 'Fresh styles every week',
      color: Color(0xFF00B894),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const BannerCarousel(items: _banners);
  }
}
