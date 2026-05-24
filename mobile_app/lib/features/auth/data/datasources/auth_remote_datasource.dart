import '../../domain/entities/user.dart';
import '../../../../core/network/api_client.dart';

class AuthRemoteDatasource {
  final ApiClient _client;
  AuthRemoteDatasource(this._client);

  Future<User> login(String email, String password) async {
    final data = await _client.post('/auth/login', {
          'email': email,
          'motDePasse': password,
        }) as Map<String, dynamic>;
    _client.setToken(data['token'] as String);
    return _toUser(data['utilisateur'] as Map<String, dynamic>);
  }

  Future<User> register(String name, String email, String password) async {
    final data = await _client.post('/auth/register', {
          'nomComplet': name,
          'email': email,
          'motDePasse': password,
        }) as Map<String, dynamic>;
    _client.setToken(data['token'] as String);
    return _toUser(data['utilisateur'] as Map<String, dynamic>);
  }

  Future<List<User>> getAllUsers() async {
    final data = await _client.get('/utilisateurs');
    final list = data is List
        ? data
        : (data as Map<String, dynamic>)['content'] as List? ?? [];
    return list.map((u) => _toUser(u as Map<String, dynamic>)).toList();
  }

  Future<void> updateUserStatus(String userId, bool isActive) async {
    await _client.patch('/utilisateurs/$userId/statut', {'estActif': isActive});
  }

  Future<User> activateUser(String userId) async {
    final data = await _client.patch('/utilisateurs/$userId/activer', {})
        as Map<String, dynamic>;
    return _toUser(data);
  }

  Future<User> deactivateUser(String userId) async {
    final data = await _client.patch('/utilisateurs/$userId/desactiver', {})
        as Map<String, dynamic>;
    return _toUser(data);
  }

  Future<User> createPrivilegedUser({
    required String nomComplet,
    required String email,
    required String motDePasse,
    required UserRole role,
  }) async {
    final data = await _client.post('/utilisateurs', {
      'nomComplet': nomComplet,
      'email': email,
      'motDePasse': motDePasse,
      'role': _fromRole(role),
    }) as Map<String, dynamic>;
    return _toUser(data);
  }

  static String _fromRole(UserRole role) {
    switch (role) {
      case UserRole.moderator:
        return 'MODERATEUR';
      case UserRole.admin:
        return 'ADMIN';
      case UserRole.superAdmin:
        return 'SUPER_ADMIN';
      default:
        return 'CITOYEN';
    }
  }

  static User _toUser(Map<String, dynamic> j) => User(
        id: j['id'].toString(),
        name: j['nomComplet'] as String? ?? '',
        email: j['email'] as String? ?? '',
        password: '',
        role: _toRole(j['role'] as String? ?? ''),
        isVerified: j['estVerifie'] as bool? ?? false,
        isActive: j['estActif'] as bool? ?? true,
        createdAt: DateTime.tryParse(j['dateInscription'] as String? ?? '') ??
            DateTime.now(),
        lastLogin: j['derniereConnexion'] != null
            ? DateTime.tryParse(j['derniereConnexion'] as String)
            : null,
      );

  static UserRole _toRole(String r) {
    switch (r.toUpperCase()) {
      case 'MODERATEUR':
        return UserRole.moderator;
      case 'ADMIN':
        return UserRole.admin;
      case 'SUPER_ADMIN':
        return UserRole.superAdmin;
      default:
        return UserRole.citizen;
    }
  }
}
