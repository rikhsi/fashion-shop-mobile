enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String orderNumber;
  final DateTime date;
  final OrderStatus status;
  final double total;
  final int itemCount;
  final String? trackingNumber;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.total,
    required this.itemCount,
    this.trackingNumber,
    this.items = const [],
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
