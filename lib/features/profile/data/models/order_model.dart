enum OrderStatus { pending, processing, shipped, delivered, cancelled }

enum PaymentMethod { click, payme, uzumBank, paynet }

/// Тип получения заказа: доставка или самовывоз
enum DeliveryType { delivery, pickup }

/// Адрес доставки
class DeliveryAddressModel {
  final String city;
  final String street;
  final String? apartment;
  final String phone;
  final double? latitude;
  final double? longitude;

  const DeliveryAddressModel({
    required this.city,
    required this.street,
    this.apartment,
    required this.phone,
    this.latitude,
    this.longitude,
  });

  String get fullAddress =>
      '$city, $street${apartment != null && apartment!.isNotEmpty ? ", кв. $apartment" : ""}';
}

class OrderModel {
  final String id;
  final String orderNumber;
  final DateTime date;
  final OrderStatus status;
  final double total;
  final int itemCount;
  final String? trackingNumber;
  final List<OrderItemModel> items;
  final PaymentMethod paymentMethod;
  final DeliveryType deliveryType;
  final DeliveryAddressModel? deliveryAddress;
  final String? warehouseId;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.total,
    required this.itemCount,
    this.trackingNumber,
    this.items = const [],
    this.paymentMethod = PaymentMethod.payme,
    this.deliveryType = DeliveryType.delivery,
    this.deliveryAddress,
    this.warehouseId,
  });
}

class OrderItemModel {
  final String title;
  final String? imageUrl;
  final double price;
  final int quantity;

  const OrderItemModel({
    required this.title,
    this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}
