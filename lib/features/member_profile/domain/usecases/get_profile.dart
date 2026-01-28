import '../../../../core/usecases/usecase.dart';
import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case for retrieving the current member's profile from the repository.
/// 
/// This use case implements the Single Responsibility Principle by handling
/// only one specific business operation: retrieving the member profile.
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
/// - [MemberProfileBloc] when handling [GetProfileEvent]
/// - Other domain services that need member profile data
/// 
/// **Data Source**: The repository determines where to fetch data from
/// (local storage, remote API, cache, etc.). This use case doesn't need to know.
/// 
/// **Error Handling**: Errors from the repository are propagated up to the
/// calling layer (typically BLoC) for appropriate handling.
/// 
/// **Example**:
/// ```dart
/// final getProfile = GetProfile(repository);
/// final member = await getProfile(NoParams());
/// ```
class GetProfile implements UseCase<Member, NoParams> {
  /// The repository that provides access to member profile data.
  /// 
  /// This follows the Repository pattern, abstracting the data source
  /// from the business logic.
  final MemberRepository repository;

  /// Creates a new [GetProfile] use case instance.
  /// 
  /// [repository] - The member repository to fetch profile from (required).
  const GetProfile(this.repository);

  /// Executes the use case to retrieve the member's profile.
  /// 
  /// **Implementation Details**:
  /// - Delegates to the repository's [MemberRepository.getProfile] method
  /// - Returns a [Member] entity (domain object)
  /// - Throws exceptions if repository operations fail
  /// 
  /// [params] - Not used for this use case (use [NoParams]).
  /// 
  /// Returns a [Future] that completes with a [Member] object representing
  /// the current user's profile information.
  /// 
  /// Throws exceptions from the repository layer if data retrieval fails.
  /// Common scenarios:
  /// - No profile data found (first-time user)
  /// - Storage access errors
  /// - Data corruption
  @override
  Future<Member> call(NoParams params) async {
    // Delegate to repository - this maintains separation of concerns
    // The repository handles the actual data retrieval logic (local storage, API, etc.)
    return await repository.getProfile();
  }
}
