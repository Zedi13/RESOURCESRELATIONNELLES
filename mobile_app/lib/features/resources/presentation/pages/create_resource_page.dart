import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/resource.dart';
import '../providers/resources_provider.dart';

class CreateResourcePage extends StatefulWidget {
  /// Si non null → mode édition. Si null → mode création.
  final Resource? existingResource;

  const CreateResourcePage({super.key, this.existingResource});

  @override
  State<CreateResourcePage> createState() => _CreateResourcePageState();
}

class _CreateResourcePageState extends State<CreateResourcePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _contentCtrl;

  late ResourceType _selectedType;
  late String? _selectedCategoryId;
  late Set<String> _selectedTypeIds; // IDs des types de relation sélectionnés
  late ResourceVisibility _selectedVisibility;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.existingResource != null;

  @override
  void initState() {
    super.initState();
    final r = widget.existingResource;
    _titleCtrl = TextEditingController(text: r?.title ?? '');
    _descCtrl = TextEditingController(text: r?.description ?? '');
    _contentCtrl = TextEditingController(text: r?.content ?? '');
    _selectedType = r?.type ?? ResourceType.article;
    _selectedCategoryId = r?.categoryId;
    // En édition, on pré-sélectionne les ids déjà associés
    _selectedTypeIds = Set.from(r?.allRelationTypeIds ?? []);
    _selectedVisibility = r?.visibility ?? ResourceVisibility.public_;
    // Charger les types de relation depuis l'API si pas encore fait
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ResourcesProvider>();
      if (provider.typeRelations.isEmpty) {
        provider.loadTypeRelationEntities();
      }
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une catégorie.'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }
    if (_selectedTypeIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner au moins un type de relation.'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final auth = context.read<AuthProvider>();
    final user = auth.currentUser!;
    final resourcesProvider = context.read<ResourcesProvider>();

    try {
      if (_isEditMode) {
        final updated = widget.existingResource!.copyWith(
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          content: _contentCtrl.text.trim(),
          type: _selectedType,
          categoryId: _selectedCategoryId,
          selectedTypeIds: _selectedTypeIds.toList(),
          visibility: _selectedVisibility,
        );
        await resourcesProvider.updateResource(updated);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ressource modifiée avec succès !'),
              backgroundColor: AppTheme.success,
            ),
          );
          context.pop();
        }
      } else {
        final newResource = Resource(
          id: '',
          title: _titleCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          content: _contentCtrl.text.trim(),
          type: _selectedType,
          categoryId: _selectedCategoryId!,
          relationTypes: const [],
          selectedTypeIds: _selectedTypeIds.toList(),
          visibility: _selectedVisibility,
          status: ResourceStatus.enAttente,
          authorId: user.id,
          authorName: user.name,
          createdAt: DateTime.now(),
          views: 0,
          shares: 0,
          estimatedDurationMin: 5,
        );
        await resourcesProvider.addResource(newResource);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ressource soumise pour validation !'),
              backgroundColor: AppTheme.success,
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = context.watch<ResourcesProvider>();
    final categories = resourcesProvider.getCategories();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Modifier la ressource' : 'Nouvelle ressource'),
        actions: [
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
            )
          else
            TextButton(
              onPressed: _submit,
              child: Text(
                _isEditMode ? 'Enregistrer' : 'Publier',
                style: const TextStyle(
                  color: AppTheme.secondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type selector
              const Text(
                'Type de ressource',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ResourceType.values.map((type) {
                  final selected = _selectedType == type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? AppTheme.primary
                              : Colors.grey.shade300,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        '${type.icon} ${type.label}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.normal,
                          color: selected
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Title
              TextFormField(
                controller: _titleCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Titre *',
                  hintText: 'Un titre clair et engageant',
                ),
                validator: (v) =>
                    (v == null || v.trim().length < 5)
                        ? 'Titre trop court (min. 5 caractères)'
                        : null,
              ),
              const SizedBox(height: 14),
              // Description
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description courte *',
                  hintText: 'Résumez le contenu en 2-3 phrases',
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().length < 10)
                        ? 'Description trop courte'
                        : null,
              ),
              const SizedBox(height: 14),
              // Content
              TextFormField(
                controller: _contentCtrl,
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Contenu *',
                  hintText: 'Rédigez votre ressource...',
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().length < 20)
                        ? 'Contenu trop court'
                        : null,
              ),
              const SizedBox(height: 20),
              // Category
              const Text(
                'Catégorie *',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final selected = _selectedCategoryId == cat.id;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategoryId = cat.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? cat.color.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? cat.color
                              : Colors.grey.shade300,
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(cat.icon,
                              size: 14,
                              color: selected
                                  ? cat.color
                                  : AppTheme.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            cat.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              color: selected
                                  ? cat.color
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Relation types (dynamiques depuis l'API)
              const Text(
                'Types de relations concernées *',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              if (resourcesProvider.isLoadingTypeRelations)
                const Center(child: CircularProgressIndicator())
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: resourcesProvider.typeRelations.map((tr) {
                    final selected = _selectedTypeIds.contains(tr.id);
                    return FilterChip(
                      label: Text(tr.libelle),
                      selected: selected,
                      onSelected: (v) => setState(() {
                        if (v) {
                          _selectedTypeIds.add(tr.id);
                        } else {
                          _selectedTypeIds.remove(tr.id);
                        }
                      }),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 20),
              // Visibility
              const Text(
                'Visibilité',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...ResourceVisibility.values.map((vis) {
                String label;
                String desc;
                IconData icon;
                switch (vis) {
                  case ResourceVisibility.prive:
                    label = 'Privée';
                    desc = 'Visible uniquement par vous';
                    icon = Icons.lock_outline;
                  case ResourceVisibility.partage:
                    label = 'Partagée';
                    desc = 'Accessible via un lien';
                    icon = Icons.link;
                  case ResourceVisibility.public_:
                    label = 'Publique';
                    desc = 'Visible par tous les citoyens';
                    icon = Icons.public;
                }
                return RadioListTile<ResourceVisibility>(
                  value: vis,
                  groupValue: _selectedVisibility,
                  onChanged: (v) =>
                      setState(() => _selectedVisibility = v!),
                  title: Row(
                    children: [
                      Icon(icon, size: 16, color: AppTheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    desc,
                    style: const TextStyle(fontSize: 12),
                  ),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: Icon(_isEditMode
                      ? Icons.save_outlined
                      : Icons.send_outlined),
                  label: Text(_isEditMode
                      ? 'Enregistrer les modifications'
                      : 'Soumettre la ressource'),
                ),
              ),
              if (!_isEditMode) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.warning.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppTheme.warning.withOpacity(0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: AppTheme.warning, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Les ressources publiques sont soumises à validation par un modérateur avant publication.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
