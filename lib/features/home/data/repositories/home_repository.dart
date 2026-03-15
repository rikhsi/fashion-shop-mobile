import '../datasources/home_datasource.dart';
import '../models/banner_model.dart';
import '../models/card_model.dart';
import '../models/category_model.dart';

class HomeRepository {
  final HomeDataSource _dataSource;

  HomeRepository(this._dataSource);

  Future<List<BannerModel>> getBanners() => _dataSource.getBanners();
  Future<List<CategoryModel>> getCategories() => _dataSource.getCategories();
  Future<List<CardModel>> getCards(String categoryId) =>
      _dataSource.getCards(categoryId);
  Future<List<CardModel>> getAllCards() => _dataSource.getAllCards();
}
