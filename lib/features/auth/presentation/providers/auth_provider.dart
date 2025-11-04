import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    _setLoading(false);
  }

  Future<void> register(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    _setLoading(false);
  }
}