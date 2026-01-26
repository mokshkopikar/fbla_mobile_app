import '../../domain/entities/social_post_entity.dart';
import '../../domain/repositories/social_repository.dart';
import '../datasources/mock_social_remote_data_source.dart';

class SocialRepositoryImpl implements SocialRepository {
  final SocialRemoteDataSource remoteDataSource;

  SocialRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SocialPostEntity>> getSocialFeed() async {
    return await remoteDataSource.getFeed();
  }
}
