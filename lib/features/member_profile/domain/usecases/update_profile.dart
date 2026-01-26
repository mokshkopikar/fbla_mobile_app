import '../../../../core/usecases/usecase.dart';
import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case to update the member's profile details.
/// 
/// This encapsulates the business operation of profile modification.
class UpdateProfile implements UseCase<void, Member> {
  final MemberRepository repository;

  const UpdateProfile(this.repository);

  @override
  Future<void> call(Member member) async {
    return await repository.updateProfile(member);
  }
}
