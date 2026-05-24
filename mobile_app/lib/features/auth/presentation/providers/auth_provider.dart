import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;
  AuthProvider(this._repository);

  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  List<User> _users = [];
  bool _isLoadingUsers = false;
  String? _usersError;

  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  List<User> get users => _users;
  bool get isLoadingUsers => _isLoadingUsers;
  String? get usersError => _usersError;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _repository.login(email.trim(), password);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _currentUser = await _repository.register(name.trim(), email.trim(), password);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadUsers() async {
    _isLoadingUsers = true;
    _usersError = null;
    notifyListeners();
    try {
      _users = await _repository.getAllUsers();
    } catch (e) {
      _usersError = e.toString();
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }

  Future<void> toggleUserActive(String userId, bool activate) async {
    try {
      final updated = activate
          ? await _repository.activateUser(userId)
          : await _repository.deactivateUser(userId);
      final idx = _users.indexWhere((u) => u.id == userId);
      if (idx != -1) {
        _users[idx] = updated;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> createPrivilegedUser({
    required String nomComplet,
    required String email,
    required String motDePasse,
    required UserRole role,
  }) async {
    final created = await _repository.createPrivilegedUser(
      nomComplet: nomComplet,
      email: email,
      motDePasse: motDePasse,
      role: role,
    );
    _users.insert(0, created);
    notifyListeners();
    return created;
  }

  // kept for backward compat
  Future<List<User>> getAllUsers() => _repository.getAllUsers();

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
