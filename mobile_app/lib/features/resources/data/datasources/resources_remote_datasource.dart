import 'package:flutter/material.dart';
import '../../domain/entities/resource.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/type_relation_entity.dart';
import '../../../../core/network/api_client.dart';

class ResourcesRemoteDatasource {
  final ApiClient _client;

  // libelle.toLowerCase() → typeRelation id
  Map<String, int> _typeRelationIds = {};

  ResourcesRemoteDatasource(this._client);

  Future<List<Resource>> getPublicResources() async {
    final data =
        await _client.get('/ressources?size=100') as Map<String, dynamic>;
    return (data['content'] as List).map(_toResource).toList();
  }

  Future<List<Resource>> getAllResources() async {
    final data =
        await _client.get('/ressources/admin?size=100') as Map<String, dynamic>;
    return (data['content'] as List).map(_toResource).toList();
  }

  Future<List<Resource>> getAdminResources({String? statut}) async {
    final query = statut != null
        ? '/ressources/admin?size=200&statut=$statut'
        : '/ressources/admin?size=200';
    final data = await _client.get(query) as Map<String, dynamic>;
    return (data['content'] as List).map(_toResource).toList();
  }

  Future<void> changeResourceStatus(String id, String statut) async {
    await _client.patch('/ressources/$id/statut', {'statut': statut});
  }

  Future<List<Resource>> getResourcesByAuthor(String authorId) async {
    final data = await _client.get('/ressources/mes-creations?size=100')
        as Map<String, dynamic>;
    return (data['content'] as List).map(_toResource).toList();
  }

  Future<Resource?> getResourceById(String id) async {
    try {
      final data =
          await _client.get('/ressources/$id') as Map<String, dynamic>;
      return _toResourceFull(data);
    } catch (_) {
      return null;
    }
  }

  Future<List<Category>> getCategories() async {
    final data = await _client.get('/categories') as List;
    return data.map(_toCategory).toList();
  }

  Future<List<Category>> getAllCategories() async {
    final data = await _client.get('/categories/toutes') as List;
    return data.map(_toCategory).toList();
  }

  Future<Category> createCategory({
    required String nom,
    required String description,
    required String couleur,
    required String icone,
    required int ordre,
  }) async {
    final data = await _client.post('/categories', {
      'nom': nom,
      'description': description,
      'couleur': couleur,
      'icone': icone,
      'ordre': ordre,
    }) as Map<String, dynamic>;
    return _toCategory(data);
  }

  Future<Category> updateCategory({
    required String id,
    required String nom,
    required String description,
    required String couleur,
    required String icone,
    required int ordre,
  }) async {
    final data = await _client.put('/categories/$id', {
      'nom': nom,
      'description': description,
      'couleur': couleur,
      'icone': icone,
      'ordre': ordre,
    }) as Map<String, dynamic>;
    return _toCategory(data);
  }

  Future<void> deleteCategory(String id) async {
    await _client.delete('/categories/$id');
  }

  // ── Types de relation CRUD ────────────────────────────────────────────────

  Future<List<TypeRelationEntity>> getTypeRelations() async {
    final data = await _client.get('/types-relation') as List;
    return data.map(_toTypeRelationEntity).toList();
  }

  Future<TypeRelationEntity> createTypeRelation({
    required String libelle,
    required String description,
    required int ordre,
  }) async {
    final data = await _client.post('/types-relation', {
      'libelle': libelle,
      'description': description,
      'ordre': ordre,
    }) as Map<String, dynamic>;
    return _toTypeRelationEntity(data);
  }

  Future<TypeRelationEntity> updateTypeRelation({
    required String id,
    required String libelle,
    required String description,
    required int ordre,
  }) async {
    final data = await _client.put('/types-relation/$id', {
      'libelle': libelle,
      'description': description,
      'ordre': ordre,
    }) as Map<String, dynamic>;
    return _toTypeRelationEntity(data);
  }

  Future<void> deleteTypeRelation(String id) async {
    await _client.delete('/types-relation/$id');
  }

  static TypeRelationEntity _toTypeRelationEntity(dynamic json) {
    final j = json as Map<String, dynamic>;
    return TypeRelationEntity(
      id: j['id'].toString(),
      libelle: j['libelle'] as String? ?? '',
      description: j['description'] as String? ?? '',
      ordre: (j['ordre'] as num?)?.toInt() ?? 0,
    );
  }

  Future<void> loadTypeRelations() async {
    try {
      final data = await _client.get('/types-relation') as List;
      _typeRelationIds = {
        for (final t in data)
          (t['libelle'] as String).toLowerCase(): t['id'] as int,
      };
    } catch (_) {
      _typeRelationIds = {
        'couple': 1,
        'famille': 2,
        'amis': 3,
        'professionnel': 4,
        'social': 5,
        'soi': 6,
      };
    }
  }

