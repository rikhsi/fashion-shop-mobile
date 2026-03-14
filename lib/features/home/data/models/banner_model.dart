import 'dart:ui';

class BannerModel {
  final String id;
  final String? imageUrl;
  final String? link;
  final String title;
  final String subtitle;
  final int colorValue;
  final int textColorValue;

  const BannerModel({
    required this.id,
    this.imageUrl,
    this.link,
    required this.title,
    required this.subtitle,
    required this.colorValue,
    this.textColorValue = 0xFFFFFFFF,
  });

  Color get color => Color(colorValue);
  Color get textColor => Color(textColorValue);

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String?,
      link: json['link'] as String?,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      colorValue: json['color'] as int? ?? 0xFF000000,
      textColorValue: json['textColor'] as int? ?? 0xFFFFFFFF,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageUrl': imageUrl,
        'link': link,
        'title': title,
        'subtitle': subtitle,
        'color': colorValue,
        'textColor': textColorValue,
      };
}
