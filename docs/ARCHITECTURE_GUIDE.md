# Architecture Guide: Understanding the FBLA Mobile App

This guide explains the architecture and design patterns used in this app, particularly focusing on the **BLoC Pattern** mentioned in the README.

## 📐 Overall Architecture: Clean Architecture (Feature-First)

The app uses **Clean Architecture** with a **Feature-First** structure. This means:

### Three Main Layers (per feature):

```
lib/features/news_feed/
├── domain/          # Business Logic (Pure Dart - no Flutter dependencies)
│   ├── entities/    # Core business objects (NewsEntry)
│   ├── repositories/ # Interfaces (contracts) for data access
│   └── usecases/    # Single-purpose business operations
├── data/            # Data Layer (How data is fetched/stored)
│   ├── datasources/ # Where data comes from (API, local DB, mocks)
│   ├── models/      # Data transfer objects (convert to/from entities)
│   └── repositories/ # Implementation of domain repositories
└── presentation/    # UI Layer (Flutter widgets)
    ├── bloc/        # State management (BLoC pattern)
    └── widgets/     # UI components
```

### Why This Structure?

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Testability**: You can test business logic without UI
3. **Flexibility**: Can swap data sources (mock → real API) without changing UI
4. **Scalability**: Easy to add new features following the same pattern

---

## 🎯 BLoC Pattern Explained (Line 37 in README)

**BLoC** stands for **Business Logic Component**. It's a state management pattern that separates UI from business logic.

### How BLoC Works:

```
User Action → Event → BLoC → State → UI Updates
```

### Example: News Feed Feature

Let's trace through how the News Feed works:

#### 1. **Event** (What the user wants to do)
```dart
// User types "Leadership" in search box
SearchNewsEvent("Leadership")
```

#### 2. **BLoC** (Business Logic Component)
```dart
// lib/features/news_feed/presentation/bloc/news_bloc.dart
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  // When SearchNewsEvent happens:
  on<SearchNewsEvent>((event, emit) async {
    emit(NewsLoading());  // Show loading spinner
    try {
      final news = await searchNews(event.query);  // Call use case
      emit(NewsLoaded(news));  // Show results
    } catch (e) {
      emit(NewsError('Search failed.'));  // Show error
    }
  });
}
```

#### 3. **State** (What the UI should display)
```dart
// Possible states:
- NewsInitial()      // Starting state
- NewsLoading()      // Loading spinner
- NewsLoaded([...])  // Show news list
- NewsError("...")   // Show error message
```

#### 4. **UI** (Widget that displays the state)
```dart
// lib/features/news_feed/presentation/widgets/news_feed_tab.dart
BlocBuilder<NewsBloc, NewsState>(
  builder: (context, state) {
    if (state is NewsLoading) {
      return CircularProgressIndicator();  // Show spinner
    } else if (state is NewsLoaded) {
      return ListView(...);  // Show news list
    } else if (state is NewsError) {
      return Text(state.message);  // Show error
    }
  }
)
```

### Why BLoC?

✅ **Separation**: UI doesn't know where data comes from  
✅ **Testable**: Can test business logic independently  
✅ **Predictable**: State changes are explicit and traceable  
✅ **Reactive**: UI automatically updates when state changes  

---

## 🔄 Complete Data Flow Example

Let's trace a complete user action: **Searching for "Leadership" in News**

### Step-by-Step Flow:

1. **User Action**: User types "Leadership" in search box
   ```dart
   // news_feed_tab.dart
   TextField(
     onChanged: (query) {
       context.read<NewsBloc>().add(SearchNewsEvent(query));
     }
   )
   ```

2. **Event Created**: `SearchNewsEvent("Leadership")` is dispatched

3. **BLoC Receives Event**: 
   ```dart
   // news_bloc.dart
   on<SearchNewsEvent>((event, emit) async {
     emit(NewsLoading());  // UI shows loading
     final news = await searchNews(event.query);  // Call use case
     emit(NewsLoaded(news));  // UI shows results
   })
   ```

4. **Use Case Executes**:
   ```dart
   // get_latest_news.dart (Use Case)
   Future<List<NewsEntry>> call(String query) async {
     return await repository.searchNews(query);
   }
   ```

5. **Repository Fetches Data**:
   ```dart
   // news_repository_impl.dart
   Future<List<NewsEntry>> searchNews(String query) async {
     final models = await remoteDataSource.searchNews(query);
     return models.map((model) => model.toEntity()).toList();
   }
   ```

6. **Data Source Returns Mock Data**:
   ```dart
   // mock_news_remote_data_source.dart
   Future<List<NewsModel>> searchNews(String query) async {
     return _mockNews.where((n) => 
       n.title.toLowerCase().contains(query.toLowerCase())
     ).toList();
   }
   ```

7. **State Emitted**: `NewsLoaded([filtered news])`

8. **UI Updates**: ListView shows filtered news articles

---

## 🏗️ Other Design Patterns

### Repository Pattern (Line 38)
**What it does**: Abstracts data sources from business logic

**Example**:
```dart
// Domain layer defines interface (contract)
abstract class NewsRepository {
  Future<List<NewsEntry>> getLatestNews();
  Future<List<NewsEntry>> searchNews(String query);
}

// Data layer implements it
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  
  @override
  Future<List<NewsEntry>> getLatestNews() async {
    // Can switch from mock to real API without changing business logic
    return await remoteDataSource.getLatestNews();
  }
}
```

