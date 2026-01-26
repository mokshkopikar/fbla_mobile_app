import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fbla_engagement/features/member_profile/data/datasources/member_local_data_source.dart';
import 'package:fbla_engagement/features/member_profile/data/models/member_model.dart';

void main() {
  late MemberLocalDataSourceImpl dataSource;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    dataSource = MemberLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });

  const tMemberModel = MemberModel(
    id: 'FBLA-2026-001',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@fbla.org',
    chapter: 'Test Chapter',
    gradeLevel: '12',
  );

  group('MemberLocalDataSource Persistence Test', () {
    test('should return default model when there is no cached value', () async {
      final result = await dataSource.getMember();
      expect(result.firstName, 'Future'); // Matches default in implementation
    });

    test('should cache and retrieve member model successfully', () async {
      // 1. Save
      await dataSource.saveMember(tMemberModel);
      
      // 2. Fetch
      final result = await dataSource.getMember();
      
      // 3. Assert
      expect(result, equals(tMemberModel));
      expect(sharedPreferences.getString('CACHED_MEMBER'), isNotNull);
    });
  });
}
