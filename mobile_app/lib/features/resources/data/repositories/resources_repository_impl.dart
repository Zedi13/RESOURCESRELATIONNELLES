import '../../domain/entities/resource.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/type_relation_entity.dart';
import '../../domain/repositories/resources_repository.dart';
import '../datasources/resources_remote_datasource.dart';

class ResourcesRepositoryImpl implements ResourcesRepository {
  final ResourcesRemoteDatasource _datasource;
  ResourcesRepositoryImpl(this._datasource);

  @override
  Future<List<Resource>> getPublicResources() =>
      _datasource.getPublicResources();

  @override
  Future<List<Resource>> getAllResources() => _datasource.getAllResources();

  @override
  Future<List<Resource>> getResourcesByAuthor(String authorId) =>
      _datasource.getResourcesByAuthor(authorId);

  @override
  Future<Resource?> getResourceById(String id) =>
      _datasource.getResourceById(id);

  @override
  Future<List<Category>> getCategories() => _datasource.getCategories();

  @override
  Future<List<Category>> getAllCategories() => _datasource.getAllCategories();

  @override
  Future<void> loadTypeRelations() => _datasource.loadTypeRelations();

  @override
  Future<Category> createCategory({
    required String nom,
    required String description,
    required String couleur,
    required String icone,
    required int ordre,
  }) =>
      _datasource.createCategory(
        nom: nom,
        description: description,
        couleur: couleur,
        icone: icone,
        ordre: ordre,
      );

  @override
  Future<Category> updateCategory({
    required String id,
    required String nom,
    required String description,
    required String couleur,
    required String icone,
    required int ordre,
  }) =>
      _datasource.updateCategory(
        id: id,
        nom: nom,
        description: description,
        couleur: couleur,
        icone: icone,
        ordre: ordre,
      );

  @override
  Future<void> deleteCategory(String id) => _datasource.deleteCategory(id);

  @override
  Future<List<TypeRelationEntity>> getTypeRelations() =>
      _datasource.getTypeRelations();

  @override
  Future<TypeRelationEntity> createTypeRelation({
    required String libelle,
    required String description,
    required int ordre,
  }) =>
      _datasource.createTypeRelation(
          libelle: libelle, description: description, ordre: ordre);

  @override
  Future<TypeRelationEntity> updateTypeRelation({
    required String id,
    required String libelle,
    required String description,
    required int ordre,
  }) =>
      _datasource.updateTypeRelation(
          id: id, libelle: libelle, description: description, ordre: ordre);

  @override
  Future<void> deleteTypeRelation(String id) =>
      _datasource.deleteTypeRelation(id);

  @override
  Future<void> addResource(Resource resource) =>
      _datasource.addResource(resource);

  @override
  Future<void> updateResource(Resource resource) =>
      _datasource.updateResource(resource);

  @override
  Future<void> deleteResource(String id) => _datasource.deleteResource(id);

  @override
  Future<void> shareResource(String id) => _datasource.shareResource(id);

  @override
  Future<List<Resource>> getAdminResources({String? statut}) =>
      _datasource.getAdminResources(statut: statut);

  @override
  Future<void> changeResourceStatus(String id, String statut) =>
      _datasource.changeResourceStatus(id, statut);
}
