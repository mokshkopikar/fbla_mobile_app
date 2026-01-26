import '../../domain/entities/resource_entity.dart';
import '../../domain/repositories/resource_repository.dart';
import '../datasources/mock_resource_remote_data_source.dart';

class ResourceRepositoryImpl implements ResourceRepository {
  final ResourceRemoteDataSource remoteDataSource;

  ResourceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ResourceEntity>> getResources() async {
    return await remoteDataSource.getResources();
  }

  @override
  Future<List<ResourceEntity>> searchResources(String query) async {
    final all = await remoteDataSource.getResources();
    if (query.isEmpty) return all;
    
    return all.where((res) => 
      res.title.toLowerCase().contains(query.toLowerCase()) || 
      res.description.toLowerCase().contains(query.toLowerCase()) ||
      res.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
