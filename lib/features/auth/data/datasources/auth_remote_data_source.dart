import 'package:dio/dio.dart';
import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/core/services/api_service.dart';
import 'package:animeto_app/features/auth/data/models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await apiService.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return LoginResponseModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
            response.data['message'] ?? 'Error de inicio de sesión');
      }
    } on DioException catch (e) {
      throw ServerException(
          e.response?.data['message'] ?? 'Error de red: ${e.message}');
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }
}