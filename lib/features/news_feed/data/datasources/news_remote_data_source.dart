import '../models/news_model.dart';

/// Abstract interface for remote news data source operations.
/// 
/// This interface defines the contract for fetching news data from remote sources
/// (e.g., API, web scraping). Implementations can be swapped without affecting
/// the repository or business logic layers.
/// 
/// **Architecture**: Part of the Data layer in Clean Architecture.
/// This abstraction allows for:
/// - Easy testing with mock implementations
/// - Switching between mock and real API implementations
/// - Offline support with local data sources
abstract class NewsRemoteDataSource {
  /// Fetches the latest news articles from the remote source.
  /// 
  /// Returns a [Future] that completes with a list of [NewsModel] objects.
  /// 
  /// Throws exceptions if the remote operation fails (network errors, etc.).
  Future<List<NewsModel>> getLatestNews();
  
  /// Searches news articles by query string.
  /// 
  /// [query] - The search term to filter news articles.
  /// 
  /// Returns a [Future] that completes with a list of [NewsModel] objects
  /// matching the search query. Returns empty list if no matches found.
  /// 
  /// Throws exceptions if the remote operation fails.
  Future<List<NewsModel>> searchNews(String query);
}

/// Mock implementation of [NewsRemoteDataSource] for standalone demo purposes.
/// 
/// **Purpose**: This implementation provides mock data to ensure the app is
/// "Standalone Ready" as required by the FBLA competition. The app works
/// completely offline without requiring internet connectivity.
/// 
/// **Real-World Implementation**: In a production app, this would be replaced
/// with an implementation that:
/// - Makes HTTP requests to FBLA API or website
/// - Handles network errors gracefully
/// - Implements caching for offline support
/// - Parses JSON/HTML responses into [NewsModel] objects
/// 
/// **Data Source**: Currently uses hardcoded mock data. Real implementation
/// would fetch from: https://www.fbla.org/newsroom/
/// 
/// **Performance**: Includes artificial delays to simulate network latency,
/// making the demo more realistic.
class MockNewsRemoteDataSource implements NewsRemoteDataSource {
  /// Hardcoded list of mock news articles for demonstration.
  /// 
  /// Categories match those on the FBLA website newsroom:
  /// - National Center News
  /// - Chapter Spotlight
  /// - State Spotlight
  /// - Alumni Spotlight
  /// 
  /// In a real implementation, this would be fetched from an API or
  /// scraped from the FBLA website.
  final List<NewsModel> _mockNews = [
    const NewsModel(
      id: 'n1',
      title: 'FBLA National Leadership Conference 2026',
      date: 'Jan 15, 2026',
      summary: 'Registration is now open for the premier FBLA event of the year!',
      link: 'https://www.fbla.org/newsroom/',
      category: 'National Center News',
    ),
    const NewsModel(
      id: 'n2',
      title: 'Spring Chapter Awards Announced',
      date: 'Jan 10, 2026',
      summary: 'Recognizing outstanding achievements in local community service.',
      link: 'https://www.fbla.org/newsroom/',
      category: 'Chapter Spotlight',
    ),
    const NewsModel(
      id: 'n3',
      title: 'New Member Engagement Tool Released',
      date: 'Jan 05, 2026',
      summary: 'Check out the new mobile features designed for FBLA members.',
      link: 'https://www.fbla.org/newsroom/',
      category: 'National Center News',
    ),
    const NewsModel(
      id: 'n4',
      title: 'Colorado FBLA Fall Leadership Conference Success',
      date: 'Dec 4, 2025',
      summary: 'Colorado FBLA brings together 500+ students for dynamic leadership development.',
      link: 'https://www.fbla.org/newsroom/',
      category: 'State Spotlight',
    ),
    const NewsModel(
      id: 'n5',
      title: 'Alumni Success: From FBLA to Entrepreneurship',
      date: 'Dec 5, 2025',
      summary: 'Former FBLA member creates innovative business solution for rural communities.',
      link: 'https://www.fbla.org/newsroom/',
      category: 'Alumni Spotlight',
    ),
  ];

  /// Fetches the latest news articles (mock implementation).
  /// 
  /// **Implementation Details**:
  /// - Simulates network delay (800ms) for realistic demo experience
  /// - Returns all mock news articles
  /// 
  /// Returns a [Future] that completes with the list of mock news articles
  /// after a simulated delay.
  @override
  Future<List<NewsModel>> getLatestNews() async {
    // Simulate network latency for realistic demo
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return all mock news articles
    return _mockNews;
  }

  /// Searches news articles by query (mock implementation).
  /// 
  /// **Search Logic**:
  /// - Performs case-insensitive search
  /// - Searches in both title and summary fields
  /// - Returns matching articles
  /// 
  /// **Implementation Details**:
  /// - Simulates network delay (500ms) for realistic demo experience
  /// - Filters mock articles based on query matching
  /// 
  /// [query] - The search term to filter articles by.
  /// 
  /// Returns a [Future] that completes with filtered news articles matching
  /// the query. Returns empty list if no matches found.
  @override
  Future<List<NewsModel>> searchNews(String query) async {
    // Simulate network latency for realistic demo
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Perform case-insensitive search in title and summary
    // In a real implementation, this would be done server-side
    return _mockNews
        .where((n) =>
            n.title.toLowerCase().contains(query.toLowerCase()) ||
            n.summary.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
