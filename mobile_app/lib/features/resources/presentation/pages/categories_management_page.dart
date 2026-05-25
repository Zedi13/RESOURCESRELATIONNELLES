import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/category.dart';
import '../providers/resources_provider.dart';

// Available icon options for categories
const _iconOptions = <String, IconData>{
  'communication': Icons.chat_bubble_outline,
  'conflit': Icons.warning_amber_rounded,
  'psychologie': Icons.psychology_outlined,
  'parentalite': Icons.child_care_outlined,
  'couple': Icons.favorite_outline,
  'amitie': Icons.people_outline,
  'travail': Icons.work_outline,
  'social': Icons.public,
  'sante': Icons.health_and_safety_outlined,
  'education': Icons.school_outlined,
  'loisirs': Icons.sports_esports_outlined,
  'category': Icons.category_outlined,
};

// Preset color options
const _colorOptions = <String>[
  '#1B3A5C',
  '#2E86AB',
  '#F4A139',
  '#43A047',
  '#E53935',
  '#8E24AA',
  '#F06292',
  '#00897B',
  '#FB8C00',
  '#607D8B',
];

class CategoriesManagementPage extends StatefulWidget {
  const CategoriesManagementPage({super.key});

  @override
  State<CategoriesManagementPage> createState() =>
      _CategoriesManagementPageState();
}

class _CategoriesManagementPageState extends State<CategoriesManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResourcesProvider>().loadAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Gestion du catalogue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
            onPressed: () =>
                context.read<ResourcesProvider>().loadAllCategories(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, null),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        tooltip: 'Nouvelle catégorie',
        child: const Icon(Icons.add),
      ),
      body: Consumer<ResourcesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingCategories) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.categoryError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
                  const SizedBox(height: 12),
                  Text(provider.categoryError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadAllCategories(),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          final categories =
              provider.allCategories.where((c) => c.estActive).toList();
          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.category_outlined,
                      size: 64, color: AppTheme.textSecondary),
                  const SizedBox(height: 16),
                  const Text('Aucune catégorie',
                      style: TextStyle(
                          fontSize: 16, color: AppTheme.textSecondary)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCategoryDialog(context, null),
                    icon: const Icon(Icons.add),
                    label: const Text('Créer la première catégorie'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) =>
                _CategoryCard(
                  category: categories[i],
                  onEdit: () => _showCategoryDialog(context, categories[i]),
                  onDelete: () => _confirmDelete(context, categories[i]),
                ),
          );
        },
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, Category? existing) {
    showDialog(
      context: context,
      builder: (_) => _CategoryFormDialog(
        existing: existing,
        onSave: (nom, desc, couleur, icone, ordre) async {
          final provider = context.read<ResourcesProvider>();
          try {
            if (existing == null) {
              await provider.createCategory(
                nom: nom,
                description: desc,
                couleur: couleur,
                icone: icone,
                ordre: ordre,
              );
            } else {
              await provider.updateCategory(
                id: existing.id,
                nom: nom,
                description: desc,
                couleur: couleur,
                icone: icone,
                ordre: ordre,
              );
            }
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(existing == null
                    ? 'Catégorie créée avec succès'
                    : 'Catégorie modifiée avec succès'),
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

  void _confirmDelete(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer la catégorie ?'),
        content: Text(
          'La catégorie « ${category.name} » sera désactivée.\n'
          'Les ressources associées ne seront pas supprimées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await context
                    .read<ResourcesProvider>()
                    .deleteCategory(category.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Catégorie supprimée'),
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
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
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
        border: category.estActive
            ? null
            : Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: category.estActive
                ? category.color.withOpacity(0.15)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            category.icon,
            color: category.estActive ? category.color : Colors.grey,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: category.estActive
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                ),
              ),
            ),
            if (!category.estActive)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Inactive',
                    style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w600)),
              ),
          ],
        ),
        subtitle: category.description.isNotEmpty
            ? Text(
                category.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.textSecondary),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color dot
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
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

class _CategoryFormDialog extends StatefulWidget {
  final Category? existing;
  final Future<void> Function(
      String nom, String desc, String couleur, String icone, int ordre) onSave;

  const _CategoryFormDialog({required this.existing, required this.onSave});

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _ordreCtrl;
  late String _selectedColor;
  late String _selectedIcon;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final ex = widget.existing;
    _nomCtrl = TextEditingController(text: ex?.name ?? '');
    _descCtrl = TextEditingController(text: ex?.description ?? '');
    _ordreCtrl =
        TextEditingController(text: (ex?.ordre ?? 0).toString());
    _selectedColor = ex?.colorHex ?? _colorOptions.first;
    _selectedIcon = ex?.iconName ?? _iconOptions.keys.first;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _descCtrl.dispose();
    _ordreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
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
              Text(
                isEdit ? 'Modifier la catégorie' : 'Nouvelle catégorie',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),

              // Nom
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  prefixIcon: Icon(Icons.label_outline),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Nom requis' : null,
              ),
              const SizedBox(height: 14),

              // Description
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 14),

              // Ordre
              TextFormField(
                controller: _ordreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ordre d\'affichage',
                  prefixIcon: Icon(Icons.sort),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Icon picker
              const Text('Icône',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _iconOptions.entries.map((e) {
                  final selected = _selectedIcon == e.key;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = e.key),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: selected
                            ? null
                            : Border.all(color: Colors.grey.shade300),
                      ),
                      child: Icon(e.value,
                          size: 22,
                          color:
                              selected ? Colors.white : AppTheme.textSecondary),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Color picker
              const Text('Couleur',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _colorOptions.map((hex) {
                  final color = Color(
                      int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
                  final selected = _selectedColor == hex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = hex),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(
                                color: AppTheme.primary, width: 3)
                            : null,
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                    color: color.withOpacity(0.5),
                                    blurRadius: 6)
                              ]
                            : null,
                      ),
                      child: selected
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
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
        _nomCtrl.text.trim(),
        _descCtrl.text.trim(),
        _selectedColor,
        _selectedIcon,
        int.tryParse(_ordreCtrl.text) ?? 0,
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
