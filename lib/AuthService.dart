import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUserId;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;

  Future<void> login(String userId) async {
    _isAuthenticated = true;
    _currentUserId = userId;
    notifyListeners(); // Уведомление провайдеров об изменении состояния
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _currentUserId = null;
    notifyListeners();
  }
}
