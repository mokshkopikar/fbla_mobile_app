import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/features/social/presentation/bloc/social_bloc.dart';
import '../../../../../lib/features/social/presentation/widgets/social_feed_tab.dart';
import '../../../../../lib/features/social/domain/entities/social_post_entity.dart';

class MockSocialBloc extends Mock implements SocialBloc {}

void main() {
  late MockSocialBloc mockSocialBloc;

  setUp(() {
    mockSocialBloc = MockSocialBloc();
    when(() => mockSocialBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockSocialBloc.state).thenReturn(SocialInitial());
    when(() => mockSocialBloc.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<SocialBloc>.value(
          value: mockSocialBloc,
          child: const SocialFeedTab(),
        ),
      ),
    );
  }

  testWidgets('Should display social posts', (WidgetTester tester) async {
    final posts = [
      SocialPostEntity(
        id: '1',
        authorName: 'FBLA',
        authorHandle: '@fbla',
        content: 'Hello FBLA!',
        timestamp: DateTime.now(),
        likes: 10,
      ),
    ];
    when(() => mockSocialBloc.state).thenReturn(SocialLoaded(posts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Hello FBLA!'), findsOneWidget);
    expect(find.text('FBLA'), findsOneWidget);
  });

  testWidgets('Should display share button in header (Demo Script Test)', (WidgetTester tester) async {
    when(() => mockSocialBloc.state).thenReturn(const SocialLoaded([]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert: Share/Invite button is present in header
    expect(find.text('Invite'), findsOneWidget);
    expect(find.byIcon(Icons.person_add_alt_1), findsOneWidget);
  });

  testWidgets('Should display share buttons on individual posts', (WidgetTester tester) async {
    final posts = [
      SocialPostEntity(
        id: '1',
        authorName: 'FBLA National',
        authorHandle: '@FBLA_National',
        content: 'Check out this FBLA update!',
        timestamp: DateTime.now(),
        likes: 10,
      ),
    ];
    when(() => mockSocialBloc.state).thenReturn(SocialLoaded(posts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert: Share icon is present on posts
    expect(find.byIcon(Icons.share_outlined), findsWidgets);
  });

  testWidgets('Should display time ago formatting correctly', (WidgetTester tester) async {
    final posts = [
      SocialPostEntity(
        id: '1',
        authorName: 'FBLA',
        authorHandle: '@fbla',
        content: 'Test post',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 10,
      ),
    ];
    when(() => mockSocialBloc.state).thenReturn(SocialLoaded(posts));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert: Time ago is displayed (should show "2h ago" or similar)
    expect(find.textContaining('ago'), findsOneWidget);
  });
}
