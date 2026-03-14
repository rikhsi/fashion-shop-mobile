import '../models/banner_model.dart';
import '../models/card_model.dart';
import '../models/category_model.dart';
import 'home_datasource.dart';

class HomeMockDataSource implements HomeDataSource {
  @override
  Future<List<BannerModel>> getBanners() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _banners;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _categories;
  }

  @override
  Future<List<CardModel>> getCards(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (categoryId == 'new') {
      return _cards.where((c) => c.isNew).toList();
    }
    return _cards.where((c) => c.categoryId == categoryId).toList();
  }

  // ── Banners ──

  static const _banners = <BannerModel>[
    BannerModel(
      id: '1',
      title: 'Spring Sale — Up to 50% Off',
      subtitle: 'New spring collection available now',
      colorValue: 0xFFEA7C7C,
      imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&h=400&fit=crop',
    ),
    BannerModel(
      id: '2',
      title: 'Free Delivery',
      subtitle: 'On orders over 200 000 sum',
      colorValue: 0xFFE17055,
      imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=800&h=400&fit=crop',
    ),
    BannerModel(
      id: '3',
      title: 'New Arrivals',
      subtitle: 'Fresh styles every week',
      colorValue: 0xFF00B894,
      imageUrl: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?w=800&h=400&fit=crop',
    ),
  ];

  // ── Categories ──

  static const _categories = <CategoryModel>[
    CategoryModel(id: 'women', title: 'Women', icon: 'woman_rounded', layout: CategoryLayout.horizontal),
    CategoryModel(id: 'men', title: 'Men', icon: 'man_rounded', layout: CategoryLayout.vertical),
    CategoryModel(id: 'shoes', title: 'Shoes', icon: 'ice_skating_outlined', layout: CategoryLayout.horizontal),
    CategoryModel(id: 'accessories', title: 'Accessories', icon: 'watch_outlined', layout: CategoryLayout.vertical),
    CategoryModel(id: 'new', title: 'New Arrivals', icon: 'auto_awesome_outlined', layout: CategoryLayout.horizontal),
  ];

  // ── Cards ──

  static const _img = 'https://images.unsplash.com/';

  static const _cards = <CardModel>[
    // ── Women ──
    CardModel(id: 'w1', title: 'Silk Evening Blouse', imageUrl: '${_img}photo-1564257631407-4deb1f99d992?w=400&h=500&fit=crop', price: 189000, categoryId: 'women'),
    CardModel(id: 'w2', title: 'Summer Maxi Dress', imageUrl: '${_img}photo-1572804013309-59a88b7e92f1?w=400&h=500&fit=crop', price: 349000, categoryId: 'women', isNew: true),
    CardModel(id: 'w3', title: 'Designer Cocktail Dress', imageUrl: '${_img}photo-1515886657613-9f3515b0c78f?w=400&h=500&fit=crop', price: 459000, categoryId: 'women'),
    CardModel(id: 'w4', title: 'Elegant Day Dress', imageUrl: '${_img}photo-1496747611176-843222e1e57c?w=400&h=500&fit=crop', price: 279000, categoryId: 'women'),
    CardModel(id: 'w5', title: 'Casual Pink Outfit', imageUrl: '${_img}photo-1539109136881-3be0616acf4b?w=400&h=500&fit=crop', price: 199000, categoryId: 'women', isNew: true),
    CardModel(id: 'w6', title: 'Wool Winter Coat', imageUrl: '${_img}photo-1485462537746-965f33f7f6a7?w=400&h=500&fit=crop', price: 599000, originalPrice: 799000, categoryId: 'women'),
    CardModel(id: 'w7', title: 'White Linen Set', imageUrl: '${_img}photo-1509631179647-0177331693ae?w=400&h=500&fit=crop', price: 249000, categoryId: 'women'),
    CardModel(id: 'w8', title: 'Floral Print Dress', imageUrl: '${_img}photo-1583496661160-fb5886a0aaaa?w=400&h=500&fit=crop', price: 229000, categoryId: 'women'),
    CardModel(id: 'w9', title: 'Light Summer Dress', imageUrl: '${_img}photo-1594938298603-c8148c4dae35?w=400&h=500&fit=crop', price: 179000, categoryId: 'women'),
    CardModel(id: 'w10', title: 'Striped Midi Dress', imageUrl: '${_img}photo-1490481651871-ab68de25d43d?w=400&h=500&fit=crop', price: 269000, categoryId: 'women'),

    // ── Men ──
    CardModel(id: 'm1', title: 'Casual Street Style', imageUrl: '${_img}photo-1617137984095-74e4e5e3613f?w=400&h=500&fit=crop', price: 189000, categoryId: 'men'),
    CardModel(id: 'm2', title: 'Classic White T-Shirt', imageUrl: '${_img}photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop', price: 89000, categoryId: 'men'),
    CardModel(id: 'm3', title: 'Premium Cotton Tee', imageUrl: '${_img}photo-1593030761757-71fae45fa0e7?w=400&h=500&fit=crop', price: 129000, categoryId: 'men'),
    CardModel(id: 'm4', title: 'Leather Biker Jacket', imageUrl: '${_img}photo-1552374196-1ab2a1c593e8?w=400&h=500&fit=crop', price: 599000, originalPrice: 799000, categoryId: 'men'),
    CardModel(id: 'm5', title: 'Tailored Navy Suit', imageUrl: '${_img}photo-1519085360753-af0119f7cbe7?w=400&h=500&fit=crop', price: 899000, categoryId: 'men'),
    CardModel(id: 'm6', title: 'Smart Casual Look', imageUrl: '${_img}photo-1488161628813-04466f0bb6d7?w=400&h=500&fit=crop', price: 249000, categoryId: 'men'),
    CardModel(id: 'm7', title: 'Relaxed Fit Shirt', imageUrl: '${_img}photo-1507003211169-0a1dd7228f2d?w=400&h=500&fit=crop', price: 169000, categoryId: 'men'),
    CardModel(id: 'm8', title: 'Modern Slim Fit', imageUrl: '${_img}photo-1506794778202-cad84cf45f1d?w=400&h=500&fit=crop', price: 199000, categoryId: 'men'),
    CardModel(id: 'm9', title: 'Weekend Casual Set', imageUrl: '${_img}photo-1480455624313-e29b44bbfde1?w=400&h=500&fit=crop', price: 219000, categoryId: 'men', isNew: true),
    CardModel(id: 'm10', title: 'Urban Hoodie', imageUrl: '${_img}photo-1611312449412-6cefac5dc3e4?w=400&h=500&fit=crop', price: 179000, categoryId: 'men'),

    // ── Shoes ──
    CardModel(id: 's1', title: 'Air Max Sneakers', imageUrl: '${_img}photo-1542291026-7eec264c27ff?w=400&h=500&fit=crop', price: 459000, categoryId: 'shoes'),
    CardModel(id: 's2', title: 'Running Performance', imageUrl: '${_img}photo-1460353581641-37baddab0fa2?w=400&h=500&fit=crop', price: 389000, categoryId: 'shoes'),
    CardModel(id: 's3', title: 'Retro Colorway', imageUrl: '${_img}photo-1549298916-b41d501d3772?w=400&h=500&fit=crop', price: 349000, categoryId: 'shoes'),
    CardModel(id: 's4', title: 'Classic White Kicks', imageUrl: '${_img}photo-1543163521-1bf539c55dd2?w=400&h=500&fit=crop', price: 299000, categoryId: 'shoes', isNew: true),
    CardModel(id: 's5', title: 'Air Jordan Style', imageUrl: '${_img}photo-1595950653106-6c9ebd614d3a?w=400&h=500&fit=crop', price: 529000, categoryId: 'shoes'),
    CardModel(id: 's6', title: 'Street Sneakers Duo', imageUrl: '${_img}photo-1600269452121-4f2416e55c28?w=400&h=500&fit=crop', price: 399000, originalPrice: 499000, categoryId: 'shoes'),
    CardModel(id: 's7', title: 'Chelsea Leather Boots', imageUrl: '${_img}photo-1608231387042-66d1773070a5?w=400&h=500&fit=crop', price: 479000, categoryId: 'shoes'),
    CardModel(id: 's8', title: 'Sport Training Shoes', imageUrl: '${_img}photo-1606107557195-0e29a4b5b4aa?w=400&h=500&fit=crop', price: 329000, categoryId: 'shoes'),
    CardModel(id: 's9', title: 'Suede Ankle Boots', imageUrl: '${_img}photo-1605348532760-6753d2c43329?w=400&h=500&fit=crop', price: 449000, categoryId: 'shoes', isNew: true),
    CardModel(id: 's10', title: 'Elegant High Heels', imageUrl: '${_img}photo-1511556820780-d912e42b4980?w=400&h=500&fit=crop', price: 369000, categoryId: 'shoes'),

    // ── Accessories ──
    CardModel(id: 'a1', title: 'Luxury Watch Gold', imageUrl: '${_img}photo-1523170335258-f5ed11844a49?w=400&h=500&fit=crop', price: 1290000, categoryId: 'accessories'),
    CardModel(id: 'a2', title: 'Canvas Backpack', imageUrl: '${_img}photo-1553062407-98eeb64c6a62?w=400&h=500&fit=crop', price: 189000, categoryId: 'accessories'),
    CardModel(id: 'a3', title: 'Designer Handbag Set', imageUrl: '${_img}photo-1548036328-c9fa89d128fa?w=400&h=500&fit=crop', price: 459000, categoryId: 'accessories'),
    CardModel(id: 'a4', title: 'Premium Sunglasses', imageUrl: '${_img}photo-1611923134239-b9be5816e23c?w=400&h=500&fit=crop', price: 249000, originalPrice: 349000, categoryId: 'accessories'),
    CardModel(id: 'a5', title: 'Smart Watch Pro', imageUrl: '${_img}photo-1590874103328-eac38a683ce7?w=400&h=500&fit=crop', price: 890000, categoryId: 'accessories', isNew: true),
    CardModel(id: 'a6', title: 'Leather Tote Bag', imageUrl: '${_img}photo-1584917865442-de89df76afd3?w=400&h=500&fit=crop', price: 399000, categoryId: 'accessories'),
    CardModel(id: 'a7', title: 'Gold Chain Necklace', imageUrl: '${_img}photo-1606760227091-3dd870d97f1d?w=400&h=500&fit=crop', price: 329000, categoryId: 'accessories', isNew: true),
    CardModel(id: 'a8', title: 'Summer Straw Hat', imageUrl: '${_img}photo-1575032617751-6ddec2089882?w=400&h=500&fit=crop', price: 89000, categoryId: 'accessories'),
    CardModel(id: 'a9', title: 'Cashmere Wool Scarf', imageUrl: '${_img}photo-1473188588951-7c24b3da7255?w=400&h=500&fit=crop', price: 179000, categoryId: 'accessories'),
    CardModel(id: 'a10', title: 'Italian Leather Belt', imageUrl: '${_img}photo-1602173574767-37ac01994b2a?w=400&h=500&fit=crop', price: 149000, categoryId: 'accessories'),

    // ── New Arrivals ──
    CardModel(id: 'n1', title: 'Trendy Street Fashion', imageUrl: '${_img}photo-1558618666-fcd25c85f82e?w=400&h=500&fit=crop', price: 299000, categoryId: 'new', isNew: true),
    CardModel(id: 'n2', title: 'Vintage Wardrobe Edit', imageUrl: '${_img}photo-1469334031218-e382a71b716b?w=400&h=500&fit=crop', price: 349000, categoryId: 'new', isNew: true),
    CardModel(id: 'n3', title: 'Runway Collection', imageUrl: '${_img}photo-1445205170230-053b83016050?w=400&h=500&fit=crop', price: 599000, categoryId: 'new', isNew: true),
    CardModel(id: 'n4', title: 'Spring Outfit Ideas', imageUrl: '${_img}photo-1492707892479-7bc8d5a4ee93?w=400&h=500&fit=crop', price: 249000, categoryId: 'new', isNew: true),
    CardModel(id: 'n5', title: 'Beach Summer Style', imageUrl: '${_img}photo-1487222477894-8943e31ef7b2?w=400&h=500&fit=crop', price: 189000, categoryId: 'new', isNew: true),
    CardModel(id: 'n6', title: 'Editorial Fashion Set', imageUrl: '${_img}photo-1475180098004-ca77a66827be?w=400&h=500&fit=crop', price: 399000, categoryId: 'new', isNew: true),
    CardModel(id: 'n7', title: 'Modern Minimal Look', imageUrl: '${_img}photo-1529139574466-a303027c1d8b?w=400&h=500&fit=crop', price: 279000, categoryId: 'new', isNew: true),
    CardModel(id: 'n8', title: 'Shopping Day Outfit', imageUrl: '${_img}photo-1483985988355-763728e1935b?w=400&h=500&fit=crop', price: 219000, categoryId: 'new', isNew: true),
    CardModel(id: 'n9', title: 'Premium Casual Wear', imageUrl: '${_img}photo-1441984904996-e0b6ba687e04?w=400&h=500&fit=crop', price: 329000, categoryId: 'new', isNew: true),
    CardModel(id: 'n10', title: 'Fashion Week Special', imageUrl: '${_img}photo-1469334031218-e382a71b716b?w=400&h=500&fit=crop', price: 459000, categoryId: 'new', isNew: true),
  ];
}
