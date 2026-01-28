# Cross-Platform Architecture Patterns: BLoC, DI, and More

This guide explains how architecture patterns (BLoC, Dependency Injection, Clean Architecture) translate when using **separate codebases** (React web + Flutter mobile).

---

## 🎯 Quick Answer

**BLoC**: Flutter-specific (mobile only)  
**Dependency Injection**: Universal (both web and mobile, different implementations)  
**Clean Architecture**: Universal (same principles, different frameworks)

---

## 📱 Mobile (Flutter) - Your Current Stack

### State Management: BLoC Pattern

```dart
// lib/features/news_feed/presentation/bloc/news_bloc.dart
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetLatestNews getLatestNews;
  
  NewsBloc({required this.getLatestNews}) : super(NewsInitial()) {
    on<FetchLatestNewsEvent>((event, emit) async {
      emit(NewsLoading());
      final news = await getLatestNews(NoParams());
      emit(NewsLoaded(news));
    });
  }
}
```

**Why BLoC in Flutter:**
- ✅ Flutter-specific pattern
- ✅ Reactive state management
- ✅ Testable and predictable
- ✅ Works great with Flutter widgets

### Dependency Injection: `get_it` (Service Locator)

```dart
// lib/injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => NewsBloc(getLatestNews: sl()));
  sl.registerFactory(() => GetLatestNews(sl()));
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(remoteDataSource: sl()),
  );
}

// Usage
final bloc = di.sl<NewsBloc>();
```

**Why `get_it` in Flutter:**
- ✅ Simple service locator
- ✅ Works well with Flutter
- ✅ Easy to use
- ✅ Good for dependency resolution

---

## 🌐 Web (React) - Equivalent Patterns

### State Management: Redux / Zustand / Context API

**React doesn't use BLoC** - it has its own patterns:

#### Option 1: Redux (Most Similar to BLoC)

```typescript
// Similar to BLoC: Actions → Reducer → State
// web/src/store/news/newsSlice.ts
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

// Action (like Event in BLoC)
export const fetchNews = createAsyncThunk(
  'news/fetchNews',
  async () => {
    const response = await fetch('/api/news');
    return response.json();
  }
);

// State (like State in BLoC)
interface NewsState {
  news: NewsItem[];
  loading: boolean;
  error: string | null;
}

// Reducer (like BLoC handler)
const newsSlice = createSlice({
  name: 'news',
  initialState: { news: [], loading: false, error: null },
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchNews.pending, (state) => {
        state.loading = true;
      })
      .addCase(fetchNews.fulfilled, (state, action) => {
        state.loading = false;
        state.news = action.payload;
      })
      .addCase(fetchNews.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message;
      });
  },
});

export default newsSlice.reducer;
```

**Comparison:**
```
BLoC (Flutter)          →    Redux (React)
─────────────────────────────────────────────
Event                   →    Action
State                   →    State
BLoC handler            →    Reducer
BlocBuilder             →    useSelector
```

#### Option 2: Zustand (Simpler Alternative)

```typescript
// web/src/store/news/useNewsStore.ts
import { create } from 'zustand';

interface NewsState {
  news: NewsItem[];
  loading: boolean;
  fetchNews: () => Promise<void>;
}

export const useNewsStore = create<NewsState>((set) => ({
  news: [],
  loading: false,
  fetchNews: async () => {
    set({ loading: true });
    try {
      const response = await fetch('/api/news');
      const news = await response.json();
      set({ news, loading: false });
    } catch (error) {
      set({ loading: false });
    }
  },
}));

// Usage in component
function NewsFeed() {
  const { news, loading, fetchNews } = useNewsStore();
  // ...
}
```

#### Option 3: React Query + Context (Modern Approach)

```typescript
// web/src/hooks/useNews.ts
import { useQuery } from '@tanstack/react-query';

export function useNews() {
  return useQuery({
    queryKey: ['news'],
    queryFn: async () => {
      const response = await fetch('/api/news');
      return response.json();
    },
  });
}

// Usage
function NewsFeed() {
  const { data: news, isLoading } = useNews();
  // ...
}
```

### Dependency Injection: React Context / Dependency Injection Libraries

**React doesn't use `get_it`** - it has different approaches:

#### Option 1: React Context (Built-in)

```typescript
// web/src/context/NewsContext.tsx
import { createContext, useContext, ReactNode } from 'react';
import { NewsService } from '../services/newsService';

interface NewsContextType {
  newsService: NewsService;
}

const NewsContext = createContext<NewsContextType | null>(null);

export function NewsProvider({ children }: { children: ReactNode }) {
  // Dependency injection via Context
  const newsService = new NewsService();
  
  return (
    <NewsContext.Provider value={{ newsService }}>
      {children}
    </NewsContext.Provider>
  );
}

export function useNewsService() {
  const context = useContext(NewsContext);
  if (!context) throw new Error('Must be used within NewsProvider');
  return context.newsService;
}
```

