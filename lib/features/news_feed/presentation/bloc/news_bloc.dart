import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/news_entry.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../../domain/usecases/search_news.dart';
import '../../../../core/usecases/usecase.dart';

// ============================================================================
// EVENTS
// ============================================================================

/// Base class for all News-related events in the BLoC pattern.
/// 
/// Events represent user actions or system triggers that cause state changes.
/// All events must extend this class and implement [Equatable] for proper
/// state comparison and testing.
abstract class NewsEvent extends Equatable {
  const NewsEvent();
  
  @override
  List<Object> get props => [];
}

/// Event triggered when the app needs to fetch the latest news articles.
/// 
/// This event is typically dispatched:
/// - On app initialization (from main.dart)
/// - When user clears the search field
/// - On manual refresh
class FetchLatestNewsEvent extends NewsEvent {
  const FetchLatestNewsEvent();
}

/// Event triggered when the user searches for news articles.
/// 
/// [query] - The search term entered by the user.
/// 
/// This event is dispatched from the search TextField when the query
/// length exceeds 2 characters to avoid excessive API calls.
class SearchNewsEvent extends NewsEvent {
  /// The search query string entered by the user.
  final String query;
  
  const SearchNewsEvent(this.query);
  
  @override
  List<Object> get props => [query];
}

/// Event triggered when the user filters news articles by category.
/// 
/// [category] - The category to filter by (e.g., 'National Center News', 'All Categories').
/// 
/// This event is dispatched when the user selects a category from the dropdown.
/// The filtering is performed client-side on already-loaded news for better
/// performance and offline support.
class FilterByCategoryEvent extends NewsEvent {
  /// The category name to filter news by.
  /// Use 'All Categories' to show all news without filtering.
  final String category;
  
  const FilterByCategoryEvent(this.category);
  
  @override
  List<Object> get props => [category];
}

// ============================================================================
// STATES
// ============================================================================

/// Base class for all News-related states in the BLoC pattern.
/// 
/// States represent the current condition of the news feature and determine
/// what the UI should display. All states must extend this class and implement
/// [Equatable] for efficient state comparison.
abstract class NewsState extends Equatable {
  const NewsState();
  
  @override
  List<Object> get props => [];
}

/// Initial state when the News feature is first loaded.
/// 
/// This state is emitted before any data fetching begins. The UI typically
/// shows a placeholder or empty state.
class NewsInitial extends NewsState {
  const NewsInitial();
}

/// State emitted when news data is being fetched from the repository.
/// 
/// The UI should display a loading indicator (e.g., CircularProgressIndicator)
/// to provide user feedback during asynchronous operations.
class NewsLoading extends NewsState {
  const NewsLoading();
}

/// State emitted when news data has been successfully loaded.
/// 
/// This state maintains both the complete list of news and the currently
/// filtered list, allowing for efficient client-side filtering without
/// additional repository calls.
/// 
/// [allNews] - The complete, unfiltered list of all news articles.
/// [filteredNews] - The currently filtered list of news articles to display.
/// [currentCategory] - The name of the currently active filter category.
class NewsLoaded extends NewsState {
  /// All news articles fetched from the repository (unfiltered).
  final List<NewsEntry> allNews;
  
  /// The filtered list of news articles currently displayed in the UI.
  final List<NewsEntry> filteredNews;
  
  /// The name of the currently active filter category (e.g., 'National Center News', 'All Categories').
  final String currentCategory;

  /// Creates a new [NewsLoaded] state.
  /// 
  /// [allNews] - Complete list of all news (required).
  /// [filteredNews] - Filtered list to display (required).
  /// [currentCategory] - Active filter category name (defaults to 'All Categories').
  const NewsLoaded({
    required this.allNews,
    required this.filteredNews,
    this.currentCategory = 'All Categories',
  });
  
  @override
  List<Object> get props => [allNews, filteredNews, currentCategory];
}

/// State emitted when an error occurs during news fetching or searching.
/// 
/// [message] - A user-friendly error message to display.
/// 
/// The UI should display this error message to inform the user that
/// something went wrong. In a production app, this could be logged to
/// an error tracking service.
class NewsError extends NewsState {
  /// Human-readable error message for display in the UI.
  final String message;
  
  const NewsError(this.message);
  
  @override
  List<Object> get props => [message];
}

// ============================================================================
// BLoC
// ============================================================================

/// Business Logic Component (BLoC) for managing News Feed state.
/// 
  /// This BLoC follows the BLoC pattern to separate business logic from the UI.
  /// It handles:
  /// - Fetching the latest news articles
  /// - Searching news articles by query
  /// - Filtering news articles by category
