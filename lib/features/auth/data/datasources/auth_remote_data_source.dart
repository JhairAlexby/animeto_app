import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;

import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/core/services/api_service.dart';
import 'package:animeto_app/core/errors/error_utils.dart';
import 'package:animeto_app/features/auth/data/models/login_response_model.dart';
import 'package:animeto_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
  Future<LoginResponseModel> register(String name, String email, String password);
  Future<UserModel> getUserProfile();
  Future<void> uploadProfilePhoto(String imagePath);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<void> uploadProfilePhoto(String imagePath) async {
    try {
      final fileName = imagePath.split(RegExp(r'[\\/]')).last;
      final formData = dio.FormData.fromMap({
        'photo': await dio.MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        ),
      });

      final response = await apiService.dio.post(
        '/users/profile/photo',
        data: formData,
      );

      if (!((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true)) {
        throw ServerException(
          response.data['message'] ?? 'Error al subir la foto de perfil',
        );
      }
    } on DioException catch (e) {
      throw ServerException(messageFromDioException(e));
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }


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
      throw ServerException(messageFromDioException(e));
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<LoginResponseModel> register(
      String name, String email, String password) async {
    try {
      final response = await apiService.dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data['success'] == true) {
        return LoginResponseModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Error de registro',
        );
      }
    } on DioException catch (e) {
      throw ServerException(messageFromDioException(e));
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await apiService.dio.get('/users/profile');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
            response.data['message'] ?? 'Error al obtener el perfil');
      }
    } on DioException catch (e) {
      throw ServerException(messageFromDioException(e));
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }
}
