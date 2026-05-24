import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/type_relation_entity.dart';
import '../providers/resources_provider.dart';

class TypeRelationsManagementPage extends StatefulWidget {
  const TypeRelationsManagementPage({super.key});

  @override
  State<TypeRelationsManagementPage> createState() =>
      _TypeRelationsManagementPageState();
}

class _TypeRelationsManagementPageState
    extends State<TypeRelationsManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResourcesProvider>().loadTypeRelationEntities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Types de relation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
            onPressed: () =>
                context.read<ResourcesProvider>().loadTypeRelationEntities(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context, null),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        tooltip: 'Nouveau type de relation',
        child: const Icon(Icons.add),
      ),
      body: Consumer<ResourcesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingTypeRelations) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.typeRelationError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppTheme.error),
                  const SizedBox(height: 12),
                  Text(provider.typeRelationError!,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        provider.loadTypeRelationEntities(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          final types = provider.typeRelations;
          if (types.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline,
                      size: 64, color: AppTheme.textSecondary),
                  const SizedBox(height: 16),
                  const Text('Aucun type de relation',
                      style: TextStyle(
                          fontSize: 16, color: AppTheme.textSecondary)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showFormDialog(context, null),
                    icon: const Icon(Icons.add),
                    label: const Text('Créer le premier type'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: types.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) => _TypeRelationCard(
              typeRelation: types[i],
              onEdit: () => _showFormDialog(context, types[i]),
              onDelete: () => _confirmDelete(context, types[i]),
            ),
          );
        },
      ),
    );
  }

  void _showFormDialog(BuildContext context, TypeRelationEntity? existing) {
    showDialog(
      context: context,
      builder: (dialogContext) => _TypeRelationFormDialog(
        existing: existing,
        onSave: (libelle, description) async {
          final provider = context.read<ResourcesProvider>();
          try {
            if (existing == null) {
              await provider.createTypeRelation(
                libelle: libelle,
                description: description,
                ordre: 0,
              );
            } else {
              await provider.updateTypeRelation(
                id: existing.id,
                libelle: libelle,
                description: description,
                ordre: 0,
              );
            }
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(existing == null
                    ? 'Type de relation créé'
                    : 'Type de relation modifié'),
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

  void _confirmDelete(BuildContext context, TypeRelationEntity type) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer ce type ?'),
        content: Text(
          'Le type « ${type.libelle} » sera supprimé.\n'
          'Les ressources associées perdront ce type de relation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await context
                    .read<ResourcesProvider>()
                    .deleteTypeRelation(type.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Type de relation supprimé'),
                      backgroundColor: AppTheme.success,
                    ),
                  );
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
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

// ── Card ─────────────────────────────────────────────────────────────────────

class _TypeRelationCard extends StatelessWidget {
  final TypeRelationEntity typeRelation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TypeRelationCard({
    required this.typeRelation,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.people_outline,
              color: AppTheme.primary, size: 22),
        ),
        title: Text(
          typeRelation.libelle,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 15),
        ),
        subtitle: typeRelation.description.isNotEmpty
            ? Text(
                typeRelation.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ordre badge
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '#${typeRelation.ordre}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  size: 20, color: AppTheme.primary),
              tooltip: 'Modifier',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 20, color: AppTheme.error),
              tooltip: 'Supprimer',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Form Dialog ───────────────────────────────────────────────────────────────

class _TypeRelationFormDialog extends StatefulWidget {
  final TypeRelationEntity? existing;
  final Future<void> Function(String libelle, String description) onSave;

  const _TypeRelationFormDialog(
      {required this.existing, required this.onSave});

  @override
  State<_TypeRelationFormDialog> createState() =>
      _TypeRelationFormDialogState();
}

class _TypeRelationFormDialogState
    extends State<_TypeRelationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _libelleCtrl;
  late final TextEditingController _descCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final ex = widget.existing;
    _libelleCtrl = TextEditingController(text: ex?.libelle ?? '');
    _descCtrl = TextEditingController(text: ex?.description ?? '');
  }

  @override
  void dispose() {
    _libelleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Dialog(
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit
                    ? 'Modifier le type de relation'
                    : 'Nouveau type de relation',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),

              // Libellé
              TextFormField(
                controller: _libelleCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Libellé *',
                  hintText: 'ex : Couple, Famille…',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Libellé requis'
                    : null,
              ),
              const SizedBox(height: 14),

              // Description
              TextFormField(
                controller: _descCtrl,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brève description (optionnel)',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 14),

              const SizedBox(height: 28),

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
                                  strokeWidth: 2,
                                  color: Colors.white))
                          : Text(isEdit ? 'Enregistrer' : 'Créer'),
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
        _libelleCtrl.text.trim(),
        _descCtrl.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
