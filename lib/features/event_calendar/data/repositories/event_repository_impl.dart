import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_data_source.dart';
import '../datasources/event_local_data_source.dart';

/// Implementation of [EventRepository] interface.
/// 
/// This class is part of the Data layer in Clean Architecture and serves as
/// the bridge between the Domain layer (business logic) and Data layer
/// (data sources).
/// 
/// **Caching Strategy**: Cache-First Approach
/// - Checks local cache first for fast, offline access
/// - Falls back to remote data source if cache is empty
/// - Updates cache with fresh data from remote
/// - Ensures users can access events even with poor internet connectivity
class EventRepositoryImpl implements EventRepository {
  /// The remote data source for fetching events.
  /// 
  /// Currently uses a mock implementation for standalone demo purposes.
  /// In production, this would be a real API data source.
  final EventDataSource remoteDataSource;
  
  /// The local data source for caching event data.
  /// 
  /// Used to store and retrieve cached events for offline access.
  final EventLocalDataSource localDataSource;

  /// Creates a new [EventRepositoryImpl] instance.
  /// 
  /// [remoteDataSource] - The data source to fetch events from (required).
  ///                     Dependency is injected for testability.
  /// [localDataSource] - The data source for local caching (required).
  ///                    Dependency is injected for testability.
  EventRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Fetches events using cache-first strategy.
  /// 
  /// **Cache-First Strategy**:
  /// 1. Check local cache first for fast, offline access
  /// 2. If cache exists: Return cached data immediately (for offline/poor connectivity)
  /// 3. Fetch from remote data source in parallel to update cache
  /// 4. If cache is empty: Fetch from remote and cache the results
  /// 
  /// **Benefits**:
  /// - Fast response time when cache is available
  /// - Works offline with cached data
  /// - Automatically updates cache with fresh data when online
  /// - Graceful degradation when network is unavailable
  /// 
  /// Returns a [Future] that completes with a list of [EventEntity] domain
  /// entities representing the events.
  /// 
  /// Throws exceptions if both cache and remote operations fail.
  @override
  Future<List<EventEntity>> getEvents() async {
    // Step 1: Check local cache first
    final cachedEvents = await localDataSource.getCachedEvents();
    
    // Step 2: If cache exists, return it immediately (for fast, offline access)
    // Also fetch from remote in the background to update cache (fire and forget)
    if (cachedEvents.isNotEmpty) {
      // Return cached data immediately for fast response
      // Update cache in background (don't await - fire and forget)
      remoteDataSource.getEvents().then((freshEvents) {
        // Update cache with fresh data (non-blocking)
        localDataSource.cacheEvents(freshEvents).catchError((_) {
          // Silently handle cache update errors - cached data is still available
        });
      }).catchError((_) {
        // Silently handle remote fetch errors - cached data is still available
      });
      
      return cachedEvents;
    }
    
    // Step 3: Cache is empty - fetch from remote and cache the results
    try {
      final remoteEvents = await remoteDataSource.getEvents();
      
      // Cache the fetched data for future offline access
      await localDataSource.cacheEvents(remoteEvents);
      
      return remoteEvents;
    } catch (e) {
      // If remote fetch fails and cache is empty, rethrow the error
      // In production, you might want to return empty list or handle gracefully
      rethrow;
    }
  }

  @override
  Future<void> setReminder(String eventId, DateTime reminderTime) async {
    // [Syntactical and Semantic Validation]: 
    // This logic ensures the reminder is valid before "saving".
    if (reminderTime.isBefore(DateTime.now())) {
      throw Exception('Cannot set a reminder in the past.');
    }
    
    // Logic to register a local notification or schedule a job would go here.
    return;
  }
}
