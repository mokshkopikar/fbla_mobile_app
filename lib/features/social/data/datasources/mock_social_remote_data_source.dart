import '../../domain/entities/social_post_entity.dart';

abstract class SocialRemoteDataSource {
  Future<List<SocialPostEntity>> getFeed();
}

class MockSocialRemoteDataSource implements SocialRemoteDataSource {
  @override
  Future<List<SocialPostEntity>> getFeed() async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    return [
      SocialPostEntity(
        id: '1',
        authorName: 'FBLA National',
        authorHandle: '@FBLA_National',
        content: 'Registration for NLC 2025 in San Antonio is now OPEN! Who’s ready to Lead with Purpose? 🚀 #FBLANLC #LeadWithPurpose',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 124,
      ),
      SocialPostEntity(
        id: '2',
        authorName: 'FBLA Collegiate',
        authorHandle: '@FBLA_Collegiate',
        content: 'Shoutout to all the chapters who participated in the March of Dimes walk this weekend! Together we are making a difference. 💙',
        timestamp: DateTime.now().subtract(const Duration(hours: 18)),
        likes: 85,
      ),
      SocialPostEntity(
        id: '3',
        authorName: 'Future Business Leader',
        authorHandle: '@FBLA_Member',
        content: 'Just finished my first BAA level! So excited to keep learning and growing with FBLA. #FBLA #Success',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likes: 42,
      ),
    ];
  }
}
