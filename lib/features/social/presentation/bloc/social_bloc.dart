import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/social_post_entity.dart';
import '../../domain/repositories/social_repository.dart';

abstract class SocialEvent extends Equatable {
  const SocialEvent();
  @override
  List<Object> get props => [];
}

class FetchSocialFeedEvent extends SocialEvent {}

abstract class SocialState extends Equatable {
  const SocialState();
  @override
  List<Object> get props => [];
}

class SocialInitial extends SocialState {}
class SocialLoading extends SocialState {}
class SocialLoaded extends SocialState {
  final List<SocialPostEntity> posts;
  const SocialLoaded(this.posts);
  @override
  List<Object> get props => [posts];
}
class SocialError extends SocialState {
  final String message;
  const SocialError(this.message);
  @override
  List<Object> get props => [message];
}

class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialRepository repository;

  SocialBloc({required this.repository}) : super(SocialInitial()) {
    on<FetchSocialFeedEvent>((event, emit) async {
      emit(SocialLoading());
      try {
        final posts = await repository.getSocialFeed();
        emit(SocialLoaded(posts));
      } catch (e) {
        emit(const SocialError('Could not load social feed'));
      }
    });
  }
}
