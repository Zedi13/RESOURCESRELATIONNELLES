import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  String _searchQuery = '';
  UserRole? _roleFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadUsers();
    });
  }

  List<User> _filteredUsers(List<User> users) {
    var result = users;
    if (_roleFilter != null) {
      result = result.where((u) => u.role == _roleFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((u) =>
              u.name.toLowerCase().contains(q) ||
              u.email.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isSuperAdmin = auth.currentUser?.role == UserRole.superAdmin;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
            onPressed: () => auth.loadUsers(),
          ),
        ],
      ),
      floatingActionButton: isSuperAdmin
          ? FloatingActionButton(
              onPressed: () => _showCreateUserDialog(context),
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              tooltip: 'Nouveau compte',
              child: const Icon(Icons.person_add_outlined),
            )
          : null,
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: auth.isLoadingUsers
                ? const Center(child: CircularProgressIndicator())
                : auth.usersError != null
                    ? _buildError(auth)
                    : _buildUserList(auth, isSuperAdmin),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un utilisateur…',
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              isDense: true,
              filled: true,
              fillColor: AppTheme.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _RoleChip(
                  label: 'Tous',
                  selected: _roleFilter == null,
                  color: AppTheme.primary,
                  onTap: () => setState(() => _roleFilter = null),
                ),
                const SizedBox(width: 8),
                _RoleChip(
                  label: 'Citoyens',
                  selected: _roleFilter == UserRole.citizen,
                  color: AppTheme.tertiary,
                  onTap: () => setState(() => _roleFilter = UserRole.citizen),
                ),
                const SizedBox(width: 8),
                _RoleChip(
                  label: 'Modérateurs',
                  selected: _roleFilter == UserRole.moderator,
                  color: AppTheme.warning,
                  onTap: () => setState(() => _roleFilter = UserRole.moderator),
                ),
                const SizedBox(width: 8),
                _RoleChip(
                  label: 'Admins',
                  selected: _roleFilter == UserRole.admin,
                  color: AppTheme.primary,
                  onTap: () => setState(() => _roleFilter = UserRole.admin),
                ),
                const SizedBox(width: 8),
                _RoleChip(
                  label: 'Super-admins',
                  selected: _roleFilter == UserRole.superAdmin,
                  color: AppTheme.secondary,
                  onTap: () =>
                      setState(() => _roleFilter = UserRole.superAdmin),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(AuthProvider auth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
          const SizedBox(height: 12),
          Text(auth.usersError!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => auth.loadUsers(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(AuthProvider auth, bool isSuperAdmin) {
    final users = _filteredUsers(auth.users);
    if (users.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline,
        title: 'Aucun utilisateur',
        subtitle: 'Aucun résultat pour ces critères',
      );
    }
    return RefreshIndicator(
      onRefresh: () => auth.loadUsers(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) => _UserCard(
          user: users[i],
          currentUser: auth.currentUser!,
          isSuperAdmin: isSuperAdmin,
          onToggleActive: (activate) =>
              _toggleActive(ctx, auth, users[i], activate),
        ),
      ),
    );
  }

  Future<void> _toggleActive(
      BuildContext context, AuthProvider auth, User user, bool activate) async {
    try {
      await auth.toggleUserActive(user.id, activate);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(activate
              ? '${user.name} activé(e)'
              : '${user.name} désactivé(e)'),
          backgroundColor: activate ? AppTheme.success : AppTheme.warning,
        ));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: AppTheme.error,
        ));
      }
    }
  }

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _CreateUserDialog(
        onSave: (name, email, pwd, role) async {
          final auth = context.read<AuthProvider>();
          try {
            await auth.createPrivilegedUser(
              nomComplet: name,
              email: email,
              motDePasse: pwd,
              role: role,
            );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Compte « $name » créé avec succès'),
                backgroundColor: AppTheme.success,
              ));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Erreur : $e'),
                backgroundColor: AppTheme.error,
              ));
            }
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// User Card
// ---------------------------------------------------------------------------

class _UserCard extends StatelessWidget {
  final User user;
  final User currentUser;
  final bool isSuperAdmin;
  final void Function(bool activate) onToggleActive;

  const _UserCard({
    required this.user,
    required this.currentUser,
    required this.isSuperAdmin,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final isSelf = user.id == currentUser.id;
    final roleColor = _roleColor(user.role);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
        border: !user.isActive
            ? Border.all(color: Colors.grey.shade200)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: user.isActive
                  ? roleColor.withOpacity(0.15)
                  : Colors.grey.shade100,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: user.isActive ? roleColor : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: user.isActive
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelf) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Moi',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      RoleBadge(
                        label: user.roleLabel,
                        color: roleColor,
                      ),
                      const SizedBox(width: 8),
                      if (!user.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('Désactivé',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Toggle active (admin only, not self)
            if (!isSelf && (isSuperAdmin || user.role == UserRole.citizen))
              Switch(
                value: user.isActive,
                onChanged: (v) => onToggleActive(v),
                activeColor: AppTheme.success,
              ),
          ],
        ),
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.citizen:
        return AppTheme.tertiary;
      case UserRole.moderator:
        return AppTheme.warning;
      case UserRole.admin:
        return AppTheme.primary;
      case UserRole.superAdmin:
        return AppTheme.secondary;
    }
  }
}

// ---------------------------------------------------------------------------
// Create User Dialog
// ---------------------------------------------------------------------------

class _CreateUserDialog extends StatefulWidget {
  final Future<void> Function(
      String name, String email, String pwd, UserRole role) onSave;

  const _CreateUserDialog({required this.onSave});

  @override
  State<_CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<_CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  UserRole _role = UserRole.moderator;
  bool _saving = false;
  bool _obscurePwd = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Créer un compte privilégié',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Réservé aux modérateurs, administrateurs et super-admins.',
                style:
                    TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),

              // Nom complet
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom complet *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Nom requis'
                    : null,
              ),
              const SizedBox(height: 14),

              // Email
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email requis';
                  if (!v.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Mot de passe
              TextFormField(
                controller: _pwdCtrl,
                obscureText: _obscurePwd,
                decoration: InputDecoration(
                  labelText: 'Mot de passe *',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePwd
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _obscurePwd = !_obscurePwd),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Mot de passe requis';
                  if (v.length < 8) return 'Minimum 8 caractères';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Role
              const Text('Rôle',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary)),
              const SizedBox(height: 10),
              _RoleSelector(
                selected: _role,
                onChanged: (r) => setState(() => _role = r),
              ),
              const SizedBox(height: 28),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saving ? null : _submit,
                      child: _saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Créer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _pwdCtrl.text,
        _role,
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ---------------------------------------------------------------------------
// Role selector chips
// ---------------------------------------------------------------------------

class _RoleSelector extends StatelessWidget {
  final UserRole selected;
  final ValueChanged<UserRole> onChanged;

  const _RoleSelector(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const options = [
      (UserRole.moderator, 'Modérateur', AppTheme.warning),
      (UserRole.admin, 'Administrateur', AppTheme.primary),
      (UserRole.superAdmin, 'Super-Admin', AppTheme.secondary),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final (role, label, color) = opt;
        final isSelected = selected == role;
        return GestureDetector(
          onTap: () => onChanged(role),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Role filter chip
// ---------------------------------------------------------------------------

class _RoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border:
              selected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}
