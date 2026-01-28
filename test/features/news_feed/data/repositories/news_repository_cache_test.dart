import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fbla_engagement/features/news_feed/data/repositories/news_repository_impl.dart';
import 'package:fbla_engagement/features/news_feed/data/datasources/news_remote_data_source.dart';
import 'package:fbla_engagement/features/news_feed/data/datasources/news_local_data_source.dart';
import 'package:fbla_engagement/features/news_feed/data/models/news_model.dart';
import 'package:fbla_engagement/injection_container.dart' as di;
import 'package:get_it/get_it.dart';

void main() {
  late NewsRepositoryImpl repository;
  late MockNewsRemoteDataSource remoteDataSource;
  late NewsLocalDataSourceImpl localDataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    localDataSource = NewsLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    remoteDataSource = MockNewsRemoteDataSource();
    repository = NewsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  tearDown(() async {
    await localDataSource.clearCache();
  });

  group('NewsRepository Cache-First Strategy Tests', () {
    test('should return cached news when cache exists', () async {
      // Arrange: Pre-populate cache
      const cachedNews = [
        NewsModel(
          id: 'cached-1',
          title: 'Cached News',
          date: 'Jan 1, 2026',
          summary: 'This is cached',
          link: 'https://test.com',
          category: 'National Center News',
        ),
      ];
      await localDataSource.cacheNews(cachedNews);

      // Act: Fetch news (should return from cache)
      final result = await repository.getLatestNews();

      // Assert: Should return cached data
      expect(result.length, equals(1));
      expect(result[0].id, equals('cached-1'));
      expect(result[0].title, equals('Cached News'));
    });

    test('should fetch from remote and cache when cache is empty', () async {
      // Arrange: Ensure cache is empty
      await localDataSource.clearCache();

      // Act: Fetch news (should fetch from remote and cache)
      final result = await repository.getLatestNews();

      // Assert: Should return remote data
      expect(result.length, greaterThan(0));
      expect(result[0].title, contains('FBLA'));

      // Verify data was cached
      final cached = await localDataSource.getCachedNews();
      expect(cached.length, equals(result.length));
      expect(cached[0].id, equals(result[0].id));
    });

    test('should update cache in background when cache exists', () async {
      // Arrange: Pre-populate cache with old data
      const oldNews = [
        NewsModel(
          id: 'old-1',
          title: 'Old News',
          date: 'Jan 1, 2026',
          summary: 'Old summary',
          link: 'https://test.com',
          category: 'National Center News',
        ),
      ];
      await localDataSource.cacheNews(oldNews);

      // Act: Fetch news (should return cached immediately, update in background)
      final result = await repository.getLatestNews();

      // Assert: Should return cached data immediately
      expect(result.length, equals(1));
      expect(result[0].id, equals('old-1'));

      // Wait a bit for background update to complete
      await Future.delayed(const Duration(milliseconds: 1000));

      // Verify cache was updated in background
      final updatedCache = await localDataSource.getCachedNews();
      expect(updatedCache.length, greaterThan(1)); // Should have fresh data
    });

    test('should search cached news when cache exists', () async {
      // Arrange: Pre-populate cache
      const cachedNews = [
        NewsModel(
          id: 'n1',
          title: 'Leadership Conference',
          date: 'Jan 1, 2026',
          summary: 'Test summary',
          link: 'https://test.com',
          category: 'National Center News',
        ),
        NewsModel(
          id: 'n2',
          title: 'Chapter Awards',
          date: 'Jan 2, 2026',
          summary: 'Awards summary',
          link: 'https://test.com',
          category: 'Chapter Spotlight',
        ),
      ];
      await localDataSource.cacheNews(cachedNews);

      // Act: Search news
      final result = await repository.searchNews('Leadership');

      // Assert: Should return cached search results
      expect(result.length, equals(1));
      expect(result[0].title, contains('Leadership'));
    });

    test('should handle remote fetch failure gracefully when cache exists', () async {
      // Arrange: Pre-populate cache
      const cachedNews = [
        NewsModel(
          id: 'cached-1',
          title: 'Cached News',
          date: 'Jan 1, 2026',
          summary: 'This is cached',
          link: 'https://test.com',
          category: 'National Center News',
        ),
      ];
      await localDataSource.cacheNews(cachedNews);

      // Create repository with failing remote data source
      final failingRemote = FailingNewsRemoteDataSource();
      final repoWithFailingRemote = NewsRepositoryImpl(
        remoteDataSource: failingRemote,
        localDataSource: localDataSource,
      );

      // Act: Fetch news (should return cached data even if remote fails)
      final result = await repoWithFailingRemote.getLatestNews();

      // Assert: Should return cached data despite remote failure
      expect(result.length, equals(1));
      expect(result[0].id, equals('cached-1'));
    });
  });
}

/// Mock remote data source that always fails (for testing error handling)
class FailingNewsRemoteDataSource implements NewsRemoteDataSource {
  @override
  Future<List<NewsModel>> getLatestNews() async {
    throw Exception('Network error');
  }

  @override
  Future<List<NewsModel>> searchNews(String query) async {
    throw Exception('Network error');
  }
}
