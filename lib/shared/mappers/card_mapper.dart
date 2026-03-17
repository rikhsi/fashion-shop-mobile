import 'package:flutter/material.dart';

import '../../features/home/data/models/card_model.dart';
import '../models/product.dart';

export '../../core/utils/format_utils.dart' show formatPrice;

Product cardToProduct(CardModel card, {bool isFavorite = false}) {
  const colors = [
    Color(0xFFE8D5C4),
    Color(0xFF4A6FA5),
    Color(0xFF2D3436),
    Color(0xFFF5F0E8),
    Color(0xFF6B7B3C),
    Color(0xFF5C7AEA),
    Color(0xFFE17055),
    Color(0xFF00B894),
    Color(0xFFE8A0BF),
    Color(0xFF636E72),
  ];
  const categoryIcons = <String, IconData>{
    'women': Icons.dry_cleaning_outlined,
    'men': Icons.checkroom_outlined,
    'shoes': Icons.ice_skating_outlined,
    'accessories': Icons.watch_outlined,
    'new': Icons.auto_awesome_outlined,
  };

  return Product(
    id: card.id,
    name: card.title,
    price: card.price,
    originalPrice: card.originalPrice,
    placeholderColor: colors[card.id.hashCode.abs() % colors.length],
    icon: categoryIcons[card.categoryId] ?? Icons.checkroom_outlined,
    category: card.categoryId,
    isNew: card.isNew,
    isFavorite: isFavorite,
    imageUrl: card.imageUrl,
  );
}
