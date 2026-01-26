import '../../../../core/usecases/usecase.dart';
import '../entities/news_entry.dart';
import '../repositories/news_repository.dart';

/// Use case for searching historical news entries.
class SearchNews implements UseCase<List<NewsEntry>, String> {
  final NewsRepository repository;

  SearchNews(this.repository);

  @override
  Future<List<NewsEntry>> call(String query) async {
    return await repository.searchNews(query);
  }
}
