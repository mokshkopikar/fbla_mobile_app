import '../entities/member.dart';

/// Abstract interface for Member data operations.
/// 
/// [Separation of Concerns]: The Domain layer defines the 'what' 
/// (get a member, update a profile), while the Data layer defines the 'how'
/// (from a local SQL database or a remote API).
/// 
/// This ensures the business logic doesn't care if we are using 
/// a Mock server or a real backend.
abstract class MemberRepository {
  /// Retrieves the profile of the currently authenticated member.
  Future<Member> getProfile();

  /// Updates the member's profile information.
  /// 
  /// Throws an exception if validation fails or a network error occurs.
  Future<void> updateProfile(Member member);
}
