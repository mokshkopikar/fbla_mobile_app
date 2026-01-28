import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fbla_engagement/features/news_feed/data/datasources/news_local_data_source.dart';
import 'package:fbla_engagement/features/news_feed/data/models/news_model.dart';

void main() {
  late NewsLocalDataSourceImpl dataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    dataSource = NewsLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });

  const tNewsList = [
    NewsModel(
      id: 'n1',
      title: 'Test News 1',
      date: 'Jan 1, 2026',
      summary: 'Test summary 1',
      link: 'https://test.com/1',
      category: 'National Center News',
    ),
    NewsModel(
      id: 'n2',
      title: 'Test News 2',
      date: 'Jan 2, 2026',
      summary: 'Test summary 2',
      link: 'https://test.com/2',
      category: 'Chapter Spotlight',
    ),
  ];

  group('NewsLocalDataSource Caching Tests', () {
    test('should return empty list when cache is empty', () async {
      // Act
      final result = await dataSource.getCachedNews();

      // Assert
      expect(result, isEmpty);
    });

    test('should cache and retrieve news successfully', () async {
      // 1. Cache news
      await dataSource.cacheNews(tNewsList);

      // 2. Retrieve cached news
      final result = await dataSource.getCachedNews();

      // 3. Assert
      expect(result.length, equals(2));
      expect(result[0].id, equals('n1'));
      expect(result[0].title, equals('Test News 1'));
      expect(result[1].id, equals('n2'));
      expect(result[1].title, equals('Test News 2'));
      
      // Verify data is actually stored in SharedPreferences
      final cachedJson = sharedPreferences.getString('CACHED_NEWS');
      expect(cachedJson, isNotNull);
      final decoded = json.decode(cachedJson!);
      expect(decoded, isA<List>());
      expect((decoded as List).length, equals(2));
    });

    test('should update cache when new data is cached', () async {
      // 1. Cache initial news
      await dataSource.cacheNews([tNewsList[0]]);
      expect((await dataSource.getCachedNews()).length, equals(1));

      // 2. Cache new data (should overwrite)
      await dataSource.cacheNews(tNewsList);
      final result = await dataSource.getCachedNews();

      // 3. Assert - should have both items now
      expect(result.length, equals(2));
    });

    test('should clear cache successfully', () async {
      // 1. Cache news
      await dataSource.cacheNews(tNewsList);
      expect((await dataSource.getCachedNews()).length, equals(2));

      // 2. Clear cache
      await dataSource.clearCache();

      // 3. Assert - cache should be empty
      final result = await dataSource.getCachedNews();
      expect(result, isEmpty);
      
      // Verify SharedPreferences key is removed
      expect(sharedPreferences.getString('CACHED_NEWS'), isNull);
    });

    test('should persist cache across instances', () async {
      // 1. Cache news with first instance
      await dataSource.cacheNews(tNewsList);

      // 2. Create new instance with same SharedPreferences
      final newDataSource = NewsLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );

      // 3. Retrieve from new instance
      final result = await newDataSource.getCachedNews();

      // 4. Assert - should retrieve cached data
      expect(result.length, equals(2));
      expect(result[0].id, equals('n1'));
    });
  });
}
