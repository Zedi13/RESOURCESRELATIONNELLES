import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/resource.dart';
import '../providers/resources_provider.dart';

class CreateResourcePage extends StatefulWidget {
  const CreateResourcePage({super.key});

  @override
  State<CreateResourcePage> createState() => _CreateResourcePageState();
}

class _CreateResourcePageState extends State<CreateResourcePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  ResourceType _selectedType = ResourceType.article;
  String? _selectedCategoryId;
  final Set<RelationType> _selectedRelationTypes = {};
  ResourceVisibility _selectedVisibility = ResourceVisibility.public_;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
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
    if (_selectedRelationTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner au moins un type de relation.'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final user = auth.currentUser!;
    final resourcesProvider = context.read<ResourcesProvider>();

    final newResource = Resource(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      type: _selectedType,
      categoryId: _selectedCategoryId!,
      relationTypes: _selectedRelationTypes.toList(),
      visibility: _selectedVisibility,
      status: ResourceStatus.enAttente,
      authorId: user.id,
      authorName: user.name,
      createdAt: DateTime.now(),
      views: 0,
      shares: 0,
      estimatedDurationMin: 5,
    );

    resourcesProvider.addResource(newResource);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ressource soumise pour validation !'),
        backgroundColor: AppTheme.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final resourcesProvider = context.watch<ResourcesProvider>();
    final categories = resourcesProvider.getCategories();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Nouvelle ressource'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              'Publier',
              style: TextStyle(
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
              // Relation types
              const Text(
                'Types de relations concernées *',
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
                children: RelationType.values.map((rt) {
                  final selected = _selectedRelationTypes.contains(rt);
                  return FilterChip(
                    label: Text(rt.label),
                    selected: selected,
                    onSelected: (v) => setState(() {
                      if (v) {
                        _selectedRelationTypes.add(rt);
                      } else {
                        _selectedRelationTypes.remove(rt);
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
                  onPressed: _submit,
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Soumettre la ressource'),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppTheme.warning.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppTheme.warning, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Les ressources publiques sont soumises à validation par un modérateur avant publication.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
