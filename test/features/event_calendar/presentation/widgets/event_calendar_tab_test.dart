import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/features/event_calendar/presentation/bloc/event_bloc.dart';
import '../../../../../lib/features/event_calendar/presentation/widgets/event_calendar_tab.dart';
import '../../../../../lib/features/event_calendar/domain/entities/event_entity.dart';

class MockEventBloc extends Mock implements EventBloc {}

void main() {
  late MockEventBloc mockEventBloc;

  setUp(() {
    mockEventBloc = MockEventBloc();
    when(() => mockEventBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockEventBloc.state).thenReturn(EventInitial());
    when(() => mockEventBloc.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<EventBloc>.value(
          value: mockEventBloc,
          child: const EventCalendarTab(),
        ),
      ),
    );
  }

  testWidgets('Should display loading indicator when state is EventLoading', (WidgetTester tester) async {
    when(() => mockEventBloc.state).thenReturn(EventLoading());
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display events when state is EventLoaded', (WidgetTester tester) async {
    final events = [
      EventEntity(
        id: '1',
        title: 'NLC 2025',
        startDate: DateTime(2025, 6, 29),
        category: 'National',
        location: 'San Antonio, TX',
      ),
    ];
    when(() => mockEventBloc.state).thenReturn(EventLoaded(
      allEvents: events,
      filteredEvents: events,
      currentFilter: 'All',
    ));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('NLC 2025'), findsOneWidget);
    expect(find.text('San Antonio, TX'), findsOneWidget);
  });

  testWidgets('Should show "No events found" when list is empty', (WidgetTester tester) async {
    when(() => mockEventBloc.state).thenReturn(const EventLoaded(
      allEvents: [],
      filteredEvents: [],
      currentFilter: 'All',
    ));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('No events found for this category.'), findsOneWidget);
  });

  testWidgets('Should call FilterEventsEvent when a filter chip is pressed', (WidgetTester tester) async {
    final events = [
      EventEntity(
        id: '1',
        title: 'NLC 2025',
        startDate: DateTime(2025, 6, 29),
        category: 'National',
        location: 'San Antonio, TX',
      ),
    ];
    when(() => mockEventBloc.state).thenReturn(EventLoaded(
      allEvents: events,
      filteredEvents: events,
      currentFilter: 'All',
    ));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    final nationalChip = find.descendant(
      of: find.byType(FilterChip),
      matching: find.text('National'),
    );
    await tester.tap(nationalChip);
    await tester.pump();

    verify(() => mockEventBloc.add(const FilterEventsEvent('National'))).called(1);
  });

  testWidgets('Should filter events by National category (Demo Script Test)', (WidgetTester tester) async {
    final allEvents = [
      EventEntity(
        id: '1',
        title: 'National Leadership Conference',
        startDate: DateTime(2025, 6, 29),
        category: 'National',
        location: 'San Antonio, TX',
      ),
      EventEntity(
        id: '2',
        title: 'Chapter Meeting',
        startDate: DateTime(2025, 2, 15),
        category: 'Chapter Meeting',
        location: 'Local',
      ),
    ];
    
    when(() => mockEventBloc.state).thenReturn(EventLoaded(
      allEvents: allEvents,
      filteredEvents: allEvents,
      currentFilter: 'All',
    ));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Verify both events are shown initially
    expect(find.text('National Leadership Conference'), findsOneWidget);
    expect(find.text('Chapter Meeting'), findsOneWidget);

    // Simulate filtering by National
    when(() => mockEventBloc.state).thenReturn(EventLoaded(
      allEvents: allEvents,
      filteredEvents: [allEvents[0]], // Only National event
      currentFilter: 'National',
    ));
    await tester.pump();

    // After filtering, only National event should be visible
    expect(find.text('National Leadership Conference'), findsOneWidget);
    expect(find.text('Chapter Meeting'), findsNothing);
  });

  testWidgets('Should show reminder dialog when alarm icon is tapped (Demo Script Test)', (WidgetTester tester) async {
    final events = [
      EventEntity(
        id: '1',
        title: 'National Leadership Conference',
        startDate: DateTime(2025, 6, 29),
        category: 'National',
        location: 'San Antonio, TX',
      ),
    ];
    when(() => mockEventBloc.state).thenReturn(EventLoaded(
      allEvents: events,
      filteredEvents: events,
      currentFilter: 'All',
    ));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Find and tap the reminder/alarm icon
    final reminderButton = find.byIcon(Icons.alarm_add);
    expect(reminderButton, findsOneWidget);
    
    await tester.tap(reminderButton);
    await tester.pumpAndSettle();

    // Assert: Reminder dialog appears with event title
    expect(find.text('Set RSVP/Reminder'), findsOneWidget);
    expect(find.textContaining('National Leadership Conference'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
  });

  testWidgets('Should show success message when reminder is confirmed', (WidgetTester tester) async {
    final events = [
      EventEntity(
        id: '1',
        title: 'National Leadership Conference',
        startDate: DateTime(2025, 6, 29),
        category: 'National',
        location: 'San Antonio, TX',
      ),
    ];
    when(() => mockEventBloc.state).thenReturn(EventLoaded(
      allEvents: events,
      filteredEvents: events,
      currentFilter: 'All',
    ));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Open reminder dialog
    await tester.tap(find.byIcon(Icons.alarm_add));
    await tester.pumpAndSettle();

    // Confirm reminder
    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    // Assert: Success snackbar appears
    expect(find.textContaining('Reminder set for'), findsOneWidget);
  });
}
