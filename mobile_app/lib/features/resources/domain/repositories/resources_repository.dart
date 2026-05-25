import '../entities/resource.dart';
import '../entities/category.dart';
import '../entities/type_relation_entity.dart';

abstract class ResourcesRepository {
  Future<List<Resource>> getPublicResources();
  Future<List<Resource>> getAllResources();
  Future<List<Resource>> getResourcesByAuthor(String authorId);
  Future<Resource?> getResourceById(String id);
  Future<List<Category>> getCategories();
  Future<List<Category>> getAllCategories();
  Future<void> loadTypeRelations();
  Future<void> addResource(Resource resource);
  Future<void> updateResource(Resource resource);
  Future<void> deleteResource(String id);
  Future<void> shareResource(String id);
  Future<Category> createCategory({
    required String nom,
    required String description,
    required String couleur,
    required String icone,
    required int ordre,
  });
  Future<Category> updateCategory({
    required String id,
    required String nom,
    required String description,
    required String couleur,
    required String icone,
    required int ordre,
  });
  Future<void> deleteCategory(String id);
  Future<List<TypeRelationEntity>> getTypeRelations();
  Future<TypeRelationEntity> createTypeRelation({
    required String libelle,
    required String description,
    required int ordre,
  });
  Future<TypeRelationEntity> updateTypeRelation({
    required String id,
    required String libelle,
    required String description,
    required int ordre,
  });
  Future<void> deleteTypeRelation(String id);
  Future<List<Resource>> getAdminResources({String? statut});
  Future<void> changeResourceStatus(String id, String statut);
}
