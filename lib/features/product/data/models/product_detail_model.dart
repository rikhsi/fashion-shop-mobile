class ProductDetailModel {
  final String id;
  final String title;
  final String brand;
  final String description;
  final List<String> gallery;
  final double basePrice;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final List<ProductOptionGroup> optionGroups;
  final List<ProductSpec> specs;
  final List<ReviewModel> reviews;

  const ProductDetailModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.gallery,
    required this.basePrice,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.optionGroups,
    required this.specs,
    required this.reviews,
  });
}

class ProductOptionGroup {
  final String name;
  final String type; // 'size', 'color'
  final List<ProductOption> options;

  const ProductOptionGroup({
    required this.name,
    required this.type,
    required this.options,
  });
}

class ProductOption {
  final String id;
  final String label;
  final int? colorValue;
  final double priceModifier;
  final bool inStock;
  final List<String>? images;

  const ProductOption({
    required this.id,
    required this.label,
    this.colorValue,
    this.priceModifier = 0,
    this.inStock = true,
    this.images,
  });
}

class ProductSpec {
  final String label;
  final String value;

  const ProductSpec({required this.label, required this.value});
}

class ReviewModel {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;
  final List<String>? images;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    this.images,
  });
}
