import '../entities/user.dart';

abstract class AuthRepository {
  User? login(String email, String password);
  bool register(String name, String email, String password);
  List<User> getAllUsers();
  bool updateUserStatus(String userId, bool isVerified);
}
