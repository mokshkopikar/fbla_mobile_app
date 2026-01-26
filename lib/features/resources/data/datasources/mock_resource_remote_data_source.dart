import '../../domain/entities/resource_entity.dart';

abstract class ResourceRemoteDataSource {
  Future<List<ResourceEntity>> getResources();
}

class MockResourceRemoteDataSource implements ResourceRemoteDataSource {
  @override
  Future<List<ResourceEntity>> getResources() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      const ResourceEntity(
        id: '1',
        title: '2025-26 Competitive Events Guidelines',
        description: 'Comprehensive guide to all FBLA competitive events, including scoring rubrics.',
        category: 'Competitive Events',
        type: 'PDF',
        url: 'https://www.fbla.org/competitive-events/',
      ),
      const ResourceEntity(
        id: '2',
        title: 'Chapter Management Handbook',
        description: 'Everything you need to successfully run your local FBLA chapter.',
        category: 'Chapter Management',
        type: 'PDF',
        url: 'https://www.fbla.org/chapter-management/',
      ),
      const ResourceEntity(
        id: '3',
        title: 'National Leadership Conference Prep',
        description: 'Tips and tricks for making the most of your NLC experience.',
        category: 'Lead FBLA',
        type: 'Video',
        url: 'https://www.youtube.com/user/FBLAPBLActive',
      ),
      const ResourceEntity(
        id: '4',
        title: 'Dress Code Policy',
        description: 'Official FBLA-PBL professional attire guidelines for conferences.',
        category: 'Conference Info',
        type: 'Link',
        url: 'https://www.fbla.org/dress-code/',
      ),
      const ResourceEntity(
        id: '5',
        title: 'Business Achievement Awards (BAA)',
        description: 'Overview of the BAA program and how to earn your pins.',
        category: 'Awards',
        type: 'Link',
        url: 'https://www.fbla.org/baa/',
      ),
    ];
  }
}