/// 
/// **Architecture Pattern**: This is part of the Presentation layer in Clean
/// Architecture. It coordinates between the UI (widgets) and the Domain layer
/// (use cases).
/// 
/// **Dependency Injection**: Dependencies are injected via constructor,
/// making this class highly testable. See [injection_container.dart] for
/// dependency registration.
/// 
/// **State Flow**:
/// 1. UI dispatches an Event (e.g., [FetchLatestNewsEvent])
/// 2. BLoC receives the Event and calls appropriate Use Case
/// 3. Use Case executes business logic via Repository
/// 4. BLoC emits a new State (e.g., [NewsLoaded])
/// 5. UI rebuilds based on the new State
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  /// Use case for fetching the latest news articles.
  final GetLatestNews getLatestNews;
  
  /// Use case for searching news articles by query.
  final SearchNews searchNews;

  /// Creates a new [NewsBloc] instance.
  /// 
  /// [getLatestNews] - Use case for fetching latest news (required).
  /// [searchNews] - Use case for searching news (required).
  /// 
  /// Initializes the BLoC with [NewsInitial] state and registers event handlers.
  NewsBloc({
    required this.getLatestNews,
    required this.searchNews,
  }) : super(NewsInitial()) {
    // Register event handler for fetching latest news
    on<FetchLatestNewsEvent>(_onFetchLatestNews);
    
    // Register event handler for searching news
    on<SearchNewsEvent>(_onSearchNews);
    
    // Register event handler for filtering by category
    on<FilterByCategoryEvent>(_onFilterByCategory);
  }

  /// Handles [FetchLatestNewsEvent] to load the latest news articles.
  /// 
  /// **State Flow**:
  /// 1. Emit [NewsLoading] to show loading indicator
  /// 2. Call [getLatestNews] use case to fetch data
  /// 3. On success: Emit [NewsLoaded] with the fetched news
  /// 4. On error: Emit [NewsError] with error message
  /// 
  /// [event] - The fetch event (unused, but required by BLoC pattern).
  /// [emit] - Function to emit new states.
  Future<void> _onFetchLatestNews(
    FetchLatestNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    // Show loading state immediately for better UX
    emit(NewsLoading());
    
    try {
      // Execute the use case to fetch news from repository
      final news = await getLatestNews(NoParams());
      
      // Emit success state with all news
      // Initially, filteredNews equals allNews (no filter applied)
      emit(NewsLoaded(
        allNews: news,
        filteredNews: news,
      ));
    } catch (e) {
      // Emit error state with user-friendly message
      // In production, you might want to log the actual error (e) for debugging
      emit(const NewsError('Failed to fetch news.'));
    }
  }

  /// Handles [SearchNewsEvent] to search news articles by query.
  /// 
  /// **State Flow**:
  /// 1. Emit [NewsLoading] to show loading indicator
  /// 2. Call [searchNews] use case with the search query
  /// 3. On success: Emit [NewsLoaded] with filtered results
  /// 4. On error: Emit [NewsError] with error message
  /// 
  /// [event] - The search event containing the user's query.
  /// [emit] - Function to emit new states.
  Future<void> _onSearchNews(
    SearchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    // Show loading state immediately for better UX
    emit(NewsLoading());
    
    try {
      // Execute the use case to search news with the provided query
      final news = await searchNews(event.query);
      
      // Emit success state with search results
      // When searching, we maintain the search results as both allNews and filteredNews
      // This allows category filtering to work on search results
      // Category filter is reset when searching
      emit(NewsLoaded(
        allNews: news,
        filteredNews: news,
        currentCategory: 'All Categories',
      ));
    } catch (e) {
      // Emit error state with user-friendly message
      // In production, you might want to log the actual error (e) for debugging
      emit(const NewsError('Search failed.'));
    }
  }

  /// Handles [FilterByCategoryEvent] to filter news by category.
  /// 
  /// **Implementation**: This performs client-side filtering on already-loaded
  /// news for better performance and offline support. No repository call is needed.
  /// 
  /// **State Flow**:
  /// 1. Check if current state is [NewsLoaded] (has data to filter)
  /// 2. Filter the allNews list based on category
  /// 3. Emit new [NewsLoaded] state with filtered results
  /// 
  /// **Note**: If the current state is not [NewsLoaded], this handler does nothing.
  /// This prevents filtering when no news are loaded.
  /// 
  /// [event] - The filter event containing the category to filter by.
  /// [emit] - Function to emit new states.
  void _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<NewsState> emit,
  ) {
    // Only filter if we have loaded news
    if (state is NewsLoaded) {
      final loadedState = state as NewsLoaded;
      
      // Determine filtered list based on category
      // 'All Categories' means no filtering - show all news
      // Otherwise, filter by matching category
      final filteredList = event.category == 'All Categories'
          ? loadedState.allNews
          : loadedState.allNews
              .where((n) => n.category == event.category)
              .toList();
      
      // Emit new state with filtered results
      // Preserve allNews for future filtering operations
      emit(NewsLoaded(
        allNews: loadedState.allNews,
        filteredNews: filteredList,
        currentCategory: event.category,
      ));
    }
    // If state is not NewsLoaded, do nothing
    // This prevents filtering when data hasn't been loaded yet
  }
}
