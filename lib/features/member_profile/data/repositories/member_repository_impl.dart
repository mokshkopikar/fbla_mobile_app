import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_data_source.dart';
import '../models/member_model.dart';

/// Implementation of the [MemberRepository] interface.
/// 
/// [Repository Pattern]: This class acts as a mediator between the Domain 
/// and Data layers. It handles the logic of where to fetch data from 
/// (e.g., check cache first, then network) and converts Models to Entities.
class MemberRepositoryImpl implements MemberRepository {
  final MemberDataSource dataSource;

  MemberRepositoryImpl({required this.dataSource});

  @override
  Future<Member> getProfile() async {
    // We return the result as a Member (Entity) to the Domain layer.
    // The Domain layer does not know about MemberModel or JSON.
    return await dataSource.getMember();
  }

  @override
  Future<void> updateProfile(Member member) async {
    // Convert entity to model before saving to the data source.
    final model = MemberModel.fromEntity(member);
    return await dataSource.saveMember(model);
  }
}
