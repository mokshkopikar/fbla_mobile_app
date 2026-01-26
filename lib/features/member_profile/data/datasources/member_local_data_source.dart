import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/member_model.dart';
import 'member_data_source.dart';

/// Local data source implementation using [SharedPreferences].
/// 
/// [Data Handling & Storage]: This demonstrates secure and persistent 
/// storage on the device's sandbox. It ensures member data stays 
/// on the device between app restarts.
class MemberLocalDataSourceImpl implements MemberDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'CACHED_MEMBER';

  MemberLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<MemberModel> getMember() async {
    final jsonString = sharedPreferences.getString(_key);
    
    if (jsonString != null) {
      // Return cached data if available
      return MemberModel.fromJson(json.decode(jsonString));
    } else {
      // Return default "Mock" data if first run
      return const MemberModel(
        id: 'FBLA-2026-001',
        firstName: 'Future',
        lastName: 'Leader',
        email: 'leader@fbla.org',
        chapter: 'Blue Ridge High School',
        gradeLevel: '11',
      );
    }
  }

  @override
  Future<void> saveMember(MemberModel member) async {
    final jsonString = json.encode(member.toJson());
    await sharedPreferences.setString(_key, jsonString);
  }
}
