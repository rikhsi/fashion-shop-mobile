import 'body_measurements_model.dart';

enum CustomOrderType { fromProduct, ownDesign }

enum CustomOrderStatus { pending, confirmed, inProduction, shipping, delivered, cancelled }

class CustomOrderModel {
  final String id;
  final String orderNumber;
  final CustomOrderType type;
  final CustomOrderStatus status;
  final DateTime createdAt;
  final BodyMeasurementsModel measurements;

  /// For [CustomOrderType.fromProduct]
  final String? productTitle;
  final String? productImageUrl;
  final double? productPrice;

  /// For [CustomOrderType.ownDesign]
  final List<String> designImages;
  final String? designDescription;

  final double totalPrice;
  final String? fabricChoice;
  final String? colorChoice;
  final DateTime? estimatedDelivery;

  const CustomOrderModel({
    required this.id,
    required this.orderNumber,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.measurements,
    this.productTitle,
    this.productImageUrl,
    this.productPrice,
    this.designImages = const [],
    this.designDescription,
    required this.totalPrice,
    this.fabricChoice,
    this.colorChoice,
    this.estimatedDelivery,
  });
}
