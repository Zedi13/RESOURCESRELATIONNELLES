import '../../domain/entities/resource.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/resources_repository.dart';
import '../datasources/resources_local_datasource.dart';

class ResourcesRepositoryImpl implements ResourcesRepository {
  final ResourcesLocalDatasource _datasource;

  ResourcesRepositoryImpl(this._datasource);

  @override
  List<Resource> getPublicResources() => _datasource.getPublicResources();

  @override
  List<Resource> getAllResources() => _datasource.getAllResources();

  @override
  List<Resource> getResourcesByAuthor(String authorId) =>
      _datasource.getResourcesByAuthor(authorId);

  @override
  Resource? getResourceById(String id) => _datasource.getResourceById(id);

  @override
  List<Category> getCategories() => _datasource.getCategories();

  @override
  Category? getCategoryById(String id) => _datasource.getCategoryById(id);

  @override
  void addResource(Resource resource) => _datasource.addResource(resource);

  @override
  void updateResource(Resource resource) => _datasource.updateResource(resource);

  @override
  void deleteResource(String id) => _datasource.deleteResource(id);

  @override
  void incrementViews(String id) => _datasource.incrementViews(id);

  @override
  void incrementShares(String id) => _datasource.incrementShares(id);

  @override
  List<Resource> searchResources(String query) =>
      _datasource.searchResources(query);

  @override
  List<Resource> filterResources({
    String? categoryId,
    ResourceType? type,
    RelationType? relationType,
    ResourceStatus? status,
  }) =>
      _datasource.filterResources(
        categoryId: categoryId,
        type: type,
        relationType: relationType,
        status: status,
      );
}