#### Option 2: InversifyJS (Similar to `get_it`)

```typescript
// web/src/injection/container.ts
import { Container } from 'inversify';
import { NewsService } from '../services/newsService';
import { NewsRepository } from '../repositories/newsRepository';

const container = new Container();

// Register dependencies (like get_it)
container.bind<NewsRepository>('NewsRepository').to(NewsRepositoryImpl);
container.bind<NewsService>('NewsService').to(NewsService);

export { container };

// Usage
import { container } from './injection/container';
const newsService = container.get<NewsService>('NewsService');
```

#### Option 3: Dependency Injection via Props (Simple)

```typescript
// web/src/components/NewsFeed.tsx
interface NewsFeedProps {
  newsService: NewsService;  // Injected dependency
}

function NewsFeed({ newsService }: NewsFeedProps) {
  const [news, setNews] = useState([]);
  
  useEffect(() => {
    newsService.getLatest().then(setNews);
  }, [newsService]);
  
  // ...
}

// Usage
<NewsFeed newsService={new NewsService()} />
```

---

## 🏗️ Clean Architecture: Universal Pattern

**Clean Architecture principles apply to BOTH web and mobile**, just implemented differently:

### Mobile (Flutter) Structure

```
lib/features/news_feed/
├── domain/              # Business Logic (Pure Dart)
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/                # Data Layer
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/        # UI Layer
    ├── bloc/
    └── widgets/
```

### Web (React) Structure

```
web/src/features/news/
├── domain/              # Business Logic (TypeScript)
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/                # Data Layer
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/        # UI Layer
    ├── store/          # Redux/Zustand
    └── components/
```

**Same layers, different frameworks!**

---

## 🔄 Side-by-Side Comparison

### State Management

| Flutter (Mobile) | React (Web) | Purpose |
|------------------|-------------|---------|
| **BLoC** | **Redux** | Predictable state management |
| `BlocBuilder` | `useSelector` | Access state in UI |
| `Event` | `Action` | User actions |
| `State` | `State` | Current app state |
| `BlocProvider` | `Provider` | Provide state to tree |

### Dependency Injection

| Flutter (Mobile) | React (Web) | Purpose |
|------------------|-------------|---------|
| **`get_it`** | **InversifyJS / Context** | Service locator |
| `sl.registerFactory()` | `container.bind()` | Register dependencies |
| `sl<Type>()` | `container.get()` | Retrieve dependencies |
| `injection_container.dart` | `container.ts` | Centralized DI setup |

### Clean Architecture

| Layer | Flutter | React | Purpose |
|-------|---------|-------|---------|
| **Domain** | Pure Dart | TypeScript | Business logic |
| **Data** | Dart + HTTP | TypeScript + Fetch | Data fetching |
| **Presentation** | Flutter widgets | React components | UI |

---

## 💻 Complete Example: News Feature

### Mobile (Flutter) - Your Current Code

```dart
// Domain: Use Case
class GetLatestNews implements UseCase<List<NewsEntry>, NoParams> {
  final NewsRepository repository;
  GetLatestNews(this.repository);
  
  @override
  Future<List<NewsEntry>> call(NoParams params) async {
    return await repository.getLatestNews();
  }
}

// Presentation: BLoC
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetLatestNews getLatestNews;
  
  NewsBloc({required this.getLatestNews}) : super(NewsInitial()) {
    on<FetchLatestNewsEvent>((event, emit) async {
      emit(NewsLoading());
      final news = await getLatestNews(NoParams());
      emit(NewsLoaded(news));
    });
  }
}

// Dependency Injection
sl.registerFactory(() => NewsBloc(getLatestNews: sl()));
sl.registerFactory(() => GetLatestNews(sl()));
```

### Web (React) - Equivalent Code

```typescript
// Domain: Use Case (same logic!)
class GetLatestNews {
  constructor(private repository: NewsRepository) {}
  
  async execute(): Promise<NewsItem[]> {
    return await this.repository.getLatestNews();
  }
}

// Presentation: Redux Slice
const fetchNews = createAsyncThunk(
  'news/fetchNews',
  async (_, { extra }) => {
    const getLatestNews = extra.getLatestNews;  // Injected!
    return await getLatestNews.execute();
  }
);

// Dependency Injection (InversifyJS)
container.bind<NewsRepository>('NewsRepository').to(NewsRepositoryImpl);
container.bind<GetLatestNews>('GetLatestNews').to(GetLatestNews);
```

**Same business logic, different UI frameworks!**

---

## 🎯 Architecture Decision: What to Use?

### Mobile (Flutter) ✅

