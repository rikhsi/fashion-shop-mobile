import 'package:flutter/material.dart';

enum CategoryLayout { horizontal, vertical }

class CategoryModel {
  final String id;
  final String title;
  final String icon;
  final CategoryLayout layout;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    this.layout = CategoryLayout.horizontal,
  });

  IconData get iconData => _iconMap[icon] ?? Icons.category_outlined;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      layout: json['layout'] == 'vertical'
          ? CategoryLayout.vertical
          : CategoryLayout.horizontal,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon': icon,
        'layout': layout == CategoryLayout.vertical ? 'vertical' : 'horizontal',
      };

  static const _iconMap = <String, IconData>{
    'woman_rounded': Icons.woman_rounded,
    'man_rounded': Icons.man_rounded,
    'ice_skating_outlined': Icons.ice_skating_outlined,
    'watch_outlined': Icons.watch_outlined,
    'auto_awesome_outlined': Icons.auto_awesome_outlined,
    'checkroom_outlined': Icons.checkroom_outlined,
    'dry_cleaning_outlined': Icons.dry_cleaning_outlined,
    'spa_outlined': Icons.spa_outlined,
    'location_on_outlined': Icons.location_on_outlined,
    'camera_alt_outlined': Icons.camera_alt_outlined,
    'design_services_outlined': Icons.design_services_outlined,
    'music_note_outlined': Icons.music_note_outlined,
    'directions_car_outlined': Icons.directions_car_outlined,
    'card_giftcard_outlined': Icons.card_giftcard_outlined,
    'flight_outlined': Icons.flight_outlined,
    'favorite_rounded': Icons.favorite_rounded,
    'child_care_outlined': Icons.child_care_outlined,
    'face_outlined': Icons.face_outlined,
    'shopping_bag_outlined': Icons.shopping_bag_outlined,
  };
}
