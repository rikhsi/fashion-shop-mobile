import '../../../../shared/models/product.dart';
import '../api/catalog_api_service.dart';
import '../models/catalog_category.dart';
import 'mock_catalog_data.dart';

class MockCatalogApiService implements CatalogApiService {
  static const _delay = Duration(milliseconds: 500);

  @override
  Future<List<CatalogCategory>> getRootCategories() async {
    await Future.delayed(_delay);
    return MockCatalogData.rootCategories;
  }

  @override
  Future<CatalogCategory?> getCategoryById(String id) async {
    await Future.delayed(_delay);
    return MockCatalogData.findCategoryById(id);
  }

  @override
  Future<List<Product>> getProductsByCategory(String? categoryId) async {
    await Future.delayed(_delay);
    return MockCatalogData.productsForCategory(categoryId);
  }

  @override
  Future<List<Product>> getRecommendedForCategory(String? categoryId) async {
    await Future.delayed(_delay);
    return MockCatalogData.recommendedForCategory(categoryId);
  }
}
