import 'package:animeto_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<User> getUserProfile();
  Future<void> uploadProfilePhoto(String imagePath);
}