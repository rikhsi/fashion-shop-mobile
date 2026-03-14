import 'package:flutter/material.dart';

import '../models/product.dart';

abstract final class MockProducts {
  static const _beige = Color(0xFFE8D5C4);
  static const _navy = Color(0xFF4A6FA5);
  static const _charcoal = Color(0xFF2D3436);
  static const _cream = Color(0xFFF5F0E8);
  static const _olive = Color(0xFF6B7B3C);
  static const _indigo = Color(0xFF5C7AEA);
  static const _coral = Color(0xFFE17055);
  static const _teal = Color(0xFF00B894);
  static const _rose = Color(0xFFE8A0BF);
  static const _slate = Color(0xFF636E72);

  static const List<Product> popular = [
    Product(id: '1', name: 'Oversized T-Shirt', price: 149000, placeholderColor: _beige, category: 'men'),
    Product(id: '2', name: 'Slim Fit Jeans', price: 299000, placeholderColor: _navy, category: 'men'),
    Product(id: '3', name: 'Cotton Hoodie', price: 249000, placeholderColor: _charcoal, category: 'men', icon: Icons.dry_cleaning_outlined),
    Product(id: '4', name: 'Silk Blouse', price: 189000, placeholderColor: _cream, category: 'women'),
    Product(id: '5', name: 'Cargo Pants', price: 279000, placeholderColor: _olive, category: 'men'),
    Product(id: '6', name: 'Denim Jacket', price: 399000, placeholderColor: _indigo, category: 'men', icon: Icons.dry_cleaning_outlined),
  ];

  static const List<Product> newArrivals = [
    Product(id: '7', name: 'Linen Dress', price: 349000, placeholderColor: _cream, category: 'women', isNew: true, icon: Icons.dry_cleaning_outlined),
    Product(id: '8', name: 'Sneakers Air', price: 459000, placeholderColor: _coral, category: 'shoes', isNew: true, icon: Icons.ice_skating_outlined),
    Product(id: '9', name: 'Leather Belt', price: 89000, placeholderColor: _charcoal, category: 'accessories', isNew: true, icon: Icons.watch_outlined),
    Product(id: '10', name: 'Summer Hat', price: 79000, placeholderColor: _beige, category: 'accessories', isNew: true, icon: Icons.face_outlined),
    Product(id: '11', name: 'Sport Leggings', price: 179000, placeholderColor: _teal, category: 'women', isNew: true),
  ];

  static const List<Product> specialOffers = [
    Product(id: '12', name: 'Winter Coat', price: 499000, originalPrice: 799000, placeholderColor: _charcoal, category: 'women', icon: Icons.dry_cleaning_outlined),
    Product(id: '13', name: 'Running Shoes', price: 329000, originalPrice: 459000, placeholderColor: _indigo, category: 'shoes', icon: Icons.ice_skating_outlined),
    Product(id: '14', name: 'Cashmere Scarf', price: 149000, originalPrice: 249000, placeholderColor: _rose, category: 'accessories', icon: Icons.watch_outlined),
    Product(id: '15', name: 'Classic Blazer', price: 449000, originalPrice: 599000, placeholderColor: _slate, category: 'men', icon: Icons.dry_cleaning_outlined),
  ];

  static const List<Product> recommended = [
    Product(id: '16', name: 'Pleated Skirt', price: 219000, placeholderColor: _rose, category: 'women', icon: Icons.dry_cleaning_outlined),
    Product(id: '17', name: 'Polo Shirt', price: 169000, placeholderColor: _teal, category: 'men'),
    Product(id: '18', name: 'Canvas Bag', price: 129000, placeholderColor: _cream, category: 'accessories', icon: Icons.shopping_bag_outlined),
    Product(id: '19', name: 'Ankle Boots', price: 529000, placeholderColor: _charcoal, category: 'shoes', icon: Icons.ice_skating_outlined),
    Product(id: '20', name: 'Wrap Dress', price: 289000, placeholderColor: _coral, category: 'women', icon: Icons.dry_cleaning_outlined),
  ];
}
