import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fbla_engagement/features/member_profile/presentation/pages/member_profile_page.dart';
import 'package:fbla_engagement/injection_container.dart' as di;
import 'package:get_it/get_it.dart';

void main() async {
  // Reset GetIt before each test to ensure a clean state
  setUp(() async {
    await GetIt.instance.reset();
    await di.init();
  });

  group('Member Profile Use Cases - Automated Demo Test', () {
    
    testWidgets('Use Case 1: Initial Profile Retrieval (View Profile)', (WidgetTester tester) async {
      // 1. Arrange: Wrap in MaterialApp
      await tester.pumpWidget(const MaterialApp(home: MemberProfilePage()));

      // 2. Act: Wait for the mock 1-second delay
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // 3. Assert: Verify initial mock data is visible
      expect(find.text('Future Leader'), findsOneWidget);
      expect(find.text('Blue Ridge High School'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);
    });

    testWidgets('Use Case 2: Semantic Validation (Grade Level 9-12)', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MemberProfilePage()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 1. Open Edit Dialog
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // 2. Enter an invalid grade level (8th grade is not HS FBLA)
      final gradeField = find.widgetWithText(TextFormField, 'Grade Level (9-12)');
      await tester.enterText(gradeField, '8');
      
      // 3. Try to save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // 4. Assert: Semantic validation message appears
      expect(find.text('FBLA High School membership is for grades 9-12'), findsOneWidget);
    });

    testWidgets('Use Case 3: Syntactical Validation - Email Format', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MemberProfilePage()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 1. Open Edit Dialog
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // 2. Enter an invalid email format
      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.enterText(emailField, 'invalid-email');
      
      // 3. Try to save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // 4. Assert: Syntactical validation message appears
      expect(find.text('Enter a valid email address'), findsOneWidget);
    });

    testWidgets('Use Case 3b: Valid Email Format Accepted', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MemberProfilePage()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 1. Open Edit Dialog
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // 2. Enter a valid email format
      final emailField = find.widgetWithText(TextFormField, 'Email');
      await tester.enterText(emailField, 'valid@fbla.org');
      
      // 3. Enter valid grade level
      final gradeField = find.widgetWithText(TextFormField, 'Grade Level (9-12)');
      await tester.enterText(gradeField, '11');
      
      // 4. Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // 5. Assert: No validation error (form saves successfully)
      expect(find.text('Enter a valid email address'), findsNothing);
    });

    testWidgets('Use Case 2b: Grade Level 13 Rejected (Above Range)', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MemberProfilePage()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 1. Open Edit Dialog
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // 2. Enter grade level 13 (above valid range)
      final gradeField = find.widgetWithText(TextFormField, 'Grade Level (9-12)');
      await tester.enterText(gradeField, '13');
      
      // 3. Try to save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // 4. Assert: Semantic validation message appears
      expect(find.text('FBLA High School membership is for grades 9-12'), findsOneWidget);
    });

    testWidgets('Use Case 4: Successful Profile Update', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MemberProfilePage()));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 1. Open Edit Dialog
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // 2. Change name to "Updated Leader"
      final firstNameField = find.widgetWithText(TextFormField, 'First Name');
      await tester.enterText(firstNameField, 'Updated');
      
      // 3. Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // 4. Wait for the mock delay and check result
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // 5. Assert: UI reflects the change
      expect(find.text('Updated Leader'), findsOneWidget);
    });
  });
}
