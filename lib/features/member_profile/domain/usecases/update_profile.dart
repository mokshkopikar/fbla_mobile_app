import '../../../../core/usecases/usecase.dart';
import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case for updating the member's profile information.
/// 
/// This use case implements the Single Responsibility Principle by handling
/// only one specific business operation: updating member profile data.
/// 
/// **Architecture**: This is part of the Domain layer in Clean Architecture.
/// It contains pure business logic with no dependencies on Flutter or external
/// frameworks, making it highly testable.
/// 
/// **Dependency Inversion**: Depends on [MemberRepository] interface (abstraction),
/// not the concrete implementation. This allows:
/// - Easy testing with mock repositories
/// - Swapping implementations without changing business logic
/// - Following SOLID principles
/// 
/// **Usage**: This use case is typically called by:
/// - [MemberProfileBloc] when handling [UpdateProfileEvent]
/// - Other domain services that need to modify member data
/// 
/// **Data Persistence**: The repository determines where to save data
/// (local storage, remote API, etc.). This use case doesn't need to know.
/// 
/// **Validation**: Profile validation (e.g., email format, grade level range)
/// should be performed before calling this use case. See [ProfileValidator].
/// 
/// **Error Handling**: Errors from the repository are propagated up to the
/// calling layer (typically BLoC) for appropriate handling.
/// 
/// **Example**:
/// ```dart
/// final updateProfile = UpdateProfile(repository);
/// await updateProfile(updatedMember);
/// ```
class UpdateProfile implements UseCase<void, Member> {
  /// The repository that provides access to member profile data.
  /// 
  /// This follows the Repository pattern, abstracting the data source
  /// from the business logic.
  final MemberRepository repository;

  /// Creates a new [UpdateProfile] use case instance.
  /// 
  /// [repository] - The member repository to save profile to (required).
  const UpdateProfile(this.repository);

  /// Executes the use case to update the member's profile.
  /// 
  /// **Implementation Details**:
  /// - Delegates to the repository's [MemberRepository.updateProfile] method
  /// - Accepts a [Member] entity with updated information
  /// - Throws exceptions if repository operations fail
  /// 
  /// **Note**: This use case does not perform validation. Ensure the [member]
  /// object is validated before calling this method.
  /// 
  /// [member] - The [Member] entity containing updated profile information.
  /// 
  /// Returns a [Future] that completes when the profile has been successfully
  /// saved. The future completes with void (no return value).
  /// 
  /// Throws exceptions from the repository layer if data saving fails.
  /// Common scenarios:
  /// - Storage write errors
  /// - Network errors (if saving to remote API)
  /// - Permission errors
  @override
  Future<void> call(Member member) async {
    // Delegate to repository - this maintains separation of concerns
    // The repository handles the actual data persistence logic (local storage, API, etc.)
    return await repository.updateProfile(member);
  }
}
