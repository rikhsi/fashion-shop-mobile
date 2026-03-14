import 'package:flutter/material.dart';

import '../../../../shared/models/product.dart';
import '../models/catalog_category.dart';

abstract final class MockCatalogData {
  static const _clothingColor = Color(0xFFFFF0F5);
  static const _beautyColor = Color(0xFFF0FFF4);
  static const _venueColor = Color(0xFFFFF8E1);
  static const _photoColor = Color(0xFFE8F4FD);
  static const _decorColor = Color(0xFFFCE4EC);
  static const _entertainColor = Color(0xFFE8EAF6);
  static const _transportColor = Color(0xFFFFF3E0);
  static const _giftColor = Color(0xFFE0F7FA);
  static const _travelColor = Color(0xFFF3E5F5);

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

  static const List<CatalogCategory> rootCategories = [
    CatalogCategory(
      id: 'clothing',
      nameKey: 'catClothing',
      icon: Icons.checkroom_outlined,
      color: _clothingColor,
      children: [
        CatalogCategory(id: 'clothing_women', nameKey: 'catWomen', icon: Icons.woman_rounded, color: _clothingColor),
        CatalogCategory(id: 'clothing_men', nameKey: 'catMen', icon: Icons.man_rounded, color: _clothingColor),
        CatalogCategory(id: 'clothing_wedding', nameKey: 'catWedding', icon: Icons.favorite_rounded, color: _clothingColor),
        CatalogCategory(id: 'clothing_evening', nameKey: 'catEvening', icon: Icons.auto_awesome_outlined, color: _clothingColor),
        CatalogCategory(id: 'clothing_suits', nameKey: 'catSuits', icon: Icons.dry_cleaning_outlined, color: _clothingColor),
        CatalogCategory(id: 'clothing_kids', nameKey: 'catKids', icon: Icons.child_care_outlined, color: _clothingColor),
      ],
    ),
    CatalogCategory(id: 'beauty', nameKey: 'catBeauty', icon: Icons.spa_outlined, color: _beautyColor),
    CatalogCategory(id: 'venues', nameKey: 'catVenues', icon: Icons.location_on_outlined, color: _venueColor),
    CatalogCategory(id: 'photo', nameKey: 'catPhoto', icon: Icons.camera_alt_outlined, color: _photoColor),
    CatalogCategory(id: 'decor', nameKey: 'catDecor', icon: Icons.design_services_outlined, color: _decorColor),
    CatalogCategory(id: 'entertainment', nameKey: 'catEntertainment', icon: Icons.music_note_outlined, color: _entertainColor),
    CatalogCategory(id: 'transport', nameKey: 'catTransport', icon: Icons.directions_car_outlined, color: _transportColor),
    CatalogCategory(id: 'gifts', nameKey: 'catGifts', icon: Icons.card_giftcard_outlined, color: _giftColor),
    CatalogCategory(id: 'travel', nameKey: 'catTravel', icon: Icons.flight_outlined, color: _travelColor),
  ];

  static CatalogCategory? findCategoryById(String id) {
    for (final cat in rootCategories) {
      if (cat.id == id) return cat;
      for (final child in cat.children) {
        if (child.id == id) return child;
      }
    }
    return null;
  }

  static List<Product> productsForCategory(String? categoryId) {
    if (categoryId == null) return _allProducts;
    return _allProducts
        .where((p) => p.category == categoryId || p.category.startsWith(categoryId))
        .toList();
  }

  static List<Product> recommendedForCategory(String? categoryId) {
    final pool = categoryId == null ? _allProducts : productsForCategory(categoryId);
    return pool.take(4).toList();
  }

  static const List<Product> _allProducts = [
    Product(id: 'c1', name: 'Silk Wedding Dress', price: 2490000, placeholderColor: _cream, category: 'clothing_wedding', icon: Icons.dry_cleaning_outlined),
    Product(id: 'c2', name: 'Classic White Gown', price: 3200000, originalPrice: 4500000, placeholderColor: _rose, category: 'clothing_wedding', icon: Icons.dry_cleaning_outlined),
    Product(id: 'c3', name: 'Slim Fit Suit', price: 1890000, placeholderColor: _charcoal, category: 'clothing_suits', icon: Icons.dry_cleaning_outlined),
    Product(id: 'c4', name: 'Evening Dress Black', price: 1290000, placeholderColor: _charcoal, category: 'clothing_evening', icon: Icons.dry_cleaning_outlined),
    Product(id: 'c5', name: 'Floral Summer Dress', price: 349000, placeholderColor: _coral, category: 'clothing_women', isNew: true, icon: Icons.dry_cleaning_outlined),
    Product(id: 'c6', name: 'Linen Shirt', price: 249000, placeholderColor: _beige, category: 'clothing_men'),
    Product(id: 'c7', name: 'Denim Jacket', price: 399000, placeholderColor: _indigo, category: 'clothing_men', icon: Icons.dry_cleaning_outlined),
    Product(id: 'c8', name: 'Kids Hoodie', price: 189000, placeholderColor: _teal, category: 'clothing_kids', isNew: true, icon: Icons.dry_cleaning_outlined),
    Product(id: 'c9', name: 'Oversized Blazer', price: 599000, placeholderColor: _slate, category: 'clothing_women', icon: Icons.dry_cleaning_outlined),
    Product(id: 'c10', name: 'Cotton Polo', price: 179000, placeholderColor: _olive, category: 'clothing_men'),
    Product(id: 'c11', name: 'Maxi Skirt', price: 289000, placeholderColor: _rose, category: 'clothing_women', icon: Icons.dry_cleaning_outlined),
    Product(id: 'c12', name: 'Sport Leggings', price: 199000, placeholderColor: _teal, category: 'clothing_women'),
    Product(id: 'c13', name: 'Casual Sneakers', price: 459000, placeholderColor: _navy, category: 'clothing', icon: Icons.ice_skating_outlined),
    Product(id: 'c14', name: 'Leather Belt', price: 89000, placeholderColor: _charcoal, category: 'clothing', icon: Icons.watch_outlined),
    Product(id: 'c15', name: 'Face Cream Set', price: 320000, placeholderColor: _cream, category: 'beauty', icon: Icons.spa_outlined),
    Product(id: 'c16', name: 'Hair Styling Kit', price: 250000, placeholderColor: _rose, category: 'beauty', icon: Icons.spa_outlined),
    Product(id: 'c17', name: 'Wedding Venue Lux', price: 8900000, placeholderColor: _beige, category: 'venues', icon: Icons.location_on_outlined),
    Product(id: 'c18', name: 'Photo Session Pro', price: 1500000, placeholderColor: _indigo, category: 'photo', icon: Icons.camera_alt_outlined),
    Product(id: 'c19', name: 'Balloon Arch Decor', price: 450000, placeholderColor: _coral, category: 'decor', icon: Icons.design_services_outlined),
    Product(id: 'c20', name: 'DJ & Sound Package', price: 2000000, placeholderColor: _slate, category: 'entertainment', icon: Icons.music_note_outlined),
    Product(id: 'c21', name: 'Mercedes S-Class', price: 3500000, placeholderColor: _charcoal, category: 'transport', icon: Icons.directions_car_outlined),
    Product(id: 'c22', name: 'Gift Box Premium', price: 180000, placeholderColor: _teal, category: 'gifts', icon: Icons.card_giftcard_outlined),
    Product(id: 'c23', name: 'Honeymoon Tour', price: 12000000, placeholderColor: _indigo, category: 'travel', icon: Icons.flight_outlined),
    Product(id: 'c24', name: 'Cargo Pants Olive', price: 279000, placeholderColor: _olive, category: 'clothing_men'),
  ];
}
