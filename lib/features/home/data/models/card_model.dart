class CardModel {
  final String id;
  final String title;
  final String? imageUrl;
  final double price;
  final double? originalPrice;
  final String categoryId;
  final bool isNew;
  final bool isFavorite;

  const CardModel({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.categoryId,
    this.isNew = false,
    this.isFavorite = false,
  });

  int? get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return null;
    return ((1 - price / originalPrice!) * 100).round();
  }

  String get formattedPrice => _formatPrice(price);
  String? get formattedOriginalPrice =>
      originalPrice != null ? _formatPrice(originalPrice!) : null;

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      categoryId: json['categoryId'] as String,
      isNew: json['isNew'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': imageUrl,
        'price': price,
        'originalPrice': originalPrice,
        'categoryId': categoryId,
        'isNew': isNew,
        'isFavorite': isFavorite,
      };

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
