import 'package:shared_preferences/shared_preferences.dart';
import 'package:animeto_app/core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  static const String _tokenKey = 'AUTH_TOKEN';

  @override
  Future<void> cacheToken(String token) {
    try {
      return sharedPreferences.setString(_tokenKey, token);
    } catch (e) {
      throw CacheException();
    }
  }
}