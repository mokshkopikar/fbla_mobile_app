import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/member_profile/data/datasources/member_data_source.dart';
import 'features/member_profile/data/datasources/member_local_data_source.dart';
import 'features/member_profile/data/repositories/member_repository_impl.dart';
import 'features/member_profile/domain/repositories/member_repository.dart';
import 'features/member_profile/domain/usecases/get_profile.dart';
import 'features/member_profile/domain/usecases/update_profile.dart';
import 'features/member_profile/presentation/bloc/member_profile_bloc.dart';
import 'features/news_feed/data/datasources/news_remote_data_source.dart';
import 'features/news_feed/data/repositories/news_repository_impl.dart';
import 'features/news_feed/domain/repositories/news_repository.dart';
import 'features/news_feed/domain/usecases/get_latest_news.dart';
import 'features/news_feed/domain/usecases/search_news.dart';
import 'features/news_feed/presentation/bloc/news_bloc.dart';
import 'features/event_calendar/data/datasources/event_data_source.dart';
import 'features/event_calendar/data/repositories/event_repository_impl.dart';
import 'features/event_calendar/domain/repositories/event_repository.dart';
import 'features/event_calendar/presentation/bloc/event_bloc.dart';
import 'features/resources/data/datasources/mock_resource_remote_data_source.dart';
import 'features/resources/data/repositories/resource_repository_impl.dart';
import 'features/resources/domain/repositories/resource_repository.dart';
import 'features/resources/presentation/bloc/resource_bloc.dart';
import 'features/social/data/datasources/mock_social_remote_data_source.dart';
import 'features/social/data/repositories/social_repository_impl.dart';
import 'features/social/domain/repositories/social_repository.dart';
import 'features/social/presentation/bloc/social_bloc.dart';

/// The global service locator instance.
final sl = GetIt.instance;

/// Initializes the dependency injection container.
/// 
/// [Dependency Injection]: We use the Service Locator pattern to manage
/// dependencies. This makes the code highly testable by allowing us to
/// inject mock dependencies into our classes and ensures a "Separation of Concerns".
Future<void> init() async {
  //! Features - Member Profile
  
  // BLoC
  sl.registerFactory(
    () => MemberProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerFactory(() => GetProfile(sl()));
  sl.registerFactory(() => UpdateProfile(sl()));

  // Repository
  sl.registerLazySingleton<MemberRepository>(
    () => MemberRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<MemberDataSource>(
    () => MemberLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features - Newsfeed
  
  // BLoC
  sl.registerFactory(
    () => NewsBloc(
      getLatestNews: sl(),
      searchNews: sl(),
    ),
  );

  // UseCases
  sl.registerFactory(() => GetLatestNews(sl()));
  sl.registerFactory(() => SearchNews(sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => MockNewsRemoteDataSource(),
  );

  //! Features - Event Calendar
  
  // BLoC
  sl.registerFactory(
    () => EventBloc(repository: sl()),
  );

  // Repository
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<EventDataSource>(
    () => MockEventDataSourceImpl(),
  );

  //! Features - Resources

  // BLoC
  sl.registerFactory(() => ResourceBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<ResourceRepository>(
    () => ResourceRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ResourceRemoteDataSource>(
    () => MockResourceRemoteDataSource(),
  );

  //! Features - Social

  // BLoC
  sl.registerFactory(() => SocialBloc(repository: sl()));

  // Repository
  sl.registerLazySingleton<SocialRepository>(
    () => SocialRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<SocialRemoteDataSource>(
    () => MockSocialRemoteDataSource(),
  );

  //! Core
  // Place for shared external dependencies like SharedPreferences or Http Client
  
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
