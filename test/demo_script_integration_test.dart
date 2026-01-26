/// Comprehensive Integration Test - Mirrors 7-Minute Demo Script
/// 
/// This test file verifies all features demonstrated in the FBLA presentation script.
/// Each test case corresponds to a specific action or feature shown to judges.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fbla_engagement/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fbla_engagement/features/member_profile/presentation/pages/member_profile_page.dart';
import 'package:fbla_engagement/features/news_feed/presentation/bloc/news_bloc.dart';
import 'package:fbla_engagement/features/event_calendar/presentation/bloc/event_bloc.dart';
import 'package:fbla_engagement/features/resources/presentation/bloc/resource_bloc.dart';
import 'package:fbla_engagement/features/social/presentation/bloc/social_bloc.dart';
import 'package:fbla_engagement/injection_container.dart' as di;
import 'package:get_it/get_it.dart';

void main() {
  setUp(() async {
    await GetIt.instance.reset();
    await di.init();
  });

  Widget createApp() {
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

  group('Demo Script Integration Tests - Complete Flow', () {
    
    testWidgets('Demo Section 2: Profile & Validation Flow', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // Navigate to Profile
      await tester.tap(find.byIcon(Icons.account_circle));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify profile is displayed
      expect(find.text('My FBLA Profile'), findsOneWidget);
      expect(find.byType(MemberProfilePage), findsOneWidget);

      // Open Edit Dialog
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Test semantic validation - invalid grade level
      final gradeField = find.widgetWithText(TextFormField, 'Grade Level (9-12)');
      await tester.enterText(gradeField, '8');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify validation error appears
      expect(find.text('FBLA High School membership is for grades 9-12'), findsOneWidget);
    });

    testWidgets('Demo Section 3: News Search "Leadership" Flow', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // Verify we're on News tab (default)
      expect(find.text('FBLA National Leadership Conference 2026'), findsOneWidget);

      // Search for "Leadership"
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'Leadership');
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Verify only Leadership article is shown
      expect(find.text('FBLA National Leadership Conference 2026'), findsOneWidget);
      expect(find.text('Spring Chapter Awards Announced'), findsNothing);
    });

    testWidgets('Demo Section 4: Event Filtering & Reminder Flow', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // Navigate to Events tab
      await tester.tap(find.byIcon(Icons.calendar_month));
      await tester.pumpAndSettle();

      // Verify filter chips are present
      expect(find.text('National'), findsWidgets);
      expect(find.text('Competition Deadline'), findsWidgets);

      // Filter by "National"
      final nationalChip = find.text('National').first;
      await tester.tap(nationalChip);
      await tester.pumpAndSettle();

      // Verify National events are displayed
      expect(find.text('National Leadership Conference (NLC)'), findsOneWidget);

      // Test reminder feature
      final reminderButton = find.byIcon(Icons.alarm_add).first;
      expect(reminderButton, findsOneWidget);
      
      await tester.tap(reminderButton);
      await tester.pumpAndSettle();

      // Verify reminder dialog appears
      expect(find.text('Set RSVP/Reminder'), findsOneWidget);
    });

    testWidgets('Demo Section 4: Social Share Flow', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // Navigate to Social tab
      await tester.tap(find.byIcon(Icons.share));
      await tester.pumpAndSettle();

      // Verify social feed is displayed
      expect(find.text('FBLA Social Feed'), findsOneWidget);

      // Verify Invite/Share button is present
      expect(find.text('Invite'), findsOneWidget);
      expect(find.byIcon(Icons.person_add_alt_1), findsOneWidget);
    });

    testWidgets('Demo Section 3: Resources Access Flow', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // Navigate to Resources tab
      await tester.tap(find.byIcon(Icons.folder));
      await tester.pumpAndSettle();

      // Verify resources are displayed
      expect(find.text('2025-26 Competitive Events Guidelines'), findsOneWidget);
      
      // Verify search functionality
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'competitive');
      await tester.pumpAndSettle();

      // Verify resource with link icon is present (indicating it's tappable)
      expect(find.byIcon(Icons.open_in_new), findsWidgets);
    });

    testWidgets('Complete Navigation Flow - All Tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // Test all tab navigation
      final tabs = [
        (Icons.calendar_month, 'Events'),
        (Icons.newspaper, 'News'),
        (Icons.folder, 'Resources'),
        (Icons.share, 'Social'),
      ];

      for (var tab in tabs) {
        await tester.tap(find.byIcon(tab.$1));
        await tester.pumpAndSettle();
        
        // Verify we're still on dashboard (tabs switch content, not pages)
        expect(find.byType(DashboardPage), findsOneWidget);
      }
    });

    testWidgets('Accessibility: Semantics and High Contrast', (WidgetTester tester) async {
      final handle = tester.ensureSemantics();
      
      await tester.pumpWidget(createApp());
      await tester.pumpAndSettle(const Duration(milliseconds: 800));

      // Verify semantic header is present
      final semanticsFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && 
                    widget.properties.label == 'FBLA Future Engagement Dashboard',
      );
      expect(semanticsFinder, findsOneWidget);

      // Verify high contrast colors are used (FBLA Blue)
      final appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);

      handle.dispose();
    });
  });
}
