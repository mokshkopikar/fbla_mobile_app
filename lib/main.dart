import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/dashboard/presentation/pages/dashboard_page.dart';
import 'features/news_feed/presentation/bloc/news_bloc.dart';
import 'features/event_calendar/presentation/bloc/event_bloc.dart';
import 'features/resources/presentation/bloc/resource_bloc.dart';
import 'features/social/presentation/bloc/social_bloc.dart';

/// The entry point of the FBLA Member Engagement application.
/// 
/// This application is designed for the FBLA 2025-2026 Mobile Application Development competition.
/// It follows the Feature-First Clean Architecture pattern to ensure high maintainability,
/// scalability, and testability.
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const FBLAApp());
}

/// The root widget of the application.
/// 
/// Responsibility: Configures the global theme, routing, and localization.
class FBLAApp extends StatelessWidget {
  /// Const constructor for performance optimization.
  const FBLAApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider makes BLoCs available to all child widgets
    // Each BLoC is retrieved from the dependency injection container
    // and initialized with an initial event to load data on app start
    return MultiBlocProvider(
      providers: [
        // News Feed BLoC - provides news articles and search functionality
        BlocProvider(
          create: (_) => di.sl<NewsBloc>()..add(FetchLatestNewsEvent()),
        ),
        // Event Calendar BLoC - provides FBLA events and filtering
        BlocProvider(
          create: (_) => di.sl<EventBloc>()..add(FetchEventsEvent()),
        ),
        // Resources BLoC - provides FBLA resources and search
        BlocProvider(
          create: (_) => di.sl<ResourceBloc>()..add(FetchResourcesEvent()),
        ),
        // Social Feed BLoC - provides social media posts
        BlocProvider(
          create: (_) => di.sl<SocialBloc>()..add(FetchSocialFeedEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'FBLA Future Engagement',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          // Accessibility: High contrast and flexible text scaling
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16),
          ),
          // Ensure minimum touch target sizes (44x44pt)
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // High contrast color scheme for accessibility (WCAG AA compliant)
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF003366), // FBLA Blue
            onPrimary: Colors.white,
            secondary: Color(0xFFD4AF37), // FBLA Gold accent
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF003366),
            brightness: Brightness.light,
          ),
        ),
        // Set the initial home page to the Dashboard
        home: const DashboardPage(),
      ),
    );
  }
}
