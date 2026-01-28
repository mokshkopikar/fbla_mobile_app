import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fbla_engagement/features/news_feed/presentation/widgets/news_feed_tab.dart';
import 'package:fbla_engagement/features/news_feed/presentation/bloc/news_bloc.dart';
import 'package:fbla_engagement/injection_container.dart' as di;
import 'package:get_it/get_it.dart';

void main() {
  setUp(() async {
    // Reset and initialize dependencies for each test
    await GetIt.instance.reset();
    await di.init();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<NewsBloc>()..add(FetchLatestNewsEvent()),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: NewsFeedTab(),
        ),
      ),
    );
  }

  group('News Feed Tab - New Features Tests', () {
    testWidgets('Feature: Category Dropdown Filter', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Wait for initial loading
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      // 1. Verify category dropdown exists
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('All Categories'), findsOneWidget);

      // 2. Tap dropdown to open it
      await tester.tap(find.text('All Categories'));
      await tester.pumpAndSettle();

      // 3. Select "National Center News" category
      await tester.tap(find.text('National Center News').last);
      await tester.pumpAndSettle();

      // 4. Assert: Only National Center News articles are shown
      expect(find.text('FBLA National Leadership Conference 2026'), findsOneWidget);
      expect(find.text('New Member Engagement Tool Released'), findsOneWidget);
      // Chapter Spotlight article should not be visible
      expect(find.text('Spring Chapter Awards Announced'), findsNothing);
    });

    testWidgets('Feature: Category Filter - Chapter Spotlight', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      // 1. Select "Chapter Spotlight" category
      await tester.tap(find.text('All Categories'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chapter Spotlight').last);
      await tester.pumpAndSettle();

      // 2. Assert: Only Chapter Spotlight articles are shown
      expect(find.text('Spring Chapter Awards Announced'), findsOneWidget);
      // National Center News articles should not be visible
      expect(find.text('FBLA National Leadership Conference 2026'), findsNothing);
    });

    testWidgets('Feature: Clear Button (X) in Search Bar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      // 1. Find search field and enter text
      final searchFields = find.byType(TextField);
      expect(searchFields, findsWidgets);
      
      // Get the search TextField (should be the second one after category dropdown)
      final searchField = searchFields.at(1);
      await tester.enterText(searchField, 'Leadership');
      await tester.pumpAndSettle();

      // 2. Assert: Clear button (X icon) appears when text is entered
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // 3. Tap the clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // 4. Assert: Search field is cleared and all news are shown again
      expect(find.text('FBLA National Leadership Conference 2026'), findsOneWidget);
      expect(find.text('Spring Chapter Awards Announced'), findsOneWidget);
      expect(find.text('New Member Engagement Tool Released'), findsOneWidget);
      
      // 5. Assert: Clear button is no longer visible
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('Feature: Search and Category Filter Interaction', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      // 1. Select a category first
      await tester.tap(find.text('All Categories'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('National Center News').last);
      await tester.pumpAndSettle();

      // 2. Enter search query
      final searchFields = find.byType(TextField);
      final searchField = searchFields.at(1);
      await tester.enterText(searchField, 'Leadership');
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // 3. Assert: Search works on filtered category results
      expect(find.text('FBLA National Leadership Conference 2026'), findsOneWidget);
      
      // 4. Change category - should clear search
      await tester.tap(find.text('National Center News'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chapter Spotlight').last);
      await tester.pumpAndSettle();

      // 5. Assert: Search field is cleared and new category is shown
      expect(find.text('Spring Chapter Awards Announced'), findsOneWidget);
    });

    testWidgets('Feature: Category Filter Resets to All Categories', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      
      await tester.pump(const Duration(milliseconds: 800));
      await tester.pumpAndSettle();

      // 1. Select a specific category
      await tester.tap(find.text('All Categories'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('State Spotlight').last);
      await tester.pumpAndSettle();

      // 2. Clear search (which should reset category too)
      final searchFields = find.byType(TextField);
      final searchField = searchFields.at(1);
      await tester.enterText(searchField, 'test');
      await tester.pumpAndSettle();
      
      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      // 3. Assert: Category is reset to "All Categories" and all news shown
      expect(find.text('All Categories'), findsOneWidget);
      expect(find.text('FBLA National Leadership Conference 2026'), findsOneWidget);
      expect(find.text('Spring Chapter Awards Announced'), findsOneWidget);
    });
  });
}
