import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/news_entry.dart';
import '../../domain/usecases/get_latest_news.dart';
import '../../domain/usecases/search_news.dart';
import '../../../../core/usecases/usecase.dart';

// --- Events ---
abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

class FetchLatestNewsEvent extends NewsEvent {}

class SearchNewsEvent extends NewsEvent {
  final String query;
  const SearchNewsEvent(this.query);
  @override
  List<Object> get props => [query];
}

// --- States ---
abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}
class NewsLoading extends NewsState {}
class NewsLoaded extends NewsState {
  final List<NewsEntry> news;
  const NewsLoaded(this.news);
  @override
  List<Object> get props => [news];
}
class NewsError extends NewsState {
  final String message;
  const NewsError(this.message);
  @override
  List<Object> get props => [message];
}

// --- BLoC ---
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetLatestNews getLatestNews;
  final SearchNews searchNews;

  NewsBloc({
    required this.getLatestNews,
    required this.searchNews,
  }) : super(NewsInitial()) {
    on<FetchLatestNewsEvent>((event, emit) async {
      emit(NewsLoading());
      try {
        final news = await getLatestNews(NoParams());
        emit(NewsLoaded(news));
      } catch (e) {
        emit(const NewsError('Failed to fetch news.'));
      }
    });

    on<SearchNewsEvent>((event, emit) async {
      emit(NewsLoading());
      try {
        final news = await searchNews(event.query);
        emit(NewsLoaded(news));
      } catch (e) {
        emit(const NewsError('Search failed.'));
      }
    });
  }
}
