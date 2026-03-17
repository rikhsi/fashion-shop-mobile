import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/models/notification_model.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;
  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = _typeVisuals(notification.type);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _typeLabel(notification.type),
          style: AppTextStyles.titleLarge.copyWith(color: scheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding.copyWith(
          top: AppSpacing.base,
          bottom: AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(scheme, icon, color),
            const SizedBox(height: AppSpacing.xl),
            _buildMessageCard(scheme),
            const SizedBox(height: AppSpacing.base),
            _buildTimeCard(scheme),
            if (_hasAction(notification.type)) ...[
              const SizedBox(height: AppSpacing.xl),
              _buildActionButton(context, scheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                ),
                child: Text(
                  _typeLabel(notification.type),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: color,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                notification.title,
                style: AppTextStyles.titleLarge.copyWith(
                  color: scheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageCard(ColorScheme scheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: AppTextStyles.titleSmall.copyWith(
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            notification.message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurface,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _getDetailedMessage(notification),
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 18,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            _formatFullTime(notification.time),
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          if (!notification.isRead)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              ),
              child: Text(
                'New',
                style: AppTextStyles.badge.copyWith(
                  color: scheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ColorScheme scheme) {
    final (label, actionIcon) = switch (notification.type) {
      NotificationType.order => ('View Order', Icons.inventory_2_outlined),
      NotificationType.promo => ('Shop Now', Icons.shopping_bag_outlined),
      NotificationType.priceDrop => ('View Product', Icons.visibility_outlined),
      NotificationType.chat => ('Open Chat', Icons.chat_outlined),
      NotificationType.system => ('OK', Icons.check_rounded),
    };

    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: Icon(actionIcon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: 0,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
    );
  }

  String _getDetailedMessage(NotificationModel n) {
    return switch (n.type) {
      NotificationType.order =>
        'You can check the full details and tracking information in your orders page. If you have any questions, feel free to contact our support team.',
      NotificationType.promo =>
        'This promotion is available for a limited time. Browse our catalog to find the best deals and apply the discount at checkout.',
      NotificationType.priceDrop =>
        'The price has been reduced on an item you\'ve been watching. Act fast — price drops are temporary and stock is limited.',
      NotificationType.system =>
        'This is a system notification about your account. No action is required unless otherwise stated.',
      NotificationType.chat =>
        'You have a new message from a seller. Open the chat to read and respond to their message.',
    };
  }

  bool _hasAction(NotificationType type) => true;

  (IconData, Color) _typeVisuals(NotificationType type) {
    return switch (type) {
      NotificationType.order => (Icons.local_shipping_rounded, AppColors.info),
      NotificationType.promo => (Icons.local_offer_rounded, AppColors.discount),
      NotificationType.priceDrop => (Icons.trending_down_rounded, AppColors.success),
      NotificationType.system => (Icons.security_rounded, const Color(0xFF6B7280)),
      NotificationType.chat => (Icons.chat_bubble_rounded, AppColors.accent),
    };
  }

  String _typeLabel(NotificationType type) {
    return switch (type) {
      NotificationType.order => 'Order',
      NotificationType.promo => 'Promotion',
      NotificationType.priceDrop => 'Price Drop',
      NotificationType.system => 'System',
      NotificationType.chat => 'Message',
    };
  }

  String _formatFullTime(DateTime time) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '${months[time.month - 1]} ${time.day}, ${time.year} at $h:$m';
  }
}
