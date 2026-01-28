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
import 'features/news_feed/data/datasources/news_local_data_source.dart';
import 'features/news_feed/data/repositories/news_repository_impl.dart';
import 'features/news_feed/domain/repositories/news_repository.dart';
import 'features/news_feed/domain/usecases/get_latest_news.dart';
import 'features/news_feed/domain/usecases/search_news.dart';
import 'features/news_feed/presentation/bloc/news_bloc.dart';
import 'features/event_calendar/data/datasources/event_data_source.dart';
import 'features/event_calendar/data/datasources/event_local_data_source.dart';
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
/// Initializes the dependency injection container for the entire application.
/// 
/// **Registration Order**: Dependencies are registered in reverse dependency order:
/// 1. External dependencies (SharedPreferences, etc.)
/// 2. Data sources (lowest level)
/// 3. Repositories (depend on data sources)
/// 4. Use cases (depend on repositories)
/// 5. BLoCs (depend on use cases)
/// 
/// **Registration Types**:
/// - `registerFactory`: Creates new instance each time (for BLoCs, use cases)
/// - `registerLazySingleton`: Creates one instance, reused (for repositories, data sources)
/// 
/// **Dependency Resolution**: When `sl<Type>()` is called, the service locator
/// automatically resolves all nested dependencies by calling `sl()` recursively.
Future<void> init() async {
  // ============================================================================
  // FEATURE: Member Profile
  // ============================================================================
  
  // BLoC - State management for member profile feature
  // Factory: New instance created each time (stateless, can have multiple instances)
  sl.registerFactory(
    () => MemberProfileBloc(
      getProfileUseCase: sl(),      // Resolves GetProfile use case
      updateProfileUseCase: sl(),   // Resolves UpdateProfile use case
    ),
  );

  // Use Cases - Business logic operations
  // Factory: New instance created each time (stateless)
  sl.registerFactory(() => GetProfile(sl()));      // Resolves MemberRepository
  sl.registerFactory(() => UpdateProfile(sl()));   // Resolves MemberRepository

  // Repository - Data access abstraction layer
  // Lazy Singleton: One instance created and reused (shared state, expensive to create)
  sl.registerLazySingleton<MemberRepository>(
    () => MemberRepositoryImpl(dataSource: sl()),  // Resolves MemberDataSource
  );

  // Data Source - Low-level data operations (local storage)
  // Lazy Singleton: One instance created and reused (shared SharedPreferences)
  sl.registerLazySingleton<MemberDataSource>(
    () => MemberLocalDataSourceImpl(sharedPreferences: sl()),  // Resolves SharedPreferences
  );

  // ============================================================================
  // FEATURE: News Feed
  // ============================================================================
  
  // BLoC - State management for news feed feature
  sl.registerFactory(
    () => NewsBloc(
      getLatestNews: sl(),    // Resolves GetLatestNews use case
      searchNews: sl(),       // Resolves SearchNews use case
    ),
  );

  // Use Cases - Business logic operations
  sl.registerFactory(() => GetLatestNews(sl()));   // Resolves NewsRepository
  sl.registerFactory(() => SearchNews(sl()));      // Resolves NewsRepository

  // Repository - Data access abstraction layer
  // Now uses both remote and local data sources for cache-first strategy
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),  // Resolves NewsRemoteDataSource
      localDataSource: sl(),   // Resolves NewsLocalDataSource
    ),
  );

  // Remote Data Source - Mock implementation for standalone demo
  // Uses mock data to ensure app works offline (FBLA competition requirement)
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => MockNewsRemoteDataSource(),
  );

  // Local Data Source - Caching implementation for offline access
  // Stores news articles locally for fast, offline access
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sharedPreferences: sl()),  // Resolves SharedPreferences
  );

  // ============================================================================
  // FEATURE: Event Calendar
  // ============================================================================
  
  // BLoC - State management for event calendar feature
  sl.registerFactory(
    () => EventBloc(repository: sl()),  // Resolves EventRepository
  );

  // Repository - Data access abstraction layer
  // Now uses both remote and local data sources for cache-first strategy
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(
      remoteDataSource: sl(),  // Resolves EventDataSource
      localDataSource: sl(),   // Resolves EventLocalDataSource
    ),
  );

  // Remote Data Source - Mock implementation for standalone demo
  sl.registerLazySingleton<EventDataSource>(
    () => MockEventDataSourceImpl(),
  );

  // Local Data Source - Caching implementation for offline access
  // Stores events locally for fast, offline access
  sl.registerLazySingleton<EventLocalDataSource>(
    () => EventLocalDataSourceImpl(sharedPreferences: sl()),  // Resolves SharedPreferences
  );

  // ============================================================================
  // FEATURE: Resources
  // ============================================================================

  // BLoC - State management for resources feature
  sl.registerFactory(() => ResourceBloc(repository: sl()));  // Resolves ResourceRepository

  // Repository - Data access abstraction layer
  sl.registerLazySingleton<ResourceRepository>(
    () => ResourceRepositoryImpl(remoteDataSource: sl()),  // Resolves ResourceRemoteDataSource
  );

  // Data Source - Mock implementation for standalone demo
  sl.registerLazySingleton<ResourceRemoteDataSource>(
    () => MockResourceRemoteDataSource(),
  );

  // ============================================================================
  // FEATURE: Social Feed
  // ============================================================================

  // BLoC - State management for social feed feature
  sl.registerFactory(() => SocialBloc(repository: sl()));  // Resolves SocialRepository

  // Repository - Data access abstraction layer
  sl.registerLazySingleton<SocialRepository>(
    () => SocialRepositoryImpl(remoteDataSource: sl()),  // Resolves SocialRemoteDataSource
  );

  // Data Source - Mock implementation for standalone demo
  sl.registerLazySingleton<SocialRemoteDataSource>(
    () => MockSocialRemoteDataSource(),
  );

  // ============================================================================
  // CORE DEPENDENCIES
  // ============================================================================
  // Shared dependencies used across multiple features
  
  // ============================================================================
  // EXTERNAL DEPENDENCIES
  // ============================================================================
  // Third-party services and platform APIs
  
  // SharedPreferences - Platform-agnostic key-value storage
  // Used for local data persistence (member profile, app settings, etc.)
  // Lazy Singleton: One instance shared across entire app
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