**State Management:**
- ✅ **BLoC** (your current choice) - Best for complex apps
- Alternative: Provider, Riverpod

**Dependency Injection:**
- ✅ **`get_it`** (your current choice) - Simple and effective
- Alternative: Injectable, Riverpod

**Architecture:**
- ✅ **Clean Architecture** (your current structure) - Industry standard

### Web (React) ✅

**State Management:**
- ✅ **Redux Toolkit** - Most similar to BLoC
- ✅ **Zustand** - Simpler alternative
- ✅ **React Query** - For server state
- ✅ **Context API** - For simple cases

**Dependency Injection:**
- ✅ **React Context** - Built-in, simple
- ✅ **InversifyJS** - Most similar to `get_it`
- ✅ **Props** - Simple dependency passing

**Architecture:**
- ✅ **Clean Architecture** - Same principles as Flutter

---

## 🔗 Shared Backend API

**Both web and mobile call the SAME backend:**

```python
# backend/api/news.py (Python/FastAPI)
@app.get("/api/news")
async def get_news():
    return await news_service.get_latest()
```

```dart
// Mobile (Flutter)
final response = await http.get(Uri.parse('https://api.example.com/news'));
```

```typescript
// Web (React)
const response = await fetch('/api/news');
const news = await response.json();
```

**Same API, different clients!**

---

## 📊 Architecture Comparison Table

| Aspect | Flutter (Mobile) | React (Web) | Shared? |
|--------|-----------------|-------------|---------|
| **State Management** | BLoC | Redux/Zustand | ❌ Different |
| **Dependency Injection** | `get_it` | InversifyJS/Context | ❌ Different |
| **Clean Architecture** | ✅ Yes | ✅ Yes | ✅ Same principles |
| **Domain Layer** | Dart | TypeScript | ✅ Same logic |
| **Data Layer** | Dart | TypeScript | ✅ Same API calls |
| **Backend API** | HTTP | HTTP | ✅ Same API |
| **Business Logic** | Use Cases | Use Cases | ✅ Same logic |

---

## 🎓 Key Takeaways

### 1. **BLoC is Flutter-Specific**
- ❌ Not used in React
- ✅ React uses Redux, Zustand, or Context API
- ✅ Same concepts (actions, state, reducers)

### 2. **Dependency Injection is Universal**
- ✅ Both Flutter and React use DI
- ✅ Different libraries (`get_it` vs InversifyJS)
- ✅ Same principles (inject dependencies, don't create inside)

### 3. **Clean Architecture is Universal**
- ✅ Same layers (Domain, Data, Presentation)
- ✅ Same principles (separation of concerns)
- ✅ Different implementations (Dart vs TypeScript)

### 4. **Backend is Shared**
- ✅ Same API for both web and mobile
- ✅ Same business logic
- ✅ Same data models

---

## 🚀 Recommended Stack for Separate Codebases

### Mobile (Flutter) - Your Current Stack ✅

```
State Management: BLoC
Dependency Injection: get_it
Architecture: Clean Architecture
Backend: Shared API
```

### Web (React) - Recommended Stack

```
State Management: Redux Toolkit (most similar to BLoC)
Dependency Injection: InversifyJS or React Context
Architecture: Clean Architecture (same as mobile)
Backend: Shared API (same as mobile)
```

---

## 💡 Best Practices

### 1. **Share Business Logic via Backend**
```python
# Backend contains all business logic
# Both web and mobile call same endpoints
```

### 2. **Use Similar Patterns**
```
Flutter BLoC ≈ React Redux
Flutter get_it ≈ React InversifyJS
```

### 3. **Same Clean Architecture**
```
Both use Domain → Data → Presentation layers
Same principles, different frameworks
```

### 4. **Shared API Contracts**
```typescript
// Shared types (TypeScript)
export interface NewsItem {
  id: string;
  title: string;
}
```

```dart
// Mobile models (Dart)
class NewsEntry {
  final String id;
  final String title;
}
```

---

## 📚 Summary

**If you go with Approach 1 (Separate Codebases):**

✅ **Mobile (Flutter):**
- Keep using **BLoC** (Flutter-specific)
- Keep using **`get_it`** (Flutter-specific)
- Keep **Clean Architecture** (universal)

✅ **Web (React):**
- Use **Redux** (equivalent to BLoC)
- Use **InversifyJS** or **Context** (equivalent to `get_it`)
- Use **Clean Architecture** (same principles)

✅ **Shared:**
- **Backend API** (same for both)
- **Business Logic** (in backend)
- **Architecture Principles** (Clean Architecture)

**Bottom Line:** BLoC and `get_it` are Flutter-specific, but the **principles** (state management, dependency injection, clean architecture) apply to both web and mobile with different implementations! 🚀
