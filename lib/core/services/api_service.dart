import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  Dio get dio => _dio;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://animeto-api-production.up.railway.app/api',
            connectTimeout: const Duration(milliseconds: 5000),
            receiveTimeout: const Duration(milliseconds: 3000),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
}