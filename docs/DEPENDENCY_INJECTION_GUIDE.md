# Dependency Injection Guide: Understanding `get_it` and Service Locator Pattern

This guide explains **Dependency Injection** and how your app uses the **Service Locator pattern** with the `get_it` package (mentioned in README line 39).

---

## 🤔 What is Dependency Injection?

**Dependency Injection (DI)** is a design pattern where objects receive their dependencies from outside, rather than creating them internally.

### The Problem (Without DI):

```dart
// ❌ BAD: NewsBloc creates its own dependencies
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetLatestNews getLatestNews;
  final SearchNews searchNews;
  
  NewsBloc() {
    // Creating dependencies inside the class - BAD!
    final repository = NewsRepositoryImpl(
      remoteDataSource: MockNewsRemoteDataSource()
    );
    getLatestNews = GetLatestNews(repository);
    searchNews = SearchNews(repository);
  }
}
```

**Problems:**
- ❌ Hard to test (can't inject mocks)
- ❌ Tightly coupled (NewsBloc knows about implementation details)
- ❌ Not flexible (can't swap implementations)

### The Solution (With DI):

```dart
// ✅ GOOD: Dependencies are injected from outside
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetLatestNews getLatestNews;
  final SearchNews searchNews;
  
  // Dependencies come from outside - GOOD!
  NewsBloc({
    required this.getLatestNews,
    required this.searchNews,
  }) : super(NewsInitial());
}
```

**Benefits:**
- ✅ Easy to test (can inject mock dependencies)
- ✅ Loosely coupled (doesn't know about implementations)
- ✅ Flexible (can swap implementations easily)

---

## 🏪 Service Locator Pattern with `get_it`

**Service Locator** is a type of Dependency Injection where you have a central registry (like a "phone book") that stores and provides dependencies.

### How `get_it` Works:

1. **Register** dependencies in a central location
2. **Retrieve** dependencies when needed using `sl<Type>()`
3. **Resolve** dependencies automatically (injects nested dependencies)

### Your App's Setup:

#### Step 1: Create the Service Locator

```dart
// lib/injection_container.dart
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;  // "sl" = Service Locator
```

#### Step 2: Register Dependencies

```dart
Future<void> init() async {
  // Register in REVERSE order of dependencies:
  // 1. Register data sources first (lowest level)
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => MockNewsRemoteDataSource(),
  );
  
  // 2. Register repositories (depend on data sources)
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),  // ← Gets from service locator
  );
  
  // 3. Register use cases (depend on repositories)
  sl.registerFactory(() => GetLatestNews(sl()));  // ← Gets repository from sl
  sl.registerFactory(() => SearchNews(sl()));
  
  // 4. Register BLoCs (depend on use cases)
  sl.registerFactory(
    () => NewsBloc(
      getLatestNews: sl(),  // ← Gets use case from sl
      searchNews: sl(),     // ← Gets use case from sl
    ),
  );
}
```

#### Step 3: Use Dependencies

```dart
// lib/main.dart
void main() async {
  await di.init();  // Initialize service locator
  
  runApp(const FBLAApp());
}

class FBLAApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // Get NewsBloc from service locator
          create: (_) => di.sl<NewsBloc>()..add(FetchLatestNewsEvent()),
        ),
      ],
      child: MaterialApp(...),
    );
  }
}
```

---

## 🔍 Real Example: News Feature Dependency Chain

Let's trace how dependencies are wired together:

### The Dependency Chain:

```
NewsBloc
  ├── GetLatestNews (use case)
  │     └── NewsRepository (interface)
  │           └── NewsRepositoryImpl (implementation)
  │                 └── NewsRemoteDataSource (interface)
  │                       └── MockNewsRemoteDataSource (implementation)
  │
  └── SearchNews (use case)
        └── NewsRepository (same as above)
```

### Registration Order (Bottom to Top):

```dart
// 1. Data Source (no dependencies)
sl.registerLazySingleton<NewsRemoteDataSource>(
  () => MockNewsRemoteDataSource(),  // Just creates the class
);

// 2. Repository (depends on data source)
sl.registerLazySingleton<NewsRepository>(
  () => NewsRepositoryImpl(
    remoteDataSource: sl(),  // ← Gets MockNewsRemoteDataSource from sl
  ),
);

// 3. Use Cases (depend on repository)
sl.registerFactory(() => GetLatestNews(sl()));  // ← Gets NewsRepositoryImpl
sl.registerFactory(() => SearchNews(sl()));     // ← Gets NewsRepositoryImpl

// 4. BLoC (depends on use cases)
sl.registerFactory(
  () => NewsBloc(
    getLatestNews: sl(),  // ← Gets GetLatestNews instance
    searchNews: sl(),     // ← Gets SearchNews instance
  ),
);
```

### How `sl()` Resolves Dependencies:

When you call `sl<NewsBloc>()`:

1. Service locator sees `NewsBloc` needs `GetLatestNews` and `SearchNews`
2. It calls `sl<GetLatestNews>()` and `sl<SearchNews>()`
3. Those need `NewsRepository`, so it calls `sl<NewsRepository>()`
4. That needs `NewsRemoteDataSource`, so it calls `sl<NewsRemoteDataSource>()`
5. `MockNewsRemoteDataSource` has no dependencies, so it's created
6. Works backwards: Repository → Use Cases → BLoC
7. Returns fully constructed `NewsBloc` with all dependencies!

---

## 📝 Registration Types: `registerFactory` vs `registerLazySingleton`

### `registerFactory` - New Instance Every Time

```dart
sl.registerFactory(() => NewsBloc(...));
```

- Creates a **new instance** every time you call `sl<NewsBloc>()`
- Used for: BLoCs, Use Cases (stateless, can have multiple instances)

**Example:**
```dart
final bloc1 = sl<NewsBloc>();  // New instance
final bloc2 = sl<NewsBloc>();  // Different instance
// bloc1 != bloc2
```

### `registerLazySingleton` - Single Shared Instance

```dart
sl.registerLazySingleton<NewsRepository>(
  () => NewsRepositoryImpl(...),
);
```

- Creates **one instance** and reuses it
- Created **lazily** (only when first accessed)
- Used for: Repositories, Data Sources (shared state, expensive to create)

**Example:**
```dart
final repo1 = sl<NewsRepository>();  // Creates instance
final repo2 = sl<NewsRepository>();  // Returns same instance
// repo1 == repo2 (same object)
```

---

## 🧪 Why Dependency Injection? Testing Example

The **biggest benefit** is **testability**. Here's why:

### Without DI (Hard to Test):

```dart
// ❌ Can't test NewsBloc in isolation
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() {
    // Hard-coded dependency - can't replace with mock!
    final repository = NewsRepositoryImpl(
      remoteDataSource: MockNewsRemoteDataSource()
    );
    getLatestNews = GetLatestNews(repository);
  }
}

// Test would need real data source - not isolated!
test('should load news', () {
  final bloc = NewsBloc();  // Uses real MockNewsRemoteDataSource
  // Can't control what data it returns
});
```

### With DI (Easy to Test):

```dart
// ✅ Can inject mock dependencies
test('should load news', () {
  // Create a mock repository
  final mockRepository = MockNewsRepository();
  when(mockRepository.getLatestNews()).thenAnswer(
    (_) async => [NewsEntry(...)],
  );
  
  // Inject mock into BLoC
  final bloc = NewsBloc(
    getLatestNews: GetLatestNews(mockRepository),
    searchNews: SearchNews(mockRepository),
  );
  
  // Test in isolation - no real data source needed!
  bloc.add(FetchLatestNewsEvent());
  expect(bloc.state, isA<NewsLoaded>());
});
```

**Your test file does this:**
```dart
// test/demo_script_integration_test.dart
setUp(() async {
  await GetIt.instance.reset();  // Clear previous registrations
  await di.init();  // Register all dependencies
});

// Now you can get BLoCs with all dependencies wired
final bloc = di.sl<NewsBloc>();
```

---

## 🔄 Complete Flow: From Registration to Usage

### 1. App Starts (`main.dart`)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();  // ← Registers ALL dependencies
  runApp(const FBLAApp());
}
```

### 2. Dependencies Registered (`injection_container.dart`)

```dart
Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => MockNewsRemoteDataSource(),
  );
  
  // Repositories
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),
  );
  
  // Use cases
  sl.registerFactory(() => GetLatestNews(sl()));
  sl.registerFactory(() => SearchNews(sl()));
  
  // BLoCs
  sl.registerFactory(
    () => NewsBloc(
      getLatestNews: sl(),
      searchNews: sl(),
    ),
  );
}
```

### 3. Widget Requests BLoC (`main.dart`)

```dart
BlocProvider(
  create: (_) => di.sl<NewsBloc>()..add(FetchLatestNewsEvent()),
)
```

### 4. Service Locator Resolves Dependencies

```
sl<NewsBloc>()
  ↓
  Needs: GetLatestNews, SearchNews
  ↓
  sl<GetLatestNews>()
    ↓
    Needs: NewsRepository
    ↓
    sl<NewsRepository>()
      ↓
      Needs: NewsRemoteDataSource
      ↓
      sl<NewsRemoteDataSource>()
        ↓
        Returns: MockNewsRemoteDataSource()
      ↓
    Returns: NewsRepositoryImpl(remoteDataSource: MockNewsRemoteDataSource())
  ↓
  Returns: GetLatestNews(repository: NewsRepositoryImpl(...))
  ↓
Returns: NewsBloc(getLatestNews: GetLatestNews(...), searchNews: SearchNews(...))
```

### 5. BLoC is Ready to Use

```dart
// In your widget
context.read<NewsBloc>().add(SearchNewsEvent("Leadership"));
```

---

## 🎯 Key Benefits Summary

### 1. **Testability** ✅
- Can inject mock dependencies
- Test business logic in isolation
- No need for real data sources in tests

### 2. **Flexibility** ✅
- Swap implementations easily (mock → real API)
- Change data sources without changing business logic
- Example: Replace `MockNewsRemoteDataSource` with `RealNewsRemoteDataSource`

### 3. **Separation of Concerns** ✅
- Classes don't know how dependencies are created
- Business logic is independent of data sources
- Follows Clean Architecture principles

### 4. **Single Responsibility** ✅
- Each class has one job
- Dependency creation is centralized in `injection_container.dart`
- Easy to see all dependencies in one place

---

## 📚 Your App's Dependency Graph

Here's a visual representation of your app's dependencies:

```
main.dart
  └── di.init()
      └── Registers:
          ├── SharedPreferences (external)
          │
          ├── News Feature:
          │   ├── MockNewsRemoteDataSource
          │   ├── NewsRepositoryImpl → MockNewsRemoteDataSource
          │   ├── GetLatestNews → NewsRepositoryImpl
          │   ├── SearchNews → NewsRepositoryImpl
          │   └── NewsBloc → GetLatestNews, SearchNews
          │
          ├── Event Calendar Feature:
          │   ├── MockEventDataSource
          │   ├── EventRepositoryImpl → MockEventDataSource
          │   └── EventBloc → EventRepositoryImpl
          │
          ├── Resources Feature:
          │   ├── MockResourceRemoteDataSource
          │   ├── ResourceRepositoryImpl → MockResourceRemoteDataSource
          │   └── ResourceBloc → ResourceRepositoryImpl
          │
          ├── Social Feature:
          │   ├── MockSocialRemoteDataSource
          │   ├── SocialRepositoryImpl → MockSocialRemoteDataSource
          │   └── SocialBloc → SocialRepositoryImpl
          │
          └── Member Profile Feature:
              ├── MemberLocalDataSourceImpl → SharedPreferences
              ├── MemberRepositoryImpl → MemberLocalDataSourceImpl
              ├── GetProfile → MemberRepositoryImpl
              ├── UpdateProfile → MemberRepositoryImpl
              └── MemberProfileBloc → GetProfile, UpdateProfile
