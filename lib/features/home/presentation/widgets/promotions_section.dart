import 'package:flutter/material.dart';

import '../../../../shared/widgets/banner_carousel.dart';
import '../../data/models/banner_model.dart';

class PromotionsSection extends StatelessWidget {
  final List<BannerModel> banners;

  const PromotionsSection({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    final items = banners
        .map((b) => BannerItem(
              title: b.title,
              subtitle: b.subtitle,
              color: b.color,
              textColor: b.textColor,
              imageUrl: b.imageUrl,
            ))
        .toList();

    return BannerCarousel(items: items);
  }
}
