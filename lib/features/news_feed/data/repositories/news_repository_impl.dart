import '../../domain/entities/news_entry.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NewsEntry>> getLatestNews() async {
    return await remoteDataSource.getLatestNews();
  }

  @override
  Future<List<NewsEntry>> searchNews(String query) async {
    return await remoteDataSource.searchNews(query);
  }
}
