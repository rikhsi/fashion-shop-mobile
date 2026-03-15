enum NotificationType { order, promo, priceDrop, system, chat }

class NotificationModel {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final String? actionUrl;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.actionUrl,
  });
}
