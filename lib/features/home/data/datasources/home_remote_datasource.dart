import '../../../../core/network/api_client.dart';
import '../models/banner_model.dart';
import '../models/card_model.dart';
import '../models/category_model.dart';
import 'home_datasource.dart';

class HomeRemoteDataSource implements HomeDataSource {
  final ApiClient _client;

  HomeRemoteDataSource(this._client);

  @override
  Future<List<BannerModel>> getBanners() async {
    final response = await _client.get('/banners');
    return (response.data as List)
        .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _client.get('/categories');
    return (response.data as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CardModel>> getCards(String categoryId) async {
    final response = await _client.get('/categories/$categoryId/cards');
    return (response.data as List)
        .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
