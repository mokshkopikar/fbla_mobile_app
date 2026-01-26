import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fbla_engagement/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:fbla_engagement/features/news_feed/presentation/bloc/news_bloc.dart';
import 'package:fbla_engagement/features/event_calendar/presentation/bloc/event_bloc.dart';
import 'package:fbla_engagement/features/resources/presentation/bloc/resource_bloc.dart';
import 'package:fbla_engagement/features/social/presentation/bloc/social_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';

class MockNewsBloc extends Mock implements NewsBloc {}
class MockEventBloc extends Mock implements EventBloc {}
class MockResourceBloc extends Mock implements ResourceBloc {}
class MockSocialBloc extends Mock implements SocialBloc {}

void main() {
  late MockNewsBloc mockNewsBloc;
  late MockEventBloc mockEventBloc;
  late MockResourceBloc mockResourceBloc;
  late MockSocialBloc mockSocialBloc;

  setUp(() {
    mockNewsBloc = MockNewsBloc();
    mockEventBloc = MockEventBloc();
    mockResourceBloc = MockResourceBloc();
    mockSocialBloc = MockSocialBloc();

    // Stub streams for BlocBuilders
    when(() => mockNewsBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockNewsBloc.state).thenReturn(NewsInitial());
    when(() => mockEventBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockEventBloc.state).thenReturn(EventInitial());
    when(() => mockResourceBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockResourceBloc.state).thenReturn(ResourceInitial());
    when(() => mockSocialBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSocialBloc.state).thenReturn(SocialInitial());
  });

  testWidgets('Accessibility: Dashboard should have semantic header', (WidgetTester tester) async {
    final handle = tester.ensureSemantics(); // Enable semantics for testing
    
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<NewsBloc>.value(value: mockNewsBloc),
          BlocProvider<EventBloc>.value(value: mockEventBloc),
          BlocProvider<ResourceBloc>.value(value: mockResourceBloc),
          BlocProvider<SocialBloc>.value(value: mockSocialBloc),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );

    // Verify presence of Semantics widget with correct label
    final semanticsFinder = find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.label == 'FBLA Future Engagement Dashboard',
    );
    expect(semanticsFinder, findsOneWidget);
    
    handle.dispose();
  });
}
