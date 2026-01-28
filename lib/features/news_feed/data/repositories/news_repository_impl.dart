import '../../domain/entities/news_entry.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';
import '../datasources/news_local_data_source.dart';

/// Implementation of [NewsRepository] interface.
/// 
/// This class is part of the Data layer in Clean Architecture and serves as
/// the bridge between the Domain layer (business logic) and Data layer
/// (data sources).
/// 
/// **Responsibilities**:
/// - Implements the repository interface defined in the Domain layer
/// - Coordinates data retrieval from data sources
/// - Converts data models to domain entities (if needed)
/// - Handles data source errors and converts them to domain exceptions
/// 
/// **Architecture Pattern**: Repository Pattern
/// - Domain layer defines the interface (contract)
/// - Data layer provides the implementation
/// - This separation allows swapping data sources without changing business logic
/// 
/// **Caching Strategy**: Cache-First Approach
/// - Checks local cache first for fast, offline access
/// - Falls back to remote data source if cache is empty
/// - Updates cache with fresh data from remote
/// - Ensures users can access news even with poor internet connectivity
class NewsRepositoryImpl implements NewsRepository {
  /// The remote data source for fetching news data.
  /// 
  /// Currently uses a mock implementation for standalone demo purposes.
  /// In production, this would be a real API data source.
  final NewsRemoteDataSource remoteDataSource;
  
  /// The local data source for caching news data.
  /// 
  /// Used to store and retrieve cached news articles for offline access.
  final NewsLocalDataSource localDataSource;

  /// Creates a new [NewsRepositoryImpl] instance.
  /// 
  /// [remoteDataSource] - The data source to fetch news from (required).
  ///                     Dependency is injected for testability.
  /// [localDataSource] - The data source for local caching (required).
  ///                    Dependency is injected for testability.
  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  /// Fetches the latest news articles using cache-first strategy.
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
  /// Returns a [Future] that completes with a list of [NewsEntry] domain
  /// entities representing the latest news articles.
  /// 
  /// Throws exceptions if both cache and remote operations fail. In a production
  /// app, these would be caught and converted to domain-specific exceptions.
  @override
  Future<List<NewsEntry>> getLatestNews() async {
    // Step 1: Check local cache first
    final cachedNews = await localDataSource.getCachedNews();
    
    // Step 2: If cache exists, return it immediately (for fast, offline access)
    // Also fetch from remote in the background to update cache (fire and forget)
    if (cachedNews.isNotEmpty) {
      // Return cached data immediately for fast response
      // Update cache in background (don't await - fire and forget)
      remoteDataSource.getLatestNews().then((freshNews) {
        // Update cache with fresh data (non-blocking)
        localDataSource.cacheNews(freshNews).catchError((_) {
          // Silently handle cache update errors - cached data is still available
        });
      }).catchError((_) {
        // Silently handle remote fetch errors - cached data is still available
      });
      
      return cachedNews;
    }
    
    // Step 3: Cache is empty - fetch from remote and cache the results
    try {
      final remoteNews = await remoteDataSource.getLatestNews();
      
      // Cache the fetched data for future offline access
      await localDataSource.cacheNews(remoteNews);
      
      return remoteNews;
    } catch (e) {
      // If remote fetch fails and cache is empty, rethrow the error
      // In production, you might want to return empty list or handle gracefully
      rethrow;
    }
  }

  /// Searches news articles by query string using cache-first strategy.
  /// 
  /// **Search Strategy**:
  /// 1. Search local cache first for offline support
  /// 2. If cache has results: Return cached search results immediately
  /// 3. Also search remote in parallel to get comprehensive results
  /// 4. If cache is empty: Search remote and cache the results
  /// 
  /// **Note**: Search is performed client-side on cached data for offline support.
  /// In a production app, you might want to cache search results separately
  /// or use a more sophisticated search indexing strategy.
  /// 
  /// [query] - The search query string to filter news articles.
  /// 
  /// Returns a [Future] that completes with a list of [NewsEntry] domain
  /// entities that match the search query. Returns empty list if no matches.
  /// 
  /// Throws exceptions if both cache and remote operations fail. In a production
  /// app, these would be caught and converted to domain-specific exceptions.
  @override
  Future<List<NewsEntry>> searchNews(String query) async {
    // Step 1: Search local cache first
    final cachedNews = await localDataSource.getCachedNews();
    
    // Perform client-side search on cached data
    final cachedResults = cachedNews
        .where((n) =>
            n.title.toLowerCase().contains(query.toLowerCase()) ||
            n.summary.toLowerCase().contains(query.toLowerCase()))
        .toList();
    
    // Step 2: If cache has results, return them immediately
    // Also search remote in background for comprehensive results (fire and forget)
    if (cachedResults.isNotEmpty) {
      // Return cached search results immediately
      // Search remote in background (don't await - fire and forget)
      remoteDataSource.searchNews(query).then((remoteResults) {
        // If remote has more results, update cache with all news (not just search results)
        // This ensures cache is comprehensive for future searches
        remoteDataSource.getLatestNews().then((allNews) {
          localDataSource.cacheNews(allNews).catchError((_) {
            // Silently handle cache update errors
          });
        }).catchError((_) {
          // Silently handle remote fetch errors
        });
      }).catchError((_) {
        // Silently handle remote search errors - cached results are still available
      });
      
      return cachedResults;
    }
    
    // Step 3: Cache search returned no results - search remote
    try {
      final remoteResults = await remoteDataSource.searchNews(query);
      
      // If remote search found results, update cache with all news for future searches
      // This ensures future searches can find these articles in cache
      if (remoteResults.isNotEmpty) {
        remoteDataSource.getLatestNews().then((allNews) {
          localDataSource.cacheNews(allNews).catchError((_) {
            // Silently handle cache update errors
          });
        }).catchError((_) {
          // Silently handle remote fetch errors
        });
      }
      
      return remoteResults;
    } catch (e) {
      // If remote search fails and cache search returned nothing, rethrow the error
      rethrow;
    }
  }
}
