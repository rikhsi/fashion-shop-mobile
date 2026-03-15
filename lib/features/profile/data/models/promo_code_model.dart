class PromoCodeModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final int discountPercent;
  final double? minPurchase;
  final DateTime expiresAt;
  final bool isUsed;

  const PromoCodeModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercent,
    this.minPurchase,
    required this.expiresAt,
    this.isUsed = false,
  });

  bool get isExpired => expiresAt.isBefore(DateTime.now());
  bool get isActive => !isExpired && !isUsed;

  int get daysLeft {
    final diff = expiresAt.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }
}
