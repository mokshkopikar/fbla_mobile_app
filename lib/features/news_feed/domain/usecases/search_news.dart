import '../../../../core/usecases/usecase.dart';
import '../entities/news_entry.dart';
import '../repositories/news_repository.dart';

/// Use case for searching news articles by query string.
/// 
/// This use case implements the Single Responsibility Principle by handling
/// only one specific business operation: searching news articles.
/// 
/// **Architecture**: This is part of the Domain layer in Clean Architecture.
/// It contains pure business logic with no dependencies on Flutter or external
/// frameworks, making it highly testable.
/// 
/// **Usage**: This use case is typically called by:
/// - [NewsBloc] when handling [SearchNewsEvent]
/// - Other domain services that need to search news data
/// 
/// **Search Behavior**: The actual search implementation (filtering logic,
/// case sensitivity, etc.) is handled by the repository layer. This use case
/// simply coordinates the search operation.
/// 
/// **Error Handling**: Errors from the repository are propagated up to the
/// calling layer (typically BLoC) for appropriate handling.
/// 
/// **Example**:
/// ```dart
/// final searchNews = SearchNews(repository);
/// final results = await searchNews('leadership');
/// ```
class SearchNews implements UseCase<List<NewsEntry>, String> {
  /// The repository that provides access to news data.
  /// 
  /// This follows the Repository pattern, abstracting the data source
  /// from the business logic.
  final NewsRepository repository;

  /// Creates a new [SearchNews] use case instance.
  /// 
  /// [repository] - The news repository to search data from (required).
  SearchNews(this.repository);

  /// Executes the use case to search news articles by query.
  /// 
  /// **Implementation Details**:
  /// - Delegates to the repository's [NewsRepository.searchNews] method
  /// - Returns a filtered list of [NewsEntry] entities matching the query
  /// - Throws exceptions if repository operations fail
  /// 
  /// [query] - The search query string entered by the user.
  ///           Should be non-empty for meaningful results.
  /// 
  /// Returns a [Future] that completes with a list of [NewsEntry] objects
  /// that match the search query. Returns empty list if no matches found.
  /// 
  /// Throws exceptions from the repository layer if search operation fails.
  @override
  Future<List<NewsEntry>> call(String query) async {
    // Delegate to repository - this maintains separation of concerns
    // The repository handles the actual search/filtering logic
    return await repository.searchNews(query);
  }
}
