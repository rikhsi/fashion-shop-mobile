import '../../../../core/errors/exceptions.dart';

abstract class AuthLocalDatasource {
  Future<void> cacheToken(String token);
  Future<void> cachePhoneNumber(String phoneNumber);
  Future<String?> getCachedToken();
  Future<String?> getCachedPhoneNumber();
  Future<void> clearToken();
  Future<bool> hasToken();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  String? _cachedToken;
  String? _cachedPhoneNumber;

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
  Future<void> cachePhoneNumber(String phoneNumber) async {
    try {
      _cachedPhoneNumber = phoneNumber;
    } catch (e) {
      throw const CacheException(message: 'Failed to cache phone number');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    return _cachedToken;
  }

  @override
  Future<String?> getCachedPhoneNumber() async {
    return _cachedPhoneNumber;
  }

  @override
  Future<void> clearToken() async {
    try {
      _cachedToken = null;
      _cachedPhoneNumber = null;
    } catch (e) {
      throw const CacheException(message: 'Failed to clear token');
    }
  }

  @override
  Future<bool> hasToken() async {
    return _cachedToken != null;
  }
}