  Future<void> addResource(Resource resource) async {
    await _client.post('/ressources', {
      'titre': resource.title,
      'description': resource.description,
      'contenu': resource.content,
      'type': _fromType(resource.type),
      'visibilite': _fromVisibility(resource.visibility),
      'categorieId': int.tryParse(resource.categoryId) ?? 1,
      'typesRelationIds': _resolveTypeIds(resource),
      if (resource.externalUrl != null) 'urlExterne': resource.externalUrl,
      'dureeEstimeeMin': resource.estimatedDurationMin,
    });
  }

  Future<void> updateResource(Resource resource) async {
    await _client.put('/ressources/${resource.id}', {
      'titre': resource.title,
      'description': resource.description,
      'contenu': resource.content,
      'type': _fromType(resource.type),
      'visibilite': _fromVisibility(resource.visibility),
      'categorieId': int.tryParse(resource.categoryId) ?? 1,
      'typesRelationIds': _resolveTypeIds(resource),
      if (resource.externalUrl != null) 'urlExterne': resource.externalUrl,
      'dureeEstimeeMin': resource.estimatedDurationMin,
    });
  }

  /// Résout les IDs à envoyer à l'API :
  /// - Si selectedTypeIds est renseigné (création/édition dynamique), on les utilise
  /// - Sinon on fait la conversion depuis l'enum (rétro-compat)
  List<int> _resolveTypeIds(Resource resource) {
    if (resource.selectedTypeIds.isNotEmpty) {
      return resource.selectedTypeIds
          .map((id) => int.tryParse(id))
          .whereType<int>()
          .toList();
    }
    return _toRelationIds(resource.relationTypes);
  }

  Future<void> deleteResource(String id) async {
    await _client.delete('/ressources/$id');
  }

  Future<void> shareResource(String id) async {
    await _client.post('/ressources/$id/partager', {});
  }

  Future<List<Resource>> getPendingResources() async {
    final data = await _client.get('/ressources/admin?statut=en_attente&size=100')
        as Map<String, dynamic>;
    return (data['content'] as List).map(_toResource).toList();
  }

  List<int> _toRelationIds(List<RelationType> types) {
    return types
        .map((t) => _typeRelationIds[t.name.toLowerCase()])
        .whereType<int>()
        .toList();
  }

  // --- Parsers ---

  static Resource _toResource(dynamic json) {
    final j = json as Map<String, dynamic>;
    final rawTypes = j['typesRelation'] as List? ?? const [];
    return Resource(
      id: j['id'].toString(),
      title: j['titre'] as String? ?? '',
      description: j['description'] as String? ?? '',
      content: '',
      type: _toType(j['type'] as String? ?? ''),
      categoryId:
          (j['categorieId'] ?? (j['categorie'] as Map?)?['id'])?.toString() ??
              '',
      relationTypes: _toRelationTypes(rawTypes),
      allRelationTypeIds: _extractTypeIds(rawTypes),
      visibility: _toVisibility(j['visibilite'] as String? ?? ''),
      status: _toStatus(j['statut'] as String? ?? ''),
      authorId: (j['auteurId'] ?? '').toString(),
      authorName: j['auteurNom'] as String? ?? '',
      createdAt:
          DateTime.tryParse(j['dateCreation'] as String? ?? '') ?? DateTime.now(),
      views: j['vues'] as int? ?? 0,
      shares: j['partages'] as int? ?? 0,
      estimatedDurationMin: j['dureeEstimeeMin'] as int? ?? 0,
      externalUrl: j['urlExterne'] as String?,
    );
  }

  static Resource _toResourceFull(Map<String, dynamic> j) {
    final cat = j['categorie'] as Map<String, dynamic>?;
    final rawTypes = j['typesRelation'] as List? ?? const [];
    return Resource(
      id: j['id'].toString(),
      title: j['titre'] as String? ?? '',
      description: j['description'] as String? ?? '',
      content: j['contenu'] as String? ?? '',
      type: _toType(j['type'] as String? ?? ''),
      categoryId: cat?['id']?.toString() ?? '',
      relationTypes: _toRelationTypes(rawTypes),
      allRelationTypeIds: _extractTypeIds(rawTypes),
      visibility: _toVisibility(j['visibilite'] as String? ?? ''),
      status: _toStatus(j['statut'] as String? ?? ''),
      authorId: (j['auteurId'] ?? '').toString(),
      authorName: j['auteurNom'] as String? ?? '',
      createdAt:
          DateTime.tryParse(j['dateCreation'] as String? ?? '') ?? DateTime.now(),
      views: j['vues'] as int? ?? 0,
      shares: j['partages'] as int? ?? 0,
      estimatedDurationMin: j['dureeEstimeeMin'] as int? ?? 0,
      externalUrl: j['urlExterne'] as String?,
    );
  }

