import '../models/banner_model.dart';
import '../models/card_model.dart';
import '../models/category_model.dart';

abstract class HomeDataSource {
  Future<List<BannerModel>> getBanners();
  Future<List<CategoryModel>> getCategories();
  Future<List<CardModel>> getCards(String categoryId);
  Future<List<CardModel>> getAllCards();
}
