import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/resource_entity.dart';
import '../../domain/repositories/resource_repository.dart';

// ============================================================================
// EVENTS
// ============================================================================

/// Base class for all Resource-related events in the BLoC pattern.
/// 
/// Events represent user actions or system triggers that cause state changes.
/// All events must extend this class and implement [Equatable] for proper
/// state comparison and testing.
abstract class ResourceEvent extends Equatable {
  const ResourceEvent();
  
  @override
  List<Object> get props => [];
}

/// Event triggered when the app needs to fetch all resources from the repository.
/// 
/// This event is typically dispatched:
/// - On app initialization (from main.dart)
/// - On manual refresh
/// - When search is cleared
class FetchResourcesEvent extends ResourceEvent {
  const FetchResourcesEvent();
}

/// Event triggered when the user searches for resources.
/// 
/// [query] - The search term entered by the user.
/// 
/// This event is dispatched from the search TextField. The search is performed
/// on the repository level, which may search across title, description, and category.
class SearchResourcesEvent extends ResourceEvent {
  /// The search query string entered by the user.
  final String query;
  
  const SearchResourcesEvent(this.query);
  
  @override
  List<Object> get props => [query];
}

// ============================================================================
// STATES
// ============================================================================

/// Base class for all Resource-related states in the BLoC pattern.
/// 
/// States represent the current condition of the resources feature and determine
/// what the UI should display. All states must extend this class and implement
/// [Equatable] for efficient state comparison.
abstract class ResourceState extends Equatable {
  const ResourceState();
  
  @override
  List<Object> get props => [];
}

/// Initial state when the Resources feature is first loaded.
/// 
/// This state is emitted before any data fetching begins. The UI typically
/// shows a placeholder or empty state.
class ResourceInitial extends ResourceState {
  const ResourceInitial();
}

/// State emitted when resource data is being fetched from the repository.
/// 
/// The UI should display a loading indicator (e.g., CircularProgressIndicator)
/// to provide user feedback during asynchronous operations.
class ResourceLoading extends ResourceState {
  const ResourceLoading();
}

/// State emitted when resources have been successfully loaded.
/// 
/// [resources] - The list of resource entities to display in the UI.
/// 
/// This state contains the actual data that will be rendered in the resources list.
/// The UI should display the list of resources when this state is active.
class ResourceLoaded extends ResourceState {
  /// The list of resource entries to display.
  final List<ResourceEntity> resources;
  
  const ResourceLoaded(this.resources);
  
  @override
  List<Object> get props => [resources];
}

/// State emitted when an error occurs during resource fetching or searching.
/// 
/// [message] - A user-friendly error message to display.
/// 
/// The UI should display this error message to inform the user that
/// something went wrong. In a production app, this could be logged to
/// an error tracking service.
class ResourceError extends ResourceState {
  /// Human-readable error message for display in the UI.
  final String message;
  
  const ResourceError(this.message);
  
  @override
  List<Object> get props => [message];
}

// ============================================================================
// BLoC
// ============================================================================

/// Business Logic Component (BLoC) for managing Resources state.
/// 
/// This BLoC follows the BLoC pattern to separate business logic from the UI.
/// It handles:
/// - Fetching all resources from the repository
/// - Searching resources by query string
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
/// 1. UI dispatches an Event (e.g., [FetchResourcesEvent])
/// 2. BLoC receives the Event and calls appropriate Repository method
/// 3. Repository executes data retrieval/search logic
/// 4. BLoC emits a new State (e.g., [ResourceLoaded])
/// 5. UI rebuilds based on the new State
class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  /// The repository that provides access to resource data.
  /// 
  /// This follows the Repository pattern, abstracting the data source
  /// from the business logic.
  final ResourceRepository repository;

  /// Creates a new [ResourceBloc] instance.
  /// 
  /// [repository] - The resource repository to fetch/search data from (required).
  /// 
  /// Initializes the BLoC with [ResourceInitial] state and registers event handlers.
  ResourceBloc({required this.repository}) : super(ResourceInitial()) {
    // Register event handler for fetching all resources
    on<FetchResourcesEvent>(_onFetchResources);
    
    // Register event handler for searching resources
    on<SearchResourcesEvent>(_onSearchResources);
  }

  /// Handles [FetchResourcesEvent] to load all resources from the repository.
  /// 
  /// **State Flow**:
  /// 1. Emit [ResourceLoading] to show loading indicator
  /// 2. Call repository to fetch all resources
  /// 3. On success: Emit [ResourceLoaded] with fetched resources
  /// 4. On error: Emit [ResourceError] with error message
  /// 
  /// [event] - The fetch event (unused, but required by BLoC pattern).
  /// [emit] - Function to emit new states.
  Future<void> _onFetchResources(
    FetchResourcesEvent event,
    Emitter<ResourceState> emit,
  ) async {
    // Show loading state immediately for better UX
    emit(ResourceLoading());
    
    try {
      // Execute the repository method to fetch all resources
      final resources = await repository.getResources();
      
      // Emit success state with fetched data
      emit(ResourceLoaded(resources));
    } catch (e) {
      // Emit error state with user-friendly message
      // In production, you might want to log the actual error (e) for debugging
      emit(const ResourceError('Failed to load resources'));
    }
  }

  /// Handles [SearchResourcesEvent] to search resources by query.
  /// 
  /// **State Flow**:
  /// 1. Emit [ResourceLoading] to show loading indicator
  /// 2. Call repository to search resources with the query
  /// 3. On success: Emit [ResourceLoaded] with search results
  /// 4. On error: Emit [ResourceError] with error message
  /// 
  /// **Search Behavior**: The actual search implementation (what fields are
  /// searched, case sensitivity, etc.) is handled by the repository layer.
  /// 
  /// [event] - The search event containing the user's query.
  /// [emit] - Function to emit new states.
  Future<void> _onSearchResources(
    SearchResourcesEvent event,
    Emitter<ResourceState> emit,
  ) async {
    // Show loading state immediately for better UX
    emit(ResourceLoading());
    
    try {
      // Execute the repository method to search resources with the provided query
      final resources = await repository.searchResources(event.query);
      
      // Emit success state with search results
      emit(ResourceLoaded(resources));
    } catch (e) {
      // Emit error state with user-friendly message
      // In production, you might want to log the actual error (e) for debugging
      emit(const ResourceError('Search failed'));
    }
  }
}
