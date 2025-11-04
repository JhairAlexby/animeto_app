import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:animeto_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:animeto_app/features/auth/domain/entities/user.dart';
import 'package:animeto_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      final loginResponse = await remoteDataSource.login(email, password);
      await localDataSource.cacheToken(loginResponse.accessToken);
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
      return registerResponse.user;
    } on ServerException {
      rethrow;
    }
  }
}