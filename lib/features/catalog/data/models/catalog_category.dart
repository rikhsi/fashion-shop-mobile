import 'package:flutter/material.dart';

import '../../../../shared/models/product.dart';

class CatalogCategory {
  final String id;
  final String nameKey;
  final IconData icon;
  final Color color;
  final List<CatalogCategory> children;
  final List<Product> products;

  const CatalogCategory({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.color,
    this.children = const [],
    this.products = const [],
  });

  bool get hasChildren => children.isNotEmpty;
}
