import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/core/services/api_service.dart';
import 'package:animeto_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:animeto_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:animeto_app/features/auth/domain/entities/user.dart';
import 'package:animeto_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ApiService apiService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.apiService,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      final loginResponse = await remoteDataSource.login(email, password);
      await localDataSource.cacheToken(loginResponse.accessToken);
      apiService.setAuthToken(loginResponse.accessToken);
      return loginResponse.user;
    } on ServerException {
      rethrow;
    }
  }


  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final registerResponse =
          await remoteDataSource.register(name, email, password);
      await localDataSource.cacheToken(registerResponse.accessToken);
      apiService.setAuthToken(registerResponse.accessToken);
      return registerResponse.user;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<User> getUserProfile() async {
    try {
      final user = await remoteDataSource.getUserProfile();
      return user;
    } on ServerException {
      rethrow;
    }
  }

  @override
  Future<void> uploadProfilePhoto(String imagePath) async {
    try {
      await remoteDataSource.uploadProfilePhoto(imagePath);
    } on ServerException {
      rethrow;
    }
  }
}