import '../../../../core/usecases/usecase.dart';
import '../entities/news_entry.dart';
import '../repositories/news_repository.dart';

/// Use case for fetching the main newsfeed list.
class GetLatestNews implements UseCase<List<NewsEntry>, NoParams> {
  final NewsRepository repository;

  GetLatestNews(this.repository);

  @override
  Future<List<NewsEntry>> call(NoParams params) async {
    return await repository.getLatestNews();
  }
}
