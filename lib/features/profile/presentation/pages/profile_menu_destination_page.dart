import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_empty_state.dart';

class ProfileMenuDestinationPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const ProfileMenuDestinationPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: AppEmptyState(
        icon: icon,
        title: title,
      ),
    );
  }
}
