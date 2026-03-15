import '../../../home/data/models/card_model.dart';
import '../models/product_detail_model.dart';

abstract final class MockProductDetail {
  static ProductDetailModel fromCard(CardModel card) {
    final hash = card.id.hashCode.abs();
    final catId = card.categoryId == 'new' ? 'women' : card.categoryId;

    return ProductDetailModel(
      id: card.id,
      title: card.title,
      brand: _brands[catId] ?? 'Fashion Shop',
      description: _descriptions[catId] ?? _defaultDescription,
      gallery: [
        if (card.imageUrl != null) card.imageUrl!,
        ..._extraGallery[catId]!,
      ],
      basePrice: card.price,
      originalPrice: card.originalPrice,
      rating: _ratings[hash % _ratings.length],
      reviewCount: 23 + hash % 180,
      soldCount: 85 + hash % 450,
      optionGroups: _optionGroups[catId]!,
      specs: _specs[catId]!,
      reviews: _reviews,
    );
  }

  static const _ratings = [4.8, 4.5, 4.2, 4.6, 3.9, 4.7, 4.3, 4.1, 4.9, 4.4];

  static const _brands = {
    'women': 'Elegance Studio',
    'men': 'Urban Classic',
    'shoes': 'StepStyle',
    'accessories': 'Luxe & Co.',
  };

  static const _img = 'https://images.unsplash.com/';

  static const _extraGallery = {
    'women': [
      '${_img}photo-1434389677669-e08b4cda3a0b?w=600&h=800&fit=crop',
      '${_img}photo-1475180098004-ca77a66827be?w=600&h=800&fit=crop',
      '${_img}photo-1558618666-fcd25c85f82e?w=600&h=800&fit=crop',
      '${_img}photo-1445205170230-053b83016050?w=600&h=800&fit=crop',
    ],
    'men': [
      '${_img}photo-1516826957135-700dedea698c?w=600&h=800&fit=crop',
      '${_img}photo-1503341504253-dff4f37b0280?w=600&h=800&fit=crop',
      '${_img}photo-1487222477894-8943e31ef7b2?w=600&h=800&fit=crop',
      '${_img}photo-1529391409740-59f2cea08bc6?w=600&h=800&fit=crop',
    ],
    'shoes': [
      '${_img}photo-1556906781-9a412961c28c?w=600&h=800&fit=crop',
      '${_img}photo-1551107696-a4b0c5a0d9a2?w=600&h=800&fit=crop',
      '${_img}photo-1595341888016-a392ef81b7de?w=600&h=800&fit=crop',
      '${_img}photo-1606107557195-0e29a4b5b4aa?w=600&h=800&fit=crop',
    ],
    'accessories': [
      '${_img}photo-1524532787116-e70228437bbe?w=600&h=800&fit=crop',
      '${_img}photo-1591561954557-26941169b49e?w=600&h=800&fit=crop',
      '${_img}photo-1612902456551-404b5611f3d4?w=600&h=800&fit=crop',
      '${_img}photo-1606760227091-3dd870d97f1d?w=600&h=800&fit=crop',
    ],
  };

  static const _descriptions = {
    'women': 'Premium quality fabric with a modern silhouette. '
        'Designed for comfort and style, this piece features a flattering cut '
        'that works beautifully for both casual outings and special occasions. '
        'Machine washable. Imported.',
    'men': 'Crafted from premium cotton with attention to every detail. '
        'This versatile piece blends comfort with contemporary style, '
        'making it perfect for everyday wear or smart-casual events. '
        'Pre-shrunk fabric. True to size.',
    'shoes': 'Engineered for all-day comfort with cushioned insoles and breathable materials. '
        'Features a durable rubber outsole for excellent grip on any surface. '
        'Lightweight construction for effortless wear.',
    'accessories': 'Meticulously crafted using premium materials and expert craftsmanship. '
        'This accessory adds a touch of elegance to any outfit. '
        'Comes in a branded gift box, perfect for gifting.',
  };

  static const _defaultDescription =
      'High-quality product designed with attention to detail and premium materials.';

