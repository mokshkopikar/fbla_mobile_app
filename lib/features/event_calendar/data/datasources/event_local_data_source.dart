import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';

/// Abstract interface for local event data source operations.
/// 
/// This interface defines the contract for caching event data locally
/// for offline access. Implementations use local storage (SharedPreferences,
/// SQLite, etc.) to persist events.
/// 
/// **Architecture**: Part of the Data layer in Clean Architecture.
/// This abstraction allows for:
/// - Easy testing with mock implementations
/// - Switching between different local storage mechanisms
/// - Offline support with cached data
abstract class EventLocalDataSource {
  /// Retrieves cached events from local storage.
  /// 
  /// Returns a [Future] that completes with a list of [EventModel] objects
  /// if cached data exists, or an empty list if no cache is available.
  Future<List<EventModel>> getCachedEvents();
  
  /// Caches events to local storage.
  /// 
  /// [events] - The list of events to cache.
  /// 
  /// Returns a [Future] that completes when the data has been cached.
  Future<void> cacheEvents(List<EventModel> events);
  
  /// Clears the cached event data.
  /// 
  /// Returns a [Future] that completes when the cache has been cleared.
  Future<void> clearCache();
}

/// Implementation of [EventLocalDataSource] using [SharedPreferences].
/// 
/// **Purpose**: This implementation provides local caching for events,
/// allowing the app to work offline by serving cached data when network
/// connectivity is poor or unavailable.
/// 
/// **Storage Mechanism**: Uses [SharedPreferences], which:
/// - Stores data in the device's app sandbox (secure)
/// - Persists data between app restarts
/// - Provides key-value storage (we store JSON string)
/// - Is platform-agnostic (works on iOS, Android, Web)
/// 
/// **Data Format**: Event data is stored as a JSON array string for flexibility.
/// This allows easy serialization/deserialization of [EventModel] lists.
/// 
/// **Cache Strategy**: 
/// - Cache is updated whenever fresh data is fetched from remote
/// - Cache is served when network is unavailable or slow
/// - Cache persists until explicitly cleared or overwritten
class EventLocalDataSourceImpl implements EventLocalDataSource {
  /// The SharedPreferences instance for storing/retrieving data.
  /// 
  /// Injected via constructor for testability (can inject mock SharedPreferences).
  final SharedPreferences sharedPreferences;
  
  /// The key used to store cached event data in SharedPreferences.
  static const String _cacheKey = 'CACHED_EVENTS';
  
  /// Creates a new [EventLocalDataSourceImpl] instance.
  /// 
  /// [sharedPreferences] - The SharedPreferences instance to use for storage (required).
  ///                      Dependency is injected for testability.
  EventLocalDataSourceImpl({required this.sharedPreferences});
  
  /// Retrieves cached events from local storage.
  /// 
  /// **Implementation**:
  /// 1. Attempts to read cached event data from SharedPreferences
  /// 2. If data exists: Deserializes JSON array string to list of [EventModel]
  /// 3. If no data exists: Returns empty list
  /// 
  /// Returns a [Future] that completes with a list of [EventModel] objects
  /// representing the cached events, or an empty list if no cache exists.
  /// 
  /// **Error Handling**: If JSON deserialization fails, this will throw
  /// a [FormatException]. In production, you might want to catch this and
  /// return an empty list or log the error.
  @override
  Future<List<EventModel>> getCachedEvents() async {
    // Attempt to read cached events from SharedPreferences
    final jsonString = sharedPreferences.getString(_cacheKey);
    
    if (jsonString != null && jsonString.isNotEmpty) {
      // Cached data exists - deserialize JSON array to list of EventModel
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => EventModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      // No cached data found - return empty list
      return [];
    }
  }
  
  /// Caches events to local storage.
  /// 
  /// **Implementation**:
  /// 1. Serializes list of [EventModel] to JSON array string
  /// 2. Stores JSON string in SharedPreferences using the cache key
  /// 3. Data persists between app sessions
  /// 
  /// **Storage Format**: Data is stored as a JSON array string, which:
  /// - Is human-readable (for debugging)
  /// - Allows easy serialization/deserialization
  /// - Can be easily migrated if data structure changes
  /// 
  /// [events] - The list of [EventModel] objects containing the events to cache.
  /// 
  /// Returns a [Future] that completes when the data has been successfully
  /// cached to SharedPreferences.
  /// 
  /// **Error Handling**: If JSON serialization fails, this will throw
  /// an exception. In production, you might want to validate the models
  /// before caching.
  @override
  Future<void> cacheEvents(List<EventModel> events) async {
    // Serialize list of EventModel to JSON array string
    // This converts the models to a format suitable for storage
    final jsonList = events.map((e) => e.toJson()).toList();
    final jsonString = json.encode(jsonList);
    
    // Save JSON string to SharedPreferences
    // This persists the data to device storage, making it available after app restarts
    await sharedPreferences.setString(_cacheKey, jsonString);
  }
  
  /// Clears the cached event data.
  /// 
  /// **Implementation**:
  /// - Removes the cache key from SharedPreferences
  /// - Next call to [getCachedEvents] will return empty list
  /// 
  /// Returns a [Future] that completes when the cache has been cleared.
  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cacheKey);
  }
}
