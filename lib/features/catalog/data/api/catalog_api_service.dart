import '../../../../shared/models/product.dart';
import '../models/catalog_category.dart';

abstract class CatalogApiService {
  Future<List<CatalogCategory>> getRootCategories();
  Future<CatalogCategory?> getCategoryById(String id);
  Future<List<Product>> getProductsByCategory(String? categoryId);
  Future<List<Product>> getRecommendedForCategory(String? categoryId);
}
