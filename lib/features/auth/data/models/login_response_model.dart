import 'package:animeto_app/features/auth/data/models/user_model.dart';

class LoginResponseModel {
  final UserModel user;
  final String accessToken;

  LoginResponseModel({
    required this.user,
    required this.accessToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['accessToken'],
    );
  }
}