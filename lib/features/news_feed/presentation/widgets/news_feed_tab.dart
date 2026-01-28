import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/news_bloc.dart';

/// Widget that displays the News Feed tab in the dashboard.
/// 
/// This widget implements the News Feed feature UI following Clean Architecture
/// principles. It:
/// - Displays a searchable list of FBLA news articles
/// - Handles user interactions (search, article clicks)
/// - Manages state through BLoC pattern
/// 
/// **Architecture**: This is part of the Presentation layer. It observes
/// [NewsBloc] state changes and rebuilds accordingly.
/// 
/// **User Experience**:
/// - Search field triggers search after 2+ characters
/// - Loading indicator during data fetching
/// - Error messages for failed operations
/// - External browser launch for article links
/// Available news categories matching FBLA website newsroom.
/// 
/// These categories match those found on https://www.fbla.org/newsroom/
const List<String> _newsCategories = [
  'All Categories',
  'National Center News',
  'Chapter Spotlight',
  'State Spotlight',
  'Alumni Spotlight',
];

class NewsFeedTab extends StatefulWidget {
  /// Creates a new [NewsFeedTab] widget.
  const NewsFeedTab({super.key});

  @override
  State<NewsFeedTab> createState() => _NewsFeedTabState();
}

class _NewsFeedTabState extends State<NewsFeedTab> {
  /// Controller for the search text field.
  /// 
  /// Used to manage search input and clear functionality.
  final TextEditingController _searchController = TextEditingController();
  
  /// Currently selected category filter.
  String _selectedCategory = 'All Categories';

  /// Opens a news article URL in the device's default browser.
  /// 
  /// This method demonstrates integration with platform capabilities (url_launcher).
  /// It opens links externally to provide a native browsing experience.
  /// 
  /// **Error Handling**: Errors are logged but not shown to the user to avoid
  /// disrupting the app flow. In a production app, you might show a SnackBar.
  /// 
  /// [urlString] - The URL of the news article to open.
  /// 
  /// Throws [Exception] if the URL cannot be launched, but the exception
  /// is caught and logged internally.
  Future<void> _launchURL(String urlString) async {
    // Parse the URL string into a Uri object
    final Uri url = Uri.parse(urlString);
    
    try {
      // Attempt to launch the URL in external browser
      // LaunchMode.externalApplication ensures it opens in default browser
      // rather than an in-app webview
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $urlString');
      }
    } catch (e) {
      // Log error for debugging purposes
      // In a production app, consider showing a user-friendly error message
      // via SnackBar or similar UI feedback mechanism
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Category filter dropdown and search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Category dropdown filter (similar to FBLA website)
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                items: _newsCategories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newCategory) {
                  if (newCategory != null) {
                    setState(() {
                      _selectedCategory = newCategory;
                      // Clear search when changing category
                      _searchController.clear();
                    });
                    // Apply category filter
                    context.read<NewsBloc>().add(FilterByCategoryEvent(newCategory));
                  }
                },
              ),
              const SizedBox(height: 12),
              // Search input field with clear button and debouncing logic
              // Using ValueListenableBuilder to reactively show/hide clear button
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, child) {
                  return TextField(
                    controller: _searchController,
                    // Handle search input with smart debouncing:
                    // - Search only when query is 3+ characters (reduces API calls)
                    // - Reset to latest news when search is cleared
                    onChanged: (query) {
                      // setState is called automatically by ValueListenableBuilder
                      
                      if (query.length > 2) {
                        // Dispatch search event when user types 3+ characters
                        context.read<NewsBloc>().add(SearchNewsEvent(query));
                      } else if (query.isEmpty) {
                        // Reset to latest news when search field is cleared
                        // Also reset category filter to show all news
                        setState(() {
                          _selectedCategory = 'All Categories';
                        });
                        context.read<NewsBloc>().add(FetchLatestNewsEvent());
                      }
                      // Note: Queries of 1-2 characters are ignored to avoid
                      // excessive API calls and improve performance
                    },
                    decoration: InputDecoration(
                      hintText: 'Search FBLA News...',
                      prefixIcon: const Icon(Icons.search),
                      // Clear button (X) appears when text is entered
                      // ValueListenableBuilder ensures this updates reactively
                      suffixIcon: value.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _selectedCategory = 'All Categories';
                                });
                                // Reset to latest news and clear category filter
                                context.read<NewsBloc>().add(FetchLatestNewsEvent());
                              },
                              tooltip: 'Clear search',
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        
        // News list that reacts to BLoC state changes
        Expanded(
          child: BlocBuilder<NewsBloc, NewsState>(
            // BlocBuilder automatically rebuilds when NewsBloc emits a new state
            builder: (context, state) {
              // Loading state: Show progress indicator
              if (state is NewsLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              // Success state: Display news articles
              else if (state is NewsLoaded) {
                // Handle empty results (e.g., no search matches or category filter)
                if (state.filteredNews.isEmpty) {
                  return Center(
                    child: Text(
                      state.currentCategory == 'All Categories'
                          ? 'No news articles found.'
                          : 'No articles found in "${state.currentCategory}".',
                    ),
                  );
                }
                
                // Display list of filtered news articles
                return ListView.builder(
                  itemCount: state.filteredNews.length,
                  itemBuilder: (context, index) {
                    final entry = state.filteredNews[index];
                    
                    // Each news article is displayed as a Card with:
                    // - Article icon (FBLA blue color)
                    // - Title (bold)
                    // - Date and summary
                    // - External link indicator
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        // FBLA-branded article icon
                        leading: const Icon(
                          Icons.article,
                          color: Color(0xFF003366), // FBLA Blue
                        ),
                        // Indicator that link opens externally
                        trailing: const Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: Colors.grey,
                        ),
                        // Article title (prominent)
                        title: Text(
                          entry.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Date and summary information
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Publication date
                            Text(
                              entry.date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Article summary (truncated to 2 lines)
                            Text(
                              entry.summary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        // Open article in external browser on tap
                        onTap: () => _launchURL(entry.link),
                      ),
                    );
                  },
                );
              }
              
              // Error state: Display error message
              else if (state is NewsError) {
                return Center(child: Text(state.message));
              }
              
              // Initial state: Show nothing (or could show placeholder)
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
