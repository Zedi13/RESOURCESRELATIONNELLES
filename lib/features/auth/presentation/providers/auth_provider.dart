import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    final user = _repository.login(email.trim(), password);
    if (user != null) {
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Email ou mot de passe incorrect.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));

    final success = _repository.register(name.trim(), email.trim(), password);
    if (success) {
      _currentUser = _repository.login(email.trim(), password);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Un compte avec cet email existe déjà.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  List<User> getAllUsers() => _repository.getAllUsers();

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
