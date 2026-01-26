import '../entities/news_entry.dart';

/// Interface for Newsfeed data operations.
abstract class NewsRepository {
  /// Fetches the latest news entries.
  Future<List<NewsEntry>> getLatestNews();

  /// Searches past news entries based on a query.
  Future<List<NewsEntry>> searchNews(String query);
}
