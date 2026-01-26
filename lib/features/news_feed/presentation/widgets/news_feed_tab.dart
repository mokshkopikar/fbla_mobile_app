import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/news_bloc.dart';

class NewsFeedTab extends StatelessWidget {
  const NewsFeedTab({super.key});

  /// Opens the news article link in an external browser.
  /// 
  /// This demonstrates how the Presentation layer handles external interactions.
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      // In a real app, show a snackbar or log the error
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (query) {
              if (query.length > 2) {
                context.read<NewsBloc>().add(SearchNewsEvent(query));
              } else if (query.isEmpty) {
                context.read<NewsBloc>().add(FetchLatestNewsEvent());
              }
            },
            decoration: InputDecoration(
              hintText: 'Search FBLA News...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state is NewsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NewsLoaded) {
                if (state.news.isEmpty) {
                  return const Center(child: Text('No news articles found.'));
                }
                return ListView.builder(
                  itemCount: state.news.length,
                  itemBuilder: (context, index) {
                    final entry = state.news[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.article, color: Color(0xFF003366)),
                        trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
                        title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(entry.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                        onTap: () => _launchURL(entry.link),
                      ),
                    );
                  },
                );
              } else if (state is NewsError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
