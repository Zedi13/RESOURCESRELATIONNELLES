import 'package:flutter/material.dart';
import '../../domain/entities/resource.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/type_relation_entity.dart';
import '../../domain/repositories/resources_repository.dart';

class ResourcesProvider extends ChangeNotifier {
  final ResourcesRepository _repository;
  ResourcesProvider(this._repository);

  List<Resource> _resources = [];
  List<Resource> _myResources = [];
  List<Resource> _adminResources = [];
  List<Category> _categories = [];
  List<Category> _allCategories = [];
  Resource? _detailResource;
  List<TypeRelationEntity> _typeRelations = [];
  bool isLoading = false;
  bool isLoadingDetail = false;
  bool isLoadingCategories = false;
  bool isLoadingMyResources = false;
  bool isLoadingTypeRelations = false;
  bool isLoadingAdminResources = false;
  String? error;
  String? categoryError;
  String? typeRelationError;
  String? adminResourcesError;

  String _searchQuery = '';
  String? _selectedCategoryId;
  ResourceType? _selectedType;
  TypeRelationEntity? _selectedRelationTypeEntity;

  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  ResourceType? get selectedType => _selectedType;
  TypeRelationEntity? get selectedRelationTypeEntity => _selectedRelationTypeEntity;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _selectedCategoryId != null ||
      _selectedType != null ||
      _selectedRelationTypeEntity != null;

  // --- Async loading ---

