import '../../../../core/usecases/usecase.dart';
import '../entities/member.dart';
import '../repositories/member_repository.dart';

/// Use case to retrieve the current member's profile.
/// 
/// [Dependency Inversion]: Depends on [MemberRepository] interface, not implementation.
class GetProfile implements UseCase<Member, NoParams> {
  final MemberRepository repository;

  const GetProfile(this.repository);

  @override
  Future<Member> call(NoParams params) async {
    return await repository.getProfile();
  }
}
