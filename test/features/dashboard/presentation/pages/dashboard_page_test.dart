import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fbla_engagement/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fbla_engagement/features/news_feed/presentation/bloc/news_bloc.dart';
import 'package:fbla_engagement/features/event_calendar/presentation/bloc/event_bloc.dart';
import 'package:fbla_engagement/features/resources/presentation/bloc/resource_bloc.dart';
import 'package:fbla_engagement/features/social/presentation/bloc/social_bloc.dart';
import 'package:fbla_engagement/features/member_profile/presentation/pages/member_profile_page.dart';
import 'package:fbla_engagement/injection_container.dart' as di;
import 'package:get_it/get_it.dart';

void main() {
  setUp(() async {
    // Reset and initialize dependencies for each test
    await GetIt.instance.reset();
    await di.init();
  });

  /// Groups related to the "End-to-End" dashboard and navigation flow.
  group('Dashboard and Newsfeed Integration Tests', () {

    Widget createWidgetUnderTest() {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => di.sl<NewsBloc>()..add(FetchLatestNewsEvent()),
          ),
          BlocProvider(
            create: (_) => di.sl<EventBloc>()..add(FetchEventsEvent()),
          ),
          BlocProvider(
            create: (_) => di.sl<ResourceBloc>()..add(FetchResourcesEvent()),
          ),
          BlocProvider(
            create: (_) => di.sl<SocialBloc>()..add(FetchSocialFeedEvent()),
          ),
        ],
        child: const MaterialApp(
          home: DashboardPage(),
        ),
      );
    }

    testWidgets('UseCase: Immediate News Display', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Wait for initial loading (mock delay)
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      // Assert: Check for titles from MockNewsRemoteDataSource
      expect(find.text('FBLA National Leadership Conference 2026'), findsOneWidget);
      expect(find.text('Spring Chapter Awards Announced'), findsOneWidget);
    });

    testWidgets('UseCase: Search Functionality', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // 1. Find search field (should be the second TextField after category dropdown)
      final searchFields = find.byType(TextField);
      expect(searchFields, findsWidgets);
      final searchField = searchFields.at(1); // Second TextField is the search
      
      // 2. Enter text into search bar
      await tester.enterText(searchField, 'Leadership');
      
      // Wait for search delay
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // 3. Assert: Check if filtering worked (only Leadership article should show)
      expect(find.text('FBLA National Leadership Conference 2026'), findsOneWidget);
      expect(find.text('Spring Chapter Awards Announced'), findsNothing);
      
      // 4. Assert: Clear button (X) appears when text is entered
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('Feature: Category Dropdown in News Feed', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // 1. Navigate to News tab (should already be there, but ensure)
      // News tab is index 1, which is the default
      
      // 2. Assert: Category dropdown exists
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('All Categories'), findsOneWidget);
      
      // 3. Verify dropdown has all expected categories
      await tester.tap(find.text('All Categories'));
      await tester.pumpAndSettle();
      
      expect(find.text('All Categories'), findsWidgets);
      expect(find.text('National Center News'), findsWidgets);
      expect(find.text('Chapter Spotlight'), findsWidgets);
      expect(find.text('State Spotlight'), findsWidgets);
      expect(find.text('Alumni Spotlight'), findsWidgets);
    });

    testWidgets('UseCase: Tab and Profile Navigation', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // 1. Test Bottom Tab Navigation (Switch to Events)
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();
      // Should find the filter bar text
      expect(find.text('National'), findsWidgets); 

      // 2. Test Profile Navigation (Top Right Icon)
      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle();

      // Assert: We are now on the Member Profile Page
      expect(find.byType(MemberProfilePage), findsOneWidget);
      expect(find.text('My FBLA Profile'), findsOneWidget);

      // 3. Test Back Navigation
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Assert: Back on Dashboard
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('UseCase: Help Dialog Instructions', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // 1. Tap help icon
      await tester.tap(find.byIcon(Icons.help_outline));
      await tester.pumpAndSettle();

      // 2. Assert: Help dialog appears with instructions
      expect(find.text('Welcome to FBLA Engagement'), findsOneWidget);
      expect(find.textContaining('Events: Stay updated'), findsOneWidget);
      expect(find.textContaining('News: Real-time updates'), findsOneWidget);
      expect(find.textContaining('Resources: Access guidelines'), findsOneWidget);
      expect(find.textContaining('Social: Share your engagement'), findsOneWidget);
      expect(find.text('Got it!'), findsOneWidget);

      // 3. Dismiss dialog
      await tester.tap(find.text('Got it!'));
      await tester.pumpAndSettle();

      // 4. Assert: Dialog is dismissed
      expect(find.text('Welcome to FBLA Engagement'), findsNothing);
    });
  });
}