  Future<void> loadResources({bool isAdmin = false}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final results = isAdmin
          ? await _repository.getAllResources()
          : await _repository.getPublicResources();
      _resources = results;
      if (_categories.isEmpty) {
        _categories = await _repository.getCategories();
      }
      if (_typeRelations.isEmpty) {
        _typeRelations = await _repository.getTypeRelations();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Resource> get myResources => _myResources;
  List<Resource> get adminResources => _adminResources;

  Future<void> loadAdminResources({String? statut}) async {
    isLoadingAdminResources = true;
    adminResourcesError = null;
    notifyListeners();
    try {
      _adminResources = await _repository.getAdminResources(statut: statut);
    } catch (e) {
      adminResourcesError = e.toString();
    } finally {
      isLoadingAdminResources = false;
      notifyListeners();
    }
  }

  Future<void> changeResourceStatus(String id, String statut) async {
    await _repository.changeResourceStatus(id, statut);

    final newStatus = _parseStatus(statut);

    // Mise à jour dans _adminResources
    final adminIdx = _adminResources.indexWhere((r) => r.id == id);
    if (adminIdx != -1) {
      _adminResources[adminIdx] =
          _adminResources[adminIdx].copyWith(status: newStatus);
    }

    // Synchronisation de la liste publique (_resources)
    final pubIdx = _resources.indexWhere((r) => r.id == id);
    if (newStatus == ResourceStatus.publie) {
      // La ressource doit apparaître dans la liste publique
      final updated = adminIdx != -1 ? _adminResources[adminIdx] : null;
      if (updated != null) {
        if (pubIdx != -1) {
          _resources[pubIdx] = updated;
        } else {
          _resources.insert(0, updated);
        }
      }
    } else {
      // La ressource ne doit plus figurer dans la liste publique
      if (pubIdx != -1) {
        _resources.removeAt(pubIdx);
      }
    }

    // Synchronisation de _myResources
    final myIdx = _myResources.indexWhere((r) => r.id == id);
    if (myIdx != -1) {
      _myResources[myIdx] = _myResources[myIdx].copyWith(status: newStatus);
    }

    notifyListeners();
  }

  static ResourceStatus _parseStatus(String statut) {
    switch (statut.toUpperCase()) {
      case 'PUBLIE':
        return ResourceStatus.publie;
      case 'SUSPENDU':
        return ResourceStatus.suspendu;
      case 'EN_ATTENTE':
        return ResourceStatus.enAttente;
      default:
        return ResourceStatus.brouillon;
    }
  }

  Future<void> loadMyResources(String authorId) async {
    isLoadingMyResources = true;
    notifyListeners();
    try {
      _myResources = await _repository.getResourcesByAuthor(authorId);
    } catch (_) {
      _myResources = [];
    } finally {
      isLoadingMyResources = false;
      notifyListeners();
    }
  }

  Future<void> loadResourceById(String id) async {
    isLoadingDetail = true;
    notifyListeners();
    try {
      _detailResource = await _repository.getResourceById(id);
    } catch (_) {
      _detailResource = null;
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  // --- Types de relation admin ---

  List<TypeRelationEntity> get typeRelations => _typeRelations;

  Future<void> loadTypeRelationEntities() async {
    isLoadingTypeRelations = true;
    typeRelationError = null;
    notifyListeners();
    try {
      _typeRelations = await _repository.getTypeRelations();
    } catch (e) {
      typeRelationError = e.toString();
    } finally {
      isLoadingTypeRelations = false;
      notifyListeners();
    }
  }

  Future<void> createTypeRelation({
    required String libelle,
    required String description,
    required int ordre,
  }) async {
    final created = await _repository.createTypeRelation(
        libelle: libelle, description: description, ordre: ordre);
    _typeRelations.add(created);
    notifyListeners();
  }

  Future<void> updateTypeRelation({
    required String id,
    required String libelle,
    required String description,
    required int ordre,
  }) async {
    final updated = await _repository.updateTypeRelation(
        id: id, libelle: libelle, description: description, ordre: ordre);
    final idx = _typeRelations.indexWhere((t) => t.id == id);
    if (idx != -1) _typeRelations[idx] = updated;
    notifyListeners();
  }

  Future<void> deleteTypeRelation(String id) async {
    await _repository.deleteTypeRelation(id);
    _typeRelations.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // --- Async category admin ---

  List<Category> get allCategories => _allCategories;

  Future<void> loadAllCategories() async {
    isLoadingCategories = true;
    categoryError = null;
    notifyListeners();
    try {
      _allCategories = await _repository.getAllCategories();
    } catch (e) {
      categoryError = e.toString();
    } finally {
      isLoadingCategories = false;
      notifyListeners();
    }
  }

  Future<void> createCategory({
    required String nom,
    required String description,
    required String couleur,
    required String icone,
    required int ordre,
  }) async {
    final created = await _repository.createCategory(
      nom: nom,
      description: description,
      couleur: couleur,
      icone: icone,
      ordre: ordre,
    );
    _allCategories.add(created);
    _categories = _allCategories.where((c) => c.estActive).toList();
    notifyListeners();
  }

  Future<void> updateCategory({
    required String id,
    required String nom,
    required String description,
    required String couleur,
    required String icone,
    required int ordre,
  }) async {
    final updated = await _repository.updateCategory(
      id: id,
      nom: nom,
      description: description,
      couleur: couleur,
      icone: icone,
      ordre: ordre,
    );
    final idx = _allCategories.indexWhere((c) => c.id == id);
    if (idx != -1) _allCategories[idx] = updated;
    _categories = _allCategories.where((c) => c.estActive).toList();
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.deleteCategory(id);
    _allCategories.removeWhere((c) => c.id == id);
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // --- Synchronous getters on cache ---

  List<Category> getCategories() => _categories;

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Resource? get detailResource => _detailResource;

  List<Resource> getFilteredResources({bool includeAll = false}) {
    List<Resource> resources = _resources;

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      resources = resources
          .where((r) =>
              r.title.toLowerCase().contains(q) ||
              r.description.toLowerCase().contains(q))
          .toList();
    }
    if (_selectedCategoryId != null) {
      resources =
          resources.where((r) => r.categoryId == _selectedCategoryId).toList();
    }
    if (_selectedType != null) {
      resources = resources.where((r) => r.type == _selectedType).toList();
    }
    if (_selectedRelationTypeEntity != null) {
      final id = _selectedRelationTypeEntity!.id;
      resources = resources
          .where((r) => r.allRelationTypeIds.contains(id))
          .toList();
    }
    return resources;
  }

  List<Resource> getResourcesByAuthor(String authorId) =>
      _resources.where((r) => r.authorId == authorId).toList();

  Resource? getResourceById(String id) {
    try {
      return _resources.firstWhere((r) => r.id == id);
    } catch (_) {
      return _detailResource?.id == id ? _detailResource : null;
    }
  }

  // --- Filter setters ---

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategoryFilter(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setTypeFilter(ResourceType? type) {
    _selectedType = type;
    notifyListeners();
  }

  void setRelationTypeFilter(TypeRelationEntity? relationType) {
    _selectedRelationTypeEntity = relationType;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    _selectedType = null;
    _selectedRelationTypeEntity = null;
    notifyListeners();
  }

  // --- Mutations (fire-and-forget with optimistic UI) ---

  Future<void> addResource(Resource resource) async {
    await _repository.addResource(resource);
    await loadResources();
  }

  Future<void> updateResource(Resource resource) async {
    await _repository.updateResource(resource);
    await loadResources();
    // Mise à jour optimiste dans myResources
    final idx = _myResources.indexWhere((r) => r.id == resource.id);
    if (idx != -1) {
      _myResources[idx] = resource.copyWith(status: ResourceStatus.enAttente);
      notifyListeners();
    }
  }

  Future<void> deleteResource(String id) async {
    _resources.removeWhere((r) => r.id == id);
    _adminResources.removeWhere((r) => r.id == id);
    _myResources.removeWhere((r) => r.id == id);
    notifyListeners();
    await _repository.deleteResource(id);
  }

  void incrementViews(String id) {
    // Views are incremented server-side when fetching the resource detail
  }

  void incrementShares(String id) {
    _repository.shareResource(id);
    final idx = _resources.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final r = _resources[idx];
      _resources[idx] = r.copyWith(shares: r.shares + 1);
      notifyListeners();
    }
  }
}