**Why**: Can swap mock data → real API without changing UI or business logic

### Dependency Injection (Line 39)
**What it does**: Provides dependencies to classes instead of creating them inside

**Example**:
```dart
// injection_container.dart
sl.registerFactory(() => NewsBloc(
  getLatestNews: sl(),  // Dependency injected
  searchNews: sl(),     // Not created inside NewsBloc
));

// main.dart
BlocProvider(
  create: (_) => di.sl<NewsBloc>(),  // Get from service locator
)
```

**Why**: Makes code testable (can inject mocks) and flexible

### Clean Architecture (Line 40)
**What it does**: Separates code into layers with clear dependencies

**Dependency Rule**: Inner layers (domain) don't depend on outer layers (data, presentation)

```
Presentation → Domain ← Data
     ↓           ↑
     └───────────┘
```

**Why**: Business logic is independent and testable

---

## 📁 Feature Structure Deep Dive

### Example: News Feed Feature

```
lib/features/news_feed/
│
├── domain/                    # BUSINESS LOGIC (Pure Dart)
│   ├── entities/
│   │   └── news_entry.dart    # Core data structure
│   ├── repositories/
│   │   └── news_repository.dart # Interface (contract)
│   └── usecases/
│       ├── get_latest_news.dart    # Single-purpose operation
│       └── search_news.dart        # Single-purpose operation
│
├── data/                      # DATA LAYER
│   ├── datasources/
│   │   └── news_remote_data_source.dart  # Mock data source
│   ├── models/
│   │   └── news_model.dart   # Data transfer object
│   └── repositories/
│       └── news_repository_impl.dart  # Implements domain interface
│
└── presentation/              # UI LAYER
    ├── bloc/
    │   └── news_bloc.dart    # State management (BLoC)
    └── widgets/
        └── news_feed_tab.dart # UI component
```

### How They Connect:

1. **UI** (presentation) uses **BLoC** to get state
2. **BLoC** uses **Use Cases** to execute business logic
3. **Use Cases** use **Repository** interface (from domain)
4. **Repository Implementation** (in data) uses **Data Sources**
5. **Data Sources** return **Models**, which convert to **Entities**

---

## 🔍 Real Code Example: News Search

Let's look at actual code files:

### 1. Entity (Domain Layer)
```dart
// lib/features/news_feed/domain/entities/news_entry.dart
class NewsEntry {
  final String id;
  final String title;
  final String date;
  final String summary;
  final String link;
  
  // Pure data class - no dependencies
}
```

### 2. Use Case (Domain Layer)
```dart
// lib/features/news_feed/domain/usecases/search_news.dart
class SearchNews {
  final NewsRepository repository;
  
  Future<List<NewsEntry>> call(String query) async {
    return await repository.searchNews(query);
  }
}
```

### 3. Repository Implementation (Data Layer)
```dart
// lib/features/news_feed/data/repositories/news_repository_impl.dart
class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  
  @override
  Future<List<NewsEntry>> searchNews(String query) async {
    final models = await remoteDataSource.searchNews(query);
    return models.map((m) => m.toEntity()).toList();
  }
}
```

### 4. BLoC (Presentation Layer)
```dart
// lib/features/news_feed/presentation/bloc/news_bloc.dart
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final SearchNews searchNews;  // Use case injected
  
  on<SearchNewsEvent>((event, emit) async {
    emit(NewsLoading());
    final news = await searchNews(event.query);
    emit(NewsLoaded(news));
  });
}
```

### 5. UI Widget (Presentation Layer)
```dart
// lib/features/news_feed/presentation/widgets/news_feed_tab.dart
BlocBuilder<NewsBloc, NewsState>(
  builder: (context, state) {
    if (state is NewsLoaded) {
      return ListView.builder(
        itemCount: state.news.length,
        itemBuilder: (context, index) => NewsCard(state.news[index]),
      );
    }
  }
)
```

---

## 🎓 Key Concepts Summary

### BLoC Pattern (The Main One)
- **Events**: User actions (button tap, text input)
- **BLoC**: Processes events and emits states
- **States**: What the UI should display
- **Benefits**: Predictable, testable, reactive

### Clean Architecture
- **Domain**: Business logic (independent)
- **Data**: How data is fetched/stored
- **Presentation**: UI and state management
- **Benefits**: Testable, maintainable, scalable

### Dependency Injection
- **Service Locator**: `get_it` package
- **Benefits**: Testable (can inject mocks), flexible

### Repository Pattern
- **Interface**: Defined in domain layer
- **Implementation**: In data layer
- **Benefits**: Can swap data sources easily

---

## 🧪 Why This Architecture for Competition?

1. **Demonstrates Expertise**: Shows understanding of industry patterns
2. **Testable**: Easy to write tests (important for rubric)
3. **Maintainable**: Clear structure judges can follow
4. **Scalable**: Easy to add features
5. **Professional**: Matches real-world app architecture

---

## 📚 Further Reading

- **BLoC Pattern**: See any `*_bloc.dart` file in `lib/features/*/presentation/bloc/`
- **Repository Pattern**: See `*_repository.dart` and `*_repository_impl.dart`
- **Dependency Injection**: See `lib/injection_container.dart`
- **Clean Architecture**: See folder structure in `lib/features/`

---

**Next Steps**: Explore the code! Start with `lib/features/news_feed/` to see a complete example of all patterns working together.
