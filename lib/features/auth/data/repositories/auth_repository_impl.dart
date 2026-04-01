import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  User? login(String email, String password) =>
      _datasource.login(email, password);

  @override
  bool register(String name, String email, String password) =>
      _datasource.register(name, email, password);

  @override
  List<User> getAllUsers() => _datasource.getAllUsers();

  @override
  bool updateUserStatus(String userId, bool isVerified) =>
      _datasource.updateUserStatus(userId, isVerified);
}
