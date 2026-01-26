import '../entities/social_post_entity.dart';

abstract class SocialRepository {
  Future<List<SocialPostEntity>> getSocialFeed();
}
