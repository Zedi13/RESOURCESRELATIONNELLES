import 'package:flutter/material.dart';
import '../../domain/entities/resource.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/resources_repository.dart';

class ResourcesProvider extends ChangeNotifier {
  final ResourcesRepository _repository;

  ResourcesProvider(this._repository);

  String _searchQuery = '';
  String? _selectedCategoryId;
  ResourceType? _selectedType;
  RelationType? _selectedRelationType;

  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;
  ResourceType? get selectedType => _selectedType;
  RelationType? get selectedRelationType => _selectedRelationType;

  List<Category> getCategories() => _repository.getCategories();

  Category? getCategoryById(String id) => _repository.getCategoryById(id);

  List<Resource> getFilteredResources({bool includeAll = false}) {
    List<Resource> resources =
        includeAll ? _repository.getAllResources() : _repository.getPublicResources();

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

    if (_selectedRelationType != null) {
      resources = resources
          .where((r) => r.relationTypes.contains(_selectedRelationType))
          .toList();
    }

    return resources;
  }

  List<Resource> getResourcesByAuthor(String authorId) =>
      _repository.getResourcesByAuthor(authorId);

  Resource? getResourceById(String id) => _repository.getResourceById(id);

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

  void setRelationTypeFilter(RelationType? relationType) {
    _selectedRelationType = relationType;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryId = null;
    _selectedType = null;
    _selectedRelationType = null;
    notifyListeners();
  }

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _selectedCategoryId != null ||
      _selectedType != null ||
      _selectedRelationType != null;

  void addResource(Resource resource) {
    _repository.addResource(resource);
    notifyListeners();
  }

  void updateResource(Resource resource) {
    _repository.updateResource(resource);
    notifyListeners();
  }

  void deleteResource(String id) {
    _repository.deleteResource(id);
    notifyListeners();
  }

  void incrementViews(String id) {
    _repository.incrementViews(id);
    notifyListeners();
  }

  void incrementShares(String id) {
    _repository.incrementShares(id);
    notifyListeners();
  }
}
