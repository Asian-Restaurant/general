import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUserId;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;

  // Метод для имитации входа пользователя
  Future<void> login(String userId) async {
    // Здесь можно добавить логику проверки учетных данных
    _isAuthenticated = true;
    _currentUserId = userId;
    notifyListeners();
  }

  // Метод для выхода пользователя
  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUserId = null;
    notifyListeners();
  }
}