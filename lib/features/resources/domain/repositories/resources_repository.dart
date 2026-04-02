import '../entities/resource.dart';
import '../entities/category.dart';

abstract class ResourcesRepository {
  List<Resource> getPublicResources();
  List<Resource> getAllResources();
  List<Resource> getResourcesByAuthor(String authorId);
  Resource? getResourceById(String id);
  List<Category> getCategories();
  Category? getCategoryById(String id);
  void addResource(Resource resource);
  void updateResource(Resource resource);
  void deleteResource(String id);
  void incrementViews(String id);
  void incrementShares(String id);
  List<Resource> searchResources(String query);
  List<Resource> filterResources({
    String? categoryId,
    ResourceType? type,
    RelationType? relationType,
    ResourceStatus? status,
  });
}
