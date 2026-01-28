import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/social_post_entity.dart';
import '../../domain/repositories/social_repository.dart';

// ============================================================================
// EVENTS
// ============================================================================

/// Base class for all Social Feed-related events in the BLoC pattern.
/// 
/// Events represent user actions or system triggers that cause state changes.
/// All events must extend this class and implement [Equatable] for proper
/// state comparison and testing.
abstract class SocialEvent extends Equatable {
  const SocialEvent();
  
  @override
  List<Object> get props => [];
}

/// Event triggered when the app needs to fetch the social feed from the repository.
/// 
/// This event is typically dispatched:
/// - On app initialization (from main.dart)
/// - On manual refresh
/// - When navigating to the social tab
class FetchSocialFeedEvent extends SocialEvent {
  const FetchSocialFeedEvent();
}

// ============================================================================
// STATES
// ============================================================================

/// Base class for all Social Feed-related states in the BLoC pattern.
/// 
/// States represent the current condition of the social feed feature and determine
/// what the UI should display. All states must extend this class and implement
/// [Equatable] for efficient state comparison.
abstract class SocialState extends Equatable {
  const SocialState();
  
  @override
  List<Object> get props => [];
}

/// Initial state when the Social Feed feature is first loaded.
/// 
/// This state is emitted before any data fetching begins. The UI typically
/// shows a placeholder or empty state.
class SocialInitial extends SocialState {
  const SocialInitial();
}

/// State emitted when social feed data is being fetched from the repository.
/// 
/// The UI should display a loading indicator (e.g., CircularProgressIndicator)
/// to provide user feedback during asynchronous operations.
class SocialLoading extends SocialState {
  const SocialLoading();
}

/// State emitted when social feed posts have been successfully loaded.
/// 
/// [posts] - The list of social media posts to display in the UI.
/// 
/// This state contains the actual data that will be rendered in the social feed.
/// The UI should display the list of posts when this state is active.
class SocialLoaded extends SocialState {
  /// The list of social media posts to display.
  final List<SocialPostEntity> posts;
  
  const SocialLoaded(this.posts);
  
  @override
  List<Object> get props => [posts];
}

/// State emitted when an error occurs during social feed fetching.
/// 
/// [message] - A user-friendly error message to display.
/// 
/// The UI should display this error message to inform the user that
/// something went wrong. In a production app, this could be logged to
/// an error tracking service.
class SocialError extends SocialState {
  /// Human-readable error message for display in the UI.
  final String message;
  
  const SocialError(this.message);
  
  @override
  List<Object> get props => [message];
}

// ============================================================================
// BLoC
// ============================================================================

/// Business Logic Component (BLoC) for managing Social Feed state.
/// 
/// This BLoC follows the BLoC pattern to separate business logic from the UI.
/// It handles:
/// - Fetching social media posts from the repository
/// 
/// **Architecture Pattern**: This is part of the Presentation layer in Clean
/// Architecture. It coordinates between the UI (widgets) and the Domain layer
/// (repository).
/// 
/// **Dependency Injection**: Dependencies are injected via constructor,
/// making this class highly testable. See [injection_container.dart] for
/// dependency registration.
/// 
/// **State Flow**:
/// 1. UI dispatches an Event (e.g., [FetchSocialFeedEvent])
/// 2. BLoC receives the Event and calls appropriate Repository method
/// 3. Repository executes data retrieval logic
/// 4. BLoC emits a new State (e.g., [SocialLoaded])
/// 5. UI rebuilds based on the new State
class SocialBloc extends Bloc<SocialEvent, SocialState> {
  /// The repository that provides access to social feed data.
  /// 
  /// This follows the Repository pattern, abstracting the data source
  /// from the business logic.
  final SocialRepository repository;

  /// Creates a new [SocialBloc] instance.
  /// 
  /// [repository] - The social repository to fetch data from (required).
  /// 
  /// Initializes the BLoC with [SocialInitial] state and registers event handlers.
  SocialBloc({required this.repository}) : super(SocialInitial()) {
    // Register event handler for fetching social feed
    on<FetchSocialFeedEvent>(_onFetchSocialFeed);
  }

  /// Handles [FetchSocialFeedEvent] to load social feed posts from the repository.
  /// 
  /// **State Flow**:
  /// 1. Emit [SocialLoading] to show loading indicator
  /// 2. Call repository to fetch social feed posts
  /// 3. On success: Emit [SocialLoaded] with fetched posts
  /// 4. On error: Emit [SocialError] with error message
  /// 
  /// [event] - The fetch event (unused, but required by BLoC pattern).
  /// [emit] - Function to emit new states.
  Future<void> _onFetchSocialFeed(
    FetchSocialFeedEvent event,
    Emitter<SocialState> emit,
  ) async {
    // Show loading state immediately for better UX
    emit(SocialLoading());
    
    try {
      // Execute the repository method to fetch social feed posts
      final posts = await repository.getSocialFeed();
      
      // Emit success state with fetched data
      emit(SocialLoaded(posts));
    } catch (e) {
      // Emit error state with user-friendly message
      // In production, you might want to log the actual error (e) for debugging
      emit(const SocialError('Could not load social feed'));
    }
  }
}
