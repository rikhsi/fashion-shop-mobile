import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final Color placeholderColor;
  final IconData icon;
  final String category;
  final bool isFavorite;
  final bool isNew;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.placeholderColor,
    this.icon = Icons.checkroom_outlined,
    required this.category,
    this.isFavorite = false,
    this.isNew = false,
    this.imageUrl,
  });

  int? get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((1 - price / originalPrice!) * 100).round();
  }

  String get formattedPrice => _formatPrice(price);
  String? get formattedOriginalPrice =>
      originalPrice != null ? _formatPrice(originalPrice!) : null;

  Product copyWith({bool? isFavorite}) =>
      Product(
        id: id,
        name: name,
        price: price,
        originalPrice: originalPrice,
        placeholderColor: placeholderColor,
        icon: icon,
        category: category,
        isFavorite: isFavorite ?? this.isFavorite,
        isNew: isNew,
        imageUrl: imageUrl,
      );

  static String _formatPrice(double value) {
    final str = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(' ');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}
