import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  AuthRepositoryImpl(this._datasource);

  @override
  Future<User> login(String email, String password) =>
      _datasource.login(email, password);

  @override
  Future<User> register(String name, String email, String password) =>
      _datasource.register(name, email, password);

  @override
  Future<List<User>> getAllUsers() => _datasource.getAllUsers();

  @override
  Future<void> updateUserStatus(String userId, bool isVerified) =>
      _datasource.updateUserStatus(userId, isVerified);

  @override
  Future<User> activateUser(String userId) =>
      _datasource.activateUser(userId);

  @override
  Future<User> deactivateUser(String userId) =>
      _datasource.deactivateUser(userId);

  @override
  Future<User> createPrivilegedUser({
    required String nomComplet,
    required String email,
    required String motDePasse,
    required UserRole role,
  }) =>
      _datasource.createPrivilegedUser(
        nomComplet: nomComplet,
        email: email,
        motDePasse: motDePasse,
        role: role,
      );
}
