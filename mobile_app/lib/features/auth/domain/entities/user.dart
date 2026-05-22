enum UserRole { citizen, moderator, admin, superAdmin }

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserRole role;
  final bool isVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.isVerified,
    required this.createdAt,
  });

  String get roleLabel {
    switch (role) {
      case UserRole.citizen:
        return 'Citoyen';
      case UserRole.moderator:
        return 'Modérateur';
      case UserRole.admin:
        return 'Administrateur';
      case UserRole.superAdmin:
        return 'Super-Administrateur';
    }
  }

  bool get isAdmin => role == UserRole.admin || role == UserRole.superAdmin;
  bool get isModerator => role == UserRole.moderator || isAdmin;

  User copyWith({
    String? name,
    String? email,
    UserRole? role,
    bool? isVerified,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
    );
  }
}
