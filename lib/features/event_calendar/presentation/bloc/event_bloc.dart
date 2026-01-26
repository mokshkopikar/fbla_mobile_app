import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';

// --- Events ---
abstract class EventEvent extends Equatable {
  const EventEvent();
  @override
  List<Object> get props => [];
}

class FetchEventsEvent extends EventEvent {}

class FilterEventsEvent extends EventEvent {
  final String category;
  const FilterEventsEvent(this.category);
  @override
  List<Object> get props => [category];
}

// --- States ---
abstract class EventState extends Equatable {
  const EventState();
  @override
  List<Object> get props => [];
}

class EventInitial extends EventState {}
class EventLoading extends EventState {}
class EventLoaded extends EventState {
  final List<EventEntity> allEvents;
  final List<EventEntity> filteredEvents;
  final String currentFilter;

  const EventLoaded({
    required this.allEvents,
    required this.filteredEvents,
    this.currentFilter = 'All',
  });

  @override
  List<Object> get props => [allEvents, filteredEvents, currentFilter];
}
class EventError extends EventState {
  final String message;
  const EventError(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository repository;

  EventBloc({required this.repository}) : super(EventInitial()) {
    on<FetchEventsEvent>((event, emit) async {
      emit(EventLoading());
      try {
        final events = await repository.getEvents();
        emit(EventLoaded(allEvents: events, filteredEvents: events));
      } catch (e) {
        emit(const EventError('Failed to load events.'));
      }
    });

    on<FilterEventsEvent>((event, emit) {
      if (state is EventLoaded) {
        final loadedState = state as EventLoaded;
        final filteredList = event.category == 'All' 
            ? loadedState.allEvents 
            : loadedState.allEvents.where((e) => e.category == event.category).toList();
        
        emit(EventLoaded(
          allEvents: loadedState.allEvents,
          filteredEvents: filteredList,
          currentFilter: event.category,
        ));
      }
    });
  }
}
