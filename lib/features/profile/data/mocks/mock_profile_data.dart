import '../models/chat_model.dart';
import '../models/notification_model.dart';
import '../models/order_model.dart';
import '../models/promo_code_model.dart';

const _img = 'https://images.unsplash.com/';

abstract final class MockProfileData {
  // ── Orders ──

  static final orders = <OrderModel>[
    OrderModel(
      id: 'o1',
      orderNumber: 'FS-2026001',
      date: DateTime(2026, 3, 10),
      status: OrderStatus.delivered,
      total: 548000,
      itemCount: 2,
      trackingNumber: 'UZ1234567890',
      items: const [
        OrderItemModel(title: 'Silk Evening Blouse', price: 189000, imageUrl: '${_img}photo-1564257631407-4deb1f99d992?w=200&h=250&fit=crop'),
        OrderItemModel(title: 'Summer Maxi Dress', price: 349000, imageUrl: '${_img}photo-1572804013309-59a88b7e92f1?w=200&h=250&fit=crop'),
      ],
    ),
    OrderModel(
      id: 'o2',
      orderNumber: 'FS-2026002',
      date: DateTime(2026, 3, 12),
      status: OrderStatus.shipped,
      total: 459000,
      itemCount: 1,
      trackingNumber: 'UZ0987654321',
      items: const [
        OrderItemModel(title: 'Designer Cocktail Dress', price: 459000, imageUrl: '${_img}photo-1515886657613-9f3515b0c78f?w=200&h=250&fit=crop'),
      ],
    ),
    OrderModel(
      id: 'o3',
      orderNumber: 'FS-2026003',
      date: DateTime(2026, 3, 13),
      status: OrderStatus.processing,
      total: 897000,
      itemCount: 3,
      items: const [
        OrderItemModel(title: 'Air Max Sneakers', price: 459000, imageUrl: '${_img}photo-1542291026-7eec264c27ff?w=200&h=250&fit=crop'),
        OrderItemModel(title: 'Canvas Backpack', price: 189000, imageUrl: '${_img}photo-1553062407-98eeb64c6a62?w=200&h=250&fit=crop'),
        OrderItemModel(title: 'Premium Sunglasses', price: 249000, imageUrl: '${_img}photo-1611923134239-b9be5816e23c?w=200&h=250&fit=crop'),
      ],
    ),
    OrderModel(
      id: 'o4',
      orderNumber: 'FS-2026004',
      date: DateTime(2026, 3, 14),
      status: OrderStatus.pending,
      total: 189000,
      itemCount: 1,
      items: const [
        OrderItemModel(title: 'Classic White T-Shirt', price: 189000, imageUrl: '${_img}photo-1521572163474-6864f9cf17ab?w=200&h=250&fit=crop'),
      ],
    ),
    OrderModel(
      id: 'o5',
      orderNumber: 'FS-2026005',
      date: DateTime(2026, 3, 8),
      status: OrderStatus.cancelled,
      total: 299000,
      itemCount: 2,
      items: const [
        OrderItemModel(title: 'Summer Straw Hat', price: 89000, imageUrl: '${_img}photo-1575032617751-6ddec2089882?w=200&h=250&fit=crop'),
        OrderItemModel(title: 'Weekend Casual Set', price: 219000, imageUrl: '${_img}photo-1480455624313-e29b44bbfde1?w=200&h=250&fit=crop'),
      ],
    ),
  ];

  // ── Chats ──

