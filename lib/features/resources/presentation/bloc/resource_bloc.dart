import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/resource_entity.dart';
import '../../domain/repositories/resource_repository.dart';

// --- Events ---
abstract class ResourceEvent extends Equatable {
  const ResourceEvent();
  @override
  List<Object> get props => [];
}

class FetchResourcesEvent extends ResourceEvent {}

class SearchResourcesEvent extends ResourceEvent {
  final String query;
  const SearchResourcesEvent(this.query);
  @override
  List<Object> get props => [query];
}

// --- States ---
abstract class ResourceState extends Equatable {
  const ResourceState();
  @override
  List<Object> get props => [];
}

class ResourceInitial extends ResourceState {}
class ResourceLoading extends ResourceState {}
class ResourceLoaded extends ResourceState {
  final List<ResourceEntity> resources;
  const ResourceLoaded(this.resources);
  @override
  List<Object> get props => [resources];
}
class ResourceError extends ResourceState {
  final String message;
  const ResourceError(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  final ResourceRepository repository;

  ResourceBloc({required this.repository}) : super(ResourceInitial()) {
    on<FetchResourcesEvent>((event, emit) async {
      emit(ResourceLoading());
      try {
        final resources = await repository.getResources();
        emit(ResourceLoaded(resources));
      } catch (e) {
        emit(const ResourceError('Failed to load resources'));
      }
    });

    on<SearchResourcesEvent>((event, emit) async {
      emit(ResourceLoading());
      try {
        final resources = await repository.searchResources(event.query);
        emit(ResourceLoaded(resources));
      } catch (e) {
        emit(const ResourceError('Search failed'));
      }
    });
  }
}
