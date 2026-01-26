import '../entities/resource_entity.dart';

abstract class ResourceRepository {
  Future<List<ResourceEntity>> getResources();
  Future<List<ResourceEntity>> searchResources(String query);
}