  static final chats = <ChatModel>[
    ChatModel(
      id: 'c1',
      sellerName: 'Fashion Store',
      lastMessage: 'Your order has been shipped! Track it now.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 1,
    ),
    ChatModel(
      id: 'c2',
      sellerName: 'Premium Boutique',
      lastMessage: 'Thank you for your purchase! Hope you enjoy it.',
      time: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ChatModel(
      id: 'c3',
      sellerName: 'Shoe Paradise',
      lastMessage: 'We have new arrivals you might like! Check them out.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 3,
    ),
    ChatModel(
      id: 'c4',
      sellerName: 'Style Hub',
      lastMessage: 'Your item is back in stock! Order now before it sells out.',
      time: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ChatModel(
      id: 'c5',
      sellerName: 'Accessory World',
      lastMessage: 'Hi! Can I help you with anything?',
      time: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // ── Promo Codes ──

  static final promoCodes = <PromoCodeModel>[
    PromoCodeModel(
      id: 'p1',
      code: 'SPRING25',
      title: '25% Off Spring Collection',
      description: 'Valid for all spring 2026 items',
      discountPercent: 25,
      minPurchase: 200000,
      expiresAt: DateTime(2026, 3, 31),
    ),
    PromoCodeModel(
      id: 'p2',
      code: 'WELCOME10',
      title: '10% Welcome Bonus',
      description: 'First purchase discount for new users',
      discountPercent: 10,
      expiresAt: DateTime(2026, 4, 15),
    ),
    PromoCodeModel(
      id: 'p3',
      code: 'SHOES30',
      title: '30% Off All Shoes',
      description: 'Shoe month special — all brands included',
      discountPercent: 30,
      minPurchase: 300000,
      expiresAt: DateTime(2026, 3, 20),
    ),
    PromoCodeModel(
      id: 'p4',
      code: 'FREESHIP',
      title: 'Free Delivery',
      description: 'Free shipping on any order, no minimum',
      discountPercent: 0,
      expiresAt: DateTime(2026, 3, 25),
    ),
    PromoCodeModel(
      id: 'p5',
      code: 'VIP50',
      title: '50% VIP Exclusive',
      description: 'Exclusive offer for VIP members only',
      discountPercent: 50,
      minPurchase: 500000,
      expiresAt: DateTime(2026, 2, 28),
      isUsed: true,
    ),
  ];

  // ── Notifications ──

  static final notifications = <NotificationModel>[
    NotificationModel(
      id: 'n1',
      type: NotificationType.order,
      title: 'Order Shipped',
      message: 'Your order #FS-2026002 has been shipped. Track your delivery in the orders section.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'n2',
      type: NotificationType.promo,
      title: 'Flash Sale — This Weekend Only!',
      message: 'Up to 50% off on selected items. Don\'t miss out on the biggest sale this spring!',
      time: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 'n3',
      type: NotificationType.priceDrop,
      title: 'Price Drop Alert',
      message: 'Silk Evening Blouse is now 20% cheaper. Grab it before the price goes back up!',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n4',
      type: NotificationType.system,
      title: 'Welcome to Fashion Shop!',
      message: 'Your account is ready. Enjoy your shopping experience with exclusive deals.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n5',
      type: NotificationType.chat,
      title: 'New Message',
      message: 'Premium Boutique sent you a message about your recent order.',
      time: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n6',
      type: NotificationType.order,
      title: 'Order Delivered',
      message: 'Your order #FS-2026001 has been delivered. Leave a review to help others!',
      time: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n7',
      type: NotificationType.promo,
      title: 'New Collection Available',
      message: 'Spring 2026 collection is live! Be the first to explore 200+ new styles.',
      time: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n8',
      type: NotificationType.system,
      title: 'Phone Number Verified',
      message: 'Your phone number has been successfully verified. Your account is now secure.',
      time: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n9',
      type: NotificationType.priceDrop,
      title: 'Wishlist Price Drop',
      message: 'Leather Biker Jacket just dropped from 799 000 to 599 000 sum!',
      time: DateTime.now().subtract(const Duration(days: 8)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n10',
      type: NotificationType.order,
      title: 'Order Cancelled',
      message: 'Your order #FS-2026005 has been cancelled. Refund will be processed within 3-5 days.',
      time: DateTime.now().subtract(const Duration(days: 9)),
      isRead: true,
    ),
  ];
}
