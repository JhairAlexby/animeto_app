import 'package:flutter/material.dart';
import 'package:animeto_app/core/errors/exceptions.dart';
import 'package:animeto_app/features/auth/domain/entities/user.dart';
import 'package:animeto_app/features/auth/domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({required this.authRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _user = await authRepository.login(email, password);
      _setLoading(false);
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final registeredUser =
          await authRepository.register(name, email, password);
      _user = registeredUser;
      _setLoading(false);
      return true;
    } on ServerException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    }
  }
}