import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fbla_engagement/features/event_calendar/data/datasources/event_local_data_source.dart';
import 'package:fbla_engagement/features/event_calendar/data/models/event_model.dart';

void main() {
  late EventLocalDataSourceImpl dataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    dataSource = EventLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });

  final tEventList = [
    EventModel(
      id: 'ev-1',
      title: 'Test Event 1',
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 1, 2),
      location: 'Test Location 1',
      category: 'National',
      notes: 'Test notes 1',
    ),
    EventModel(
      id: 'ev-2',
      title: 'Test Event 2',
      startDate: DateTime(2026, 2, 1),
      location: 'Test Location 2',
      category: 'Chapter Meeting',
    ),
  ];

  group('EventLocalDataSource Caching Tests', () {
    test('should return empty list when cache is empty', () async {
      // Act
      final result = await dataSource.getCachedEvents();

      // Assert
      expect(result, isEmpty);
    });

    test('should cache and retrieve events successfully', () async {
      // 1. Cache events
      await dataSource.cacheEvents(tEventList);

      // 2. Retrieve cached events
      final result = await dataSource.getCachedEvents();

      // 3. Assert
      expect(result.length, equals(2));
      expect(result[0].id, equals('ev-1'));
      expect(result[0].title, equals('Test Event 1'));
      expect(result[0].startDate, equals(DateTime(2026, 1, 1)));
      expect(result[0].endDate, equals(DateTime(2026, 1, 2)));
      expect(result[1].id, equals('ev-2'));
      expect(result[1].title, equals('Test Event 2'));
      
      // Verify data is actually stored in SharedPreferences
      final cachedJson = sharedPreferences.getString('CACHED_EVENTS');
      expect(cachedJson, isNotNull);
      final decoded = json.decode(cachedJson!);
      expect(decoded, isA<List>());
      expect((decoded as List).length, equals(2));
    });

    test('should update cache when new data is cached', () async {
      // 1. Cache initial events
      await dataSource.cacheEvents([tEventList[0]]);
      expect((await dataSource.getCachedEvents()).length, equals(1));

      // 2. Cache new data (should overwrite)
      await dataSource.cacheEvents(tEventList);
      final result = await dataSource.getCachedEvents();

      // 3. Assert - should have both items now
      expect(result.length, equals(2));
    });

    test('should clear cache successfully', () async {
      // 1. Cache events
      await dataSource.cacheEvents(tEventList);
      expect((await dataSource.getCachedEvents()).length, equals(2));

      // 2. Clear cache
      await dataSource.clearCache();

      // 3. Assert - cache should be empty
      final result = await dataSource.getCachedEvents();
      expect(result, isEmpty);
      
      // Verify SharedPreferences key is removed
      expect(sharedPreferences.getString('CACHED_EVENTS'), isNull);
    });

    test('should persist cache across instances', () async {
      // 1. Cache events with first instance
      await dataSource.cacheEvents(tEventList);

      // 2. Create new instance with same SharedPreferences
      final newDataSource = EventLocalDataSourceImpl(
        sharedPreferences: sharedPreferences,
      );

      // 3. Retrieve from new instance
      final result = await newDataSource.getCachedEvents();

      // 4. Assert - should retrieve cached data
      expect(result.length, equals(2));
      expect(result[0].id, equals('ev-1'));
    });
  });
}
