import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<List<User>> getAllUsers();
  Future<void> updateUserStatus(String userId, bool isVerified);
  Future<User> activateUser(String userId);
  Future<User> deactivateUser(String userId);
  Future<User> createPrivilegedUser({
    required String nomComplet,
    required String email,
    required String motDePasse,
    required UserRole role,
  });
}