  static const _optionGroups = {
    'women': [
      ProductOptionGroup(name: 'Size', type: 'size', options: [
        ProductOption(id: 'xs', label: 'XS'),
        ProductOption(id: 's', label: 'S'),
        ProductOption(id: 'm', label: 'M'),
        ProductOption(id: 'l', label: 'L', priceModifier: 20000),
        ProductOption(id: 'xl', label: 'XL', priceModifier: 40000),
        ProductOption(id: 'xxl', label: 'XXL', priceModifier: 40000, inStock: false),
      ]),
      ProductOptionGroup(name: 'Color', type: 'color', options: [
        ProductOption(id: 'black', label: 'Black', colorValue: 0xFF1A1A1A, images: [
          '${_img}photo-1509631179647-0177331693ae?w=600&h=800&fit=crop',
          '${_img}photo-1485968579580-b6d095142e6e?w=600&h=800&fit=crop',
          '${_img}photo-1496747611176-843222e1e57c?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'white', label: 'White', colorValue: 0xFFF5F5F5, images: [
          '${_img}photo-1515886657613-9f3515b0c78f?w=600&h=800&fit=crop',
          '${_img}photo-1475180098004-ca77a66827be?w=600&h=800&fit=crop',
          '${_img}photo-1445205170230-053b83016050?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'rose', label: 'Rosé', colorValue: 0xFFE8A0BF, images: [
          '${_img}photo-1558618666-fcd25c85f82e?w=600&h=800&fit=crop',
          '${_img}photo-1434389677669-e08b4cda3a0b?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'navy', label: 'Navy', colorValue: 0xFF1E3A5F),
        ProductOption(id: 'beige', label: 'Beige', colorValue: 0xFFD4B896, inStock: false),
      ]),
    ],
    'men': [
      ProductOptionGroup(name: 'Size', type: 'size', options: [
        ProductOption(id: 's', label: 'S'),
        ProductOption(id: 'm', label: 'M'),
        ProductOption(id: 'l', label: 'L'),
        ProductOption(id: 'xl', label: 'XL', priceModifier: 25000),
        ProductOption(id: 'xxl', label: 'XXL', priceModifier: 50000),
      ]),
      ProductOptionGroup(name: 'Color', type: 'color', options: [
        ProductOption(id: 'black', label: 'Black', colorValue: 0xFF1A1A1A, images: [
          '${_img}photo-1516826957135-700dedea698c?w=600&h=800&fit=crop',
          '${_img}photo-1487222477894-8943e31ef7b2?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'charcoal', label: 'Charcoal', colorValue: 0xFF36454F, images: [
          '${_img}photo-1503341504253-dff4f37b0280?w=600&h=800&fit=crop',
          '${_img}photo-1529391409740-59f2cea08bc6?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'white', label: 'White', colorValue: 0xFFF5F5F5, images: [
          '${_img}photo-1552374196-1ab2a1c593e8?w=600&h=800&fit=crop',
          '${_img}photo-1507003211169-0a1dd7228f2d?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'olive', label: 'Olive', colorValue: 0xFF6B7B3C),
      ]),
    ],
    'shoes': [
      ProductOptionGroup(name: 'Size', type: 'size', options: [
        ProductOption(id: '38', label: '38'),
        ProductOption(id: '39', label: '39'),
        ProductOption(id: '40', label: '40'),
        ProductOption(id: '41', label: '41'),
        ProductOption(id: '42', label: '42'),
        ProductOption(id: '43', label: '43', priceModifier: 30000),
        ProductOption(id: '44', label: '44', priceModifier: 30000, inStock: false),
      ]),
      ProductOptionGroup(name: 'Color', type: 'color', options: [
        ProductOption(id: 'black', label: 'Black', colorValue: 0xFF1A1A1A, images: [
          '${_img}photo-1542291026-7eec264c27ff?w=600&h=800&fit=crop',
          '${_img}photo-1556906781-9a412961c28c?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'white', label: 'White', colorValue: 0xFFF5F5F5, images: [
          '${_img}photo-1606107557195-0e29a4b5b4aa?w=600&h=800&fit=crop',
          '${_img}photo-1595341888016-a392ef81b7de?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'red', label: 'Red', colorValue: 0xFFE53935, images: [
          '${_img}photo-1551107696-a4b0c5a0d9a2?w=600&h=800&fit=crop',
          '${_img}photo-1560769629-975ec94e6a86?w=600&h=800&fit=crop',
        ]),
      ]),
    ],
    'accessories': [
      ProductOptionGroup(name: 'Material', type: 'size', options: [
        ProductOption(id: 'standard', label: 'Standard'),
        ProductOption(id: 'premium', label: 'Premium', priceModifier: 100000),
        ProductOption(id: 'limited', label: 'Limited Ed.', priceModifier: 250000),
      ]),
      ProductOptionGroup(name: 'Color', type: 'color', options: [
        ProductOption(id: 'gold', label: 'Gold', colorValue: 0xFFD4AF37, images: [
          '${_img}photo-1524532787116-e70228437bbe?w=600&h=800&fit=crop',
          '${_img}photo-1612902456551-404b5611f3d4?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'silver', label: 'Silver', colorValue: 0xFFC0C0C0, images: [
          '${_img}photo-1591561954557-26941169b49e?w=600&h=800&fit=crop',
          '${_img}photo-1606760227091-3dd870d97f1d?w=600&h=800&fit=crop',
        ]),
        ProductOption(id: 'black', label: 'Black', colorValue: 0xFF1A1A1A),
        ProductOption(id: 'brown', label: 'Brown', colorValue: 0xFF8B4513),
      ]),
    ],
  };

  static const _specs = {
    'women': [
      ProductSpec(label: 'Material', value: '95% Polyester, 5% Elastane'),
      ProductSpec(label: 'Care', value: 'Machine wash cold, tumble dry low'),
      ProductSpec(label: 'Fit', value: 'Regular fit'),
      ProductSpec(label: 'Origin', value: 'Imported'),
      ProductSpec(label: 'Season', value: 'Spring / Summer 2026'),
    ],
    'men': [
      ProductSpec(label: 'Material', value: '100% Premium Cotton'),
      ProductSpec(label: 'Care', value: 'Machine wash, do not bleach'),
      ProductSpec(label: 'Fit', value: 'Slim fit'),
      ProductSpec(label: 'Origin', value: 'Turkey'),
      ProductSpec(label: 'Season', value: 'All seasons'),
    ],
    'shoes': [
      ProductSpec(label: 'Upper', value: 'Synthetic mesh + leather'),
      ProductSpec(label: 'Sole', value: 'Rubber outsole'),
      ProductSpec(label: 'Closure', value: 'Lace-up'),
      ProductSpec(label: 'Weight', value: '320g (size 42)'),
      ProductSpec(label: 'Origin', value: 'Vietnam'),
    ],
    'accessories': [
      ProductSpec(label: 'Material', value: 'Genuine leather / Stainless steel'),
      ProductSpec(label: 'Dimensions', value: 'See product description'),
      ProductSpec(label: 'Warranty', value: '1 year manufacturer warranty'),
      ProductSpec(label: 'Packaging', value: 'Branded gift box'),
      ProductSpec(label: 'Origin', value: 'Italy'),
    ],
  };

  static final _reviews = <ReviewModel>[
    ReviewModel(id: 'r1', userName: 'Sarah M.', rating: 5, comment: 'Absolutely love it! The quality is amazing and it fits perfectly. Would definitely recommend to anyone looking for something stylish yet comfortable.', date: DateTime.now().subtract(const Duration(days: 3))),
    ReviewModel(id: 'r2', userName: 'Alex K.', rating: 4, comment: 'Good product overall. The material feels premium and looks great. Shipping was a bit slow but the product made up for it.', date: DateTime.now().subtract(const Duration(days: 7))),
    ReviewModel(id: 'r3', userName: 'Diana R.', rating: 5, comment: 'The color is even more beautiful in person! Perfect for my spring wardrobe. Received many compliments already.', date: DateTime.now().subtract(const Duration(days: 12)), images: ['${_img}photo-1441986300917-64674bd600d8?w=200&h=200&fit=crop']),
    ReviewModel(id: 'r4', userName: 'Michael T.', rating: 3, comment: 'Expected better quality for the price. The stitching could be improved, but the overall design is nice.', date: DateTime.now().subtract(const Duration(days: 18))),
    ReviewModel(id: 'r5', userName: 'Nadia S.', rating: 5, comment: 'Best purchase this month! Exactly as shown in the photos. Will be ordering more items from this brand.', date: DateTime.now().subtract(const Duration(days: 22))),
    ReviewModel(id: 'r6', userName: 'James P.', rating: 4, comment: 'Nice design and comfortable to wear. True to size. The packaging was also very neat.', date: DateTime.now().subtract(const Duration(days: 30))),
    ReviewModel(id: 'r7', userName: 'Olga V.', rating: 2, comment: 'Size runs a bit small. Had to exchange for a larger one. Quality is okay but not exceptional.', date: DateTime.now().subtract(const Duration(days: 35))),
    ReviewModel(id: 'r8', userName: 'David L.', rating: 5, comment: 'Excellent craftsmanship and attention to detail. This is now my go-to for special occasions.', date: DateTime.now().subtract(const Duration(days: 45)), images: ['${_img}photo-1469334031218-e382a71b716b?w=200&h=200&fit=crop']),
  ];
}