  static List<String> _extractTypeIds(List rawTypes) {
    return rawTypes
        .map((t) => (t as Map<String, dynamic>)['id']?.toString() ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
  }

  static Category _toCategory(dynamic json) {
    final j = json as Map<String, dynamic>;
    final couleur = j['couleur'] as String? ?? '#607D8B';
    final icone = j['icone'] as String? ?? 'category';
    return Category(
      id: j['id'].toString(),
      name: j['nom'] as String? ?? '',
      description: j['description'] as String? ?? '',
      color: _parseColor(couleur),
      icon: _parseIcon(icone),
      colorHex: couleur,
      iconName: icone,
      ordre: (j['ordre'] as num?)?.toInt() ?? 0,
      estActive: j['estActive'] as bool? ?? true,
    );
  }

  static Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF607D8B);
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return const Color(0xFF607D8B);
    }
  }

  static IconData _parseIcon(String? name) {
    const map = <String, IconData>{
      'communication': Icons.chat_bubble_outline,
      'conflit': Icons.warning_amber_rounded,
      'developpement': Icons.psychology_outlined,
      'psychologie': Icons.psychology_outlined,
      'parentalite': Icons.child_care_outlined,
      'couple': Icons.favorite_outline,
      'amitie': Icons.people_outline,
      'travail': Icons.work_outline,
      'professionnel': Icons.work_outline,
      'social': Icons.public,
      'sante': Icons.health_and_safety_outlined,
    };
    return map[name?.toLowerCase()] ?? Icons.category_outlined;
  }

  static ResourceType _toType(String s) {
    switch (s.toUpperCase()) {
      case 'VIDEO':
        return ResourceType.video;
      case 'AUDIO':
        return ResourceType.audio;
      case 'ACTIVITE':
        return ResourceType.activite;
      case 'JEU':
        return ResourceType.jeu;
      case 'PODCAST':
        return ResourceType.podcast;
      case 'DOCUMENT':
        return ResourceType.document;
      case 'LIEN':
        return ResourceType.lien;
      default:
        return ResourceType.article;
    }
  }

  static String _fromType(ResourceType t) {
    switch (t) {
      case ResourceType.article:
        return 'ARTICLE';
      case ResourceType.video:
        return 'VIDEO';
      case ResourceType.audio:
        return 'AUDIO';
      case ResourceType.activite:
        return 'ACTIVITE';
      case ResourceType.jeu:
        return 'JEU';
      case ResourceType.podcast:
        return 'PODCAST';
      case ResourceType.document:
        return 'DOCUMENT';
      case ResourceType.lien:
        return 'LIEN';
    }
  }

  static ResourceVisibility _toVisibility(String s) {
    switch (s.toUpperCase()) {
      case 'PARTAGEE':
      case 'PARTAGE':
        return ResourceVisibility.partage;
      case 'PUBLIQUE':
      case 'PUBLIC':
        return ResourceVisibility.public_;
      default:
        return ResourceVisibility.prive;
    }
  }

  static String _fromVisibility(ResourceVisibility v) {
    switch (v) {
      case ResourceVisibility.prive:
        return 'PRIVEE';
      case ResourceVisibility.partage:
        return 'PARTAGEE';
      case ResourceVisibility.public_:
        return 'PUBLIQUE';
    }
  }

  static ResourceStatus _toStatus(String s) {
    switch (s.toUpperCase()) {
      case 'EN_ATTENTE':
        return ResourceStatus.enAttente;
      case 'PUBLIE':
        return ResourceStatus.publie;
      case 'SUSPENDU':
        return ResourceStatus.suspendu;
      default:
        return ResourceStatus.brouillon;
    }
  }

  static List<RelationType> _toRelationTypes(List types) {
    return types
        .map((t) =>
            _toRelationType((t as Map<String, dynamic>)['libelle'] as String? ?? ''))
        .whereType<RelationType>()
        .toList();
  }

  static RelationType? _toRelationType(String libelle) {
    switch (libelle.toLowerCase()) {
      case 'couple':
        return RelationType.couple;
      case 'famille':
        return RelationType.famille;
      case 'amis':
        return RelationType.amis;
      case 'professionnel':
        return RelationType.professionnel;
      case 'social':
        return RelationType.social;
      case 'soi':
        return RelationType.soi;
      default:
        return null;
    }
  }
}
