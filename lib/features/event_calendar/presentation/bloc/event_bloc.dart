import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';

// ============================================================================
// EVENTS
// ============================================================================

/// Base class for all Event Calendar-related events in the BLoC pattern.
/// 
/// Events represent user actions or system triggers that cause state changes.
/// All events must extend this class and implement [Equatable] for proper
/// state comparison and testing.
abstract class EventEvent extends Equatable {
  const EventEvent();
  
  @override
  List<Object> get props => [];
}

/// Event triggered when the app needs to fetch all events from the repository.
/// 
/// This event is typically dispatched:
/// - On app initialization (from main.dart)
/// - On manual refresh
/// - After creating/updating an event
class FetchEventsEvent extends EventEvent {
  const FetchEventsEvent();
}

/// Event triggered when the user filters events by category.
/// 
/// [category] - The category to filter by (e.g., 'National', 'Competition Deadline', 'All').
/// 
/// This event is dispatched when the user selects a filter option in the UI.
/// The filtering is performed client-side on already-loaded events for better
/// performance and offline support.
class FilterEventsEvent extends EventEvent {
  /// The category name to filter events by.
  /// Use 'All' to show all events without filtering.
  final String category;
  
  const FilterEventsEvent(this.category);
  
  @override
  List<Object> get props => [category];
}

// ============================================================================
// STATES
// ============================================================================

/// Base class for all Event Calendar-related states in the BLoC pattern.
/// 
/// States represent the current condition of the event calendar feature and
/// determine what the UI should display. All states must extend this class
/// and implement [Equatable] for efficient state comparison.
abstract class EventState extends Equatable {
  const EventState();
  
  @override
  List<Object> get props => [];
}

/// Initial state when the Event Calendar feature is first loaded.
/// 
/// This state is emitted before any data fetching begins. The UI typically
/// shows a placeholder or empty state.
class EventInitial extends EventState {
  const EventInitial();
}

/// State emitted when event data is being fetched from the repository.
/// 
/// The UI should display a loading indicator (e.g., CircularProgressIndicator)
/// to provide user feedback during asynchronous operations.
class EventLoading extends EventState {
  const EventLoading();
}

/// State emitted when events have been successfully loaded.
/// 
/// This state maintains both the complete list of events and the currently
/// filtered list, allowing for efficient client-side filtering without
/// additional repository calls.
/// 
/// [allEvents] - The complete, unfiltered list of all events.
/// [filteredEvents] - The currently filtered list of events to display.
/// [currentFilter] - The name of the currently active filter category.
class EventLoaded extends EventState {
  /// All events fetched from the repository (unfiltered).
  final List<EventEntity> allEvents;
  
  /// The filtered list of events currently displayed in the UI.
  final List<EventEntity> filteredEvents;
  
  /// The name of the currently active filter (e.g., 'National', 'All').
  final String currentFilter;

  /// Creates a new [EventLoaded] state.
  /// 
  /// [allEvents] - Complete list of all events (required).
  /// [filteredEvents] - Filtered list to display (required).
  /// [currentFilter] - Active filter name (defaults to 'All').
  const EventLoaded({
    required this.allEvents,
    required this.filteredEvents,
    this.currentFilter = 'All',
  });

  @override
  List<Object> get props => [allEvents, filteredEvents, currentFilter];
}

/// State emitted when an error occurs during event fetching.
/// 
/// [message] - A user-friendly error message to display.
/// 
/// The UI should display this error message to inform the user that
/// something went wrong. In a production app, this could be logged to
/// an error tracking service.
class EventError extends EventState {
  /// Human-readable error message for display in the UI.
  final String message;
  
  const EventError(this.message);
  
  @override
  List<Object> get props => [message];
}

// ============================================================================
// BLoC
// ============================================================================

/// Business Logic Component (BLoC) for managing Event Calendar state.
/// 
/// This BLoC follows the BLoC pattern to separate business logic from the UI.
/// It handles:
/// - Fetching events from the repository
/// - Filtering events by category (client-side)
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
/// 1. UI dispatches an Event (e.g., [FetchEventsEvent])
/// 2. BLoC receives the Event and calls appropriate Repository method
/// 3. Repository executes data retrieval logic
/// 4. BLoC emits a new State (e.g., [EventLoaded])
/// 5. UI rebuilds based on the new State
class EventBloc extends Bloc<EventEvent, EventState> {
  /// The repository that provides access to event data.
  /// 
  /// This follows the Repository pattern, abstracting the data source
  /// from the business logic.
  final EventRepository repository;

  /// Creates a new [EventBloc] instance.
  /// 
  /// [repository] - The event repository to fetch data from (required).
  /// 
  /// Initializes the BLoC with [EventInitial] state and registers event handlers.
  EventBloc({required this.repository}) : super(EventInitial()) {
    // Register event handler for fetching events
    on<FetchEventsEvent>(_onFetchEvents);
    
    // Register event handler for filtering events
    on<FilterEventsEvent>(_onFilterEvents);
  }

  /// Handles [FetchEventsEvent] to load all events from the repository.
  /// 
  /// **State Flow**:
  /// 1. Emit [EventLoading] to show loading indicator
  /// 2. Call repository to fetch all events
  /// 3. On success: Emit [EventLoaded] with all events (initially unfiltered)
  /// 4. On error: Emit [EventError] with error message
  /// 
  /// [event] - The fetch event (unused, but required by BLoC pattern).
  /// [emit] - Function to emit new states.
  Future<void> _onFetchEvents(
    FetchEventsEvent event,
    Emitter<EventState> emit,
  ) async {
    // Show loading state immediately for better UX
    emit(EventLoading());
    
    try {
      // Execute the repository method to fetch events
      final events = await repository.getEvents();
      
      // Emit success state with all events
      // Initially, filteredEvents equals allEvents (no filter applied)
      emit(EventLoaded(
        allEvents: events,
        filteredEvents: events,
      ));
    } catch (e) {
      // Emit error state with user-friendly message
      // In production, you might want to log the actual error (e) for debugging
      emit(const EventError('Failed to load events.'));
    }
  }

  /// Handles [FilterEventsEvent] to filter events by category.
  /// 
  /// **Implementation**: This performs client-side filtering on already-loaded
  /// events for better performance and offline support. No repository call is needed.
  /// 
  /// **State Flow**:
  /// 1. Check if current state is [EventLoaded] (has data to filter)
  /// 2. Filter the allEvents list based on category
  /// 3. Emit new [EventLoaded] state with filtered results
  /// 
  /// **Note**: If the current state is not [EventLoaded], this handler does nothing.
  /// This prevents filtering when no events are loaded.
  /// 
  /// [event] - The filter event containing the category to filter by.
  /// [emit] - Function to emit new states.
  void _onFilterEvents(
    FilterEventsEvent event,
    Emitter<EventState> emit,
  ) {
    // Only filter if we have loaded events
    if (state is EventLoaded) {
      final loadedState = state as EventLoaded;
      
      // Determine filtered list based on category
      // 'All' means no filtering - show all events
      // Otherwise, filter by matching category
      final filteredList = event.category == 'All'
          ? loadedState.allEvents
          : loadedState.allEvents
              .where((e) => e.category == event.category)
              .toList();
      
      // Emit new state with filtered results
      // Preserve allEvents for future filtering operations
      emit(EventLoaded(
        allEvents: loadedState.allEvents,
        filteredEvents: filteredList,
        currentFilter: event.category,
      ));
    }
    // If state is not EventLoaded, do nothing
    // This prevents filtering when data hasn't been loaded yet
  }
}
