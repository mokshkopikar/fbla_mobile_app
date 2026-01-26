import '../models/member_model.dart';

/// Interface for Member data source.
/// 
/// Defines the low-level data operations. In a real-world app, this would
/// have implementations for both Remote (API) and Local (Database/Prefs).
abstract class MemberDataSource {
  Future<MemberModel> getMember();
  Future<void> saveMember(MemberModel member);
}

/// A mock implementation of the Member data source for the FBLA demo.
/// 
/// [Offline Ready]: This fulfills the requirement to have a standalone app
/// that works without an internet connection.
class MockMemberDataSource implements MemberDataSource {
  
  // In-memory "database" for the demo session.
  MemberModel _cachedMember = const MemberModel(
    id: 'FBLA-2026-001',
    firstName: 'Future',
    lastName: 'Leader',
    email: 'leader@fbla.org',
    chapter: 'Blue Ridge High School',
    gradeLevel: '11',
  );

  @override
  Future<MemberModel> getMember() async {
    // Artificial delay to simulate network/disk IO activity
    await Future.delayed(const Duration(seconds: 1));
    return _cachedMember;
  }

  @override
  Future<void> saveMember(MemberModel member) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _cachedMember = member;
  }
}
