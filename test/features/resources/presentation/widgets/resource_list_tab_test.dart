import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../lib/features/resources/presentation/bloc/resource_bloc.dart';
import '../../../../../lib/features/resources/presentation/widgets/resource_list_tab.dart';
import '../../../../../lib/features/resources/domain/entities/resource_entity.dart';

class MockResourceBloc extends Mock implements ResourceBloc {}

void main() {
  late MockResourceBloc mockResourceBloc;

  setUp(() {
    mockResourceBloc = MockResourceBloc();
    when(() => mockResourceBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockResourceBloc.state).thenReturn(ResourceInitial());
    when(() => mockResourceBloc.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ResourceBloc>.value(
          value: mockResourceBloc,
          child: const ResourceListTab(),
        ),
      ),
    );
  }

  testWidgets('Should display loading indicator when loading', (WidgetTester tester) async {
    when(() => mockResourceBloc.state).thenReturn(ResourceLoading());
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should display resources when loaded', (WidgetTester tester) async {
    final resources = [
      const ResourceEntity(
        id: '1',
        title: 'Guidelines',
        description: 'Test Desc',
        category: 'Test Cat',
        type: 'PDF',
      ),
    ];
    when(() => mockResourceBloc.state).thenReturn(ResourceLoaded(resources));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Guidelines'), findsOneWidget);
    expect(find.text('Test Desc'), findsOneWidget);
    expect(find.text('Test Cat'), findsOneWidget);
  });

  testWidgets('Should call SearchResourcesEvent when typing in search bar', (WidgetTester tester) async {
    when(() => mockResourceBloc.state).thenReturn(const ResourceLoaded([]));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.enterText(find.byType(TextField), 'Guidelines');
    await tester.pump();

    verify(() => mockResourceBloc.add(const SearchResourcesEvent('Guidelines'))).called(1);
  });

  testWidgets('Should display resource with PDF icon and category badge', (WidgetTester tester) async {
    final resources = [
      const ResourceEntity(
        id: '1',
        title: '2025-26 Competitive Events Guidelines',
        description: 'Comprehensive guide to all FBLA competitive events',
        category: 'Competitive Events',
        type: 'PDF',
        url: 'https://www.fbla.org/competitive-events/',
      ),
    ];
    when(() => mockResourceBloc.state).thenReturn(ResourceLoaded(resources));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Assert: Resource title, description, and category are displayed
    expect(find.text('2025-26 Competitive Events Guidelines'), findsOneWidget);
    expect(find.text('Comprehensive guide to all FBLA competitive events'), findsOneWidget);
    expect(find.text('Competitive Events'), findsOneWidget);
    
    // Assert: PDF icon is present
    expect(find.byIcon(Icons.picture_as_pdf), findsOneWidget);
    
    // Assert: External link icon is present (indicates tappable)
    expect(find.byIcon(Icons.open_in_new), findsOneWidget);
  });

  testWidgets('Should search resources by title, description, and category', (WidgetTester tester) async {
    final allResources = [
      const ResourceEntity(
        id: '1',
        title: 'Competitive Events Guidelines',
        description: 'Guide to events',
        category: 'Competitive Events',
        type: 'PDF',
      ),
      const ResourceEntity(
        id: '2',
        title: 'Chapter Handbook',
        description: 'Chapter management',
        category: 'Chapter Management',
        type: 'PDF',
      ),
    ];
    
    when(() => mockResourceBloc.state).thenReturn(ResourceLoaded(allResources));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Verify both resources are shown initially
    expect(find.text('Competitive Events Guidelines'), findsOneWidget);
    expect(find.text('Chapter Handbook'), findsOneWidget);

    // Simulate search for "competitive"
    when(() => mockResourceBloc.state).thenReturn(ResourceLoaded([allResources[0]]));
    await tester.enterText(find.byType(TextField), 'competitive');
    await tester.pump();

    // After search, only matching resource should be visible
    expect(find.text('Competitive Events Guidelines'), findsOneWidget);
    expect(find.text('Chapter Handbook'), findsNothing);
  });
}
