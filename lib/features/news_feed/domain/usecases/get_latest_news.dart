import '../../../../core/usecases/usecase.dart';
import '../entities/news_entry.dart';
import '../repositories/news_repository.dart';

/// Use case for fetching the latest news articles from the repository.
/// 
/// This use case implements the Single Responsibility Principle by handling
/// only one specific business operation: retrieving the latest news feed.
/// 
/// **Architecture**: This is part of the Domain layer in Clean Architecture.
/// It contains pure business logic with no dependencies on Flutter or external
/// frameworks, making it highly testable.
/// 
/// **Usage**: This use case is typically called by:
/// - [NewsBloc] when handling [FetchLatestNewsEvent]
/// - Other domain services that need latest news data
/// 
/// **Error Handling**: Errors from the repository are propagated up to the
/// calling layer (typically BLoC) for appropriate handling.
/// 
/// **Example**:
/// ```dart
/// final getLatestNews = GetLatestNews(repository);
/// final news = await getLatestNews(NoParams());
/// ```
class GetLatestNews implements UseCase<List<NewsEntry>, NoParams> {
  /// The repository that provides access to news data.
  /// 
  /// This follows the Repository pattern, abstracting the data source
  /// from the business logic.
  final NewsRepository repository;

  /// Creates a new [GetLatestNews] use case instance.
  /// 
  /// [repository] - The news repository to fetch data from (required).
  GetLatestNews(this.repository);

  /// Executes the use case to fetch the latest news articles.
  /// 
  /// **Implementation Details**:
  /// - Delegates to the repository's [NewsRepository.getLatestNews] method
  /// - Returns a list of [NewsEntry] entities (domain objects)
  /// - Throws exceptions if repository operations fail
  /// 
  /// [params] - Not used for this use case (use [NoParams]).
  /// 
  /// Returns a [Future] that completes with a list of [NewsEntry] objects
  /// representing the latest news articles.
  /// 
  /// Throws exceptions from the repository layer if data fetching fails.
  @override
  Future<List<NewsEntry>> call(NoParams params) async {
    // Delegate to repository - this maintains separation of concerns
    // The repository handles the actual data retrieval logic
    return await repository.getLatestNews();
  }
}
