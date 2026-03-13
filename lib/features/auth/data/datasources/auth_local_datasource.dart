import '../../../../core/errors/exceptions.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> clearToken();
  Future<bool> hasToken();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  String? _cachedToken;

  AuthLocalDatasourceImpl();

  // TODO: Replace with SharedPreferences or secure storage

  @override
  Future<void> cacheToken(String token) async {
    try {
      _cachedToken = token;
    } catch (e) {
      throw const CacheException(message: 'Failed to cache token');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    return _cachedToken;
  }

  @override
  Future<void> clearToken() async {
    try {
      _cachedToken = null;
    } catch (e) {
      throw const CacheException(message: 'Failed to clear token');
    }
  }

  @override
  Future<bool> hasToken() async {
    return _cachedToken != null;
  }
}
