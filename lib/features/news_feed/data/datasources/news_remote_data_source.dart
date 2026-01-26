import '../models/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getLatestNews();
  Future<List<NewsModel>> searchNews(String query);
}

/// Mock Implementation for newsfeed to ensure "Standalone Ready" demo.
/// 
/// Real implementation would use 'http' to scrape or fetch from 
/// https://www.fbla.org/newsroom/
class MockNewsRemoteDataSource implements NewsRemoteDataSource {
  final List<NewsModel> _mockNews = [
    const NewsModel(
      id: 'n1',
      title: 'FBLA National Leadership Conference 2026',
      date: 'Jan 15, 2026',
      summary: 'Registration is now open for the premier FBLA event of the year!',
      link: 'https://www.fbla.org/newsroom/',
    ),
    const NewsModel(
      id: 'n2',
      title: 'Spring Chapter Awards Announced',
      date: 'Jan 10, 2026',
      summary: 'Recognizing outstanding achievements in local community service.',
      link: 'https://www.fbla.org/newsroom/',
    ),
    const NewsModel(
      id: 'n3',
      title: 'New Member Engagement Tool Released',
      date: 'Jan 05, 2026',
      summary: 'Check out the new mobile features designed for FBLA members.',
      link: 'https://www.fbla.org/newsroom/',
    ),
  ];

  @override
  Future<List<NewsModel>> getLatestNews() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockNews;
  }

  @override
  Future<List<NewsModel>> searchNews(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockNews
        .where((n) => n.title.toLowerCase().contains(query.toLowerCase()) || 
                      n.summary.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
