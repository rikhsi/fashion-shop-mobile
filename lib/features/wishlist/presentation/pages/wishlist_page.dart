import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_empty_state.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.wishlist,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: AppEmptyState(
        icon: Icons.favorite_border_rounded,
        title: tr.emptyWishlist,
        description: tr.emptyWishlistDescription,
      ),
    );
  }
}