```

---

## 🛠️ Common Patterns in Your Code

### Pattern 1: Factory for Stateless Classes

```dart
// Use cases are stateless - create new instance each time
sl.registerFactory(() => GetLatestNews(sl()));
```

### Pattern 2: Lazy Singleton for Shared State

```dart
// Repository is shared - one instance for entire app
sl.registerLazySingleton<NewsRepository>(
  () => NewsRepositoryImpl(remoteDataSource: sl()),
);
```

### Pattern 3: External Dependencies

```dart
// SharedPreferences needs async initialization
final sharedPreferences = await SharedPreferences.getInstance();
sl.registerLazySingleton(() => sharedPreferences);
```

---

## 🎓 Summary

**Dependency Injection** = Dependencies come from outside, not created inside

**Service Locator** = Central registry that stores and provides dependencies

**`get_it`** = Package that implements Service Locator pattern

**Benefits:**
- ✅ Testable (inject mocks)
- ✅ Flexible (swap implementations)
- ✅ Maintainable (centralized dependency management)
- ✅ Follows Clean Architecture

**Your App:**
- All dependencies registered in `lib/injection_container.dart`
- Retrieved using `di.sl<Type>()` in `main.dart` and widgets
- Enables easy testing and swapping of implementations

---

## 📖 Further Reading

- **Your Code**: See `lib/injection_container.dart` for all registrations
- **Usage**: See `lib/main.dart` for how BLoCs are retrieved
- **Tests**: See `test/demo_script_integration_test.dart` for DI in testing

---

**Next Steps**: Try modifying `injection_container.dart` to swap a mock data source with a real one - you'll see how easy it is with DI! 🚀
