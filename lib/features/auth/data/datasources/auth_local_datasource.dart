import '../../domain/entities/user.dart';

class AuthLocalDatasource {
  final List<User> _users = [
    User(
      id: '1',
      name: 'Toto',
      email: 'Toto@gmail.com',
      password: 'test123',
      role: UserRole.citizen,
      isVerified: true,
      createdAt: DateTime(2024, 1, 15),
    ),
    User(
      id: '2',
      name: 'Bobito',
      email: 'bobito@gmail.com',
      password: 'bobito456',
      role: UserRole.citizen,
      isVerified: true,
      createdAt: DateTime(2024, 2, 20),
    ),
    User(
      id: '3',
      name: 'test2',
      email: 'test@example.com',
      password: 'moderateur123',
      role: UserRole.moderator,
      isVerified: true,
      createdAt: DateTime(2023, 11, 5),
    ),
    User(
      id: '4',
      name: 'Jeannetto',
      email: 'jannetto@gmail.com',
      password: 'admin123',
      role: UserRole.admin,
      isVerified: true,
      createdAt: DateTime(2023, 6, 1),
    ),
    User(
      id: '5',
      name: 'Superadmindefou',
      email: 'super@example.com',
      password: 'super123',
      role: UserRole.superAdmin,
      isVerified: true,
      createdAt: DateTime(2023, 1, 1),
    ),
  ];

  User? login(String email, String password) {
    try {
      return _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  bool register(String name, String email, String password) {
    if (_users.any((u) => u.email == email)) return false;
    _users.add(User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      password: password,
      role: UserRole.citizen,
      isVerified: false,
      createdAt: DateTime.now(),
    ));
    return true;
  }

  List<User> getAllUsers() => List.unmodifiable(_users);

  bool updateUserStatus(String userId, bool isVerified) {
    final idx = _users.indexWhere((u) => u.id == userId);
    if (idx == -1) return false;
    _users[idx] = _users[idx].copyWith(isVerified: isVerified);
    return true;
  }
}
