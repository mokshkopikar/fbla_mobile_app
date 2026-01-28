import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_data_source.dart';
import '../models/member_model.dart';

/// Implementation of [MemberRepository] interface.
/// 
/// This class is part of the Data layer in Clean Architecture and serves as
/// the bridge between the Domain layer (business logic) and Data layer
/// (data sources).
/// 
/// **Responsibilities**:
/// - Implements the repository interface defined in the Domain layer
/// - Coordinates data operations with data sources
/// - Converts between domain entities ([Member]) and data models ([MemberModel])
/// - Handles data source errors and converts them to domain exceptions
/// 
/// **Architecture Pattern**: Repository Pattern
/// - Domain layer defines the interface (contract)
/// - Data layer provides the implementation
/// - This separation allows swapping data sources without changing business logic
/// 
/// **Data Conversion**:
/// - Domain layer works with [Member] entities (pure business objects)
/// - Data layer works with [MemberModel] (may include JSON serialization, etc.)
/// - This repository converts between the two layers
/// 
/// **Current Implementation**: Uses local data source (SharedPreferences) for
/// persistent storage. In a production app, this might coordinate between:
/// - Local data source (caching, offline support)
/// - Remote data source (API synchronization)
/// - Data synchronization logic
class MemberRepositoryImpl implements MemberRepository {
  /// The data source for member profile operations.
  /// 
  /// Currently uses local storage (SharedPreferences) for persistence.
  /// In production, this might be a combination of local and remote sources.
  final MemberDataSource dataSource;

  /// Creates a new [MemberRepositoryImpl] instance.
  /// 
  /// [dataSource] - The data source to fetch/save member data from (required).
  ///                Dependency is injected for testability.
  MemberRepositoryImpl({required this.dataSource});

  /// Retrieves the member's profile from the data source.
  /// 
  /// **Implementation**:
  /// - Delegates to [dataSource] to fetch member data
  /// - Returns domain entity ([Member]) to maintain layer separation
  /// - The data source returns [MemberModel], which is automatically converted
  ///   to [Member] via the model's conversion method
  /// 
  /// Returns a [Future] that completes with a [Member] domain entity
  /// representing the current user's profile.
  /// 
  /// Throws exceptions if the data source operation fails. In a production
  /// app, these would be caught and converted to domain-specific exceptions.
  /// 
  /// **First-Time Users**: If no profile exists, the data source should return
  /// a default/mock member profile.
  @override
  Future<Member> getProfile() async {
    // Fetch from data source (returns MemberModel)
    // The data source handles the actual storage mechanism (SharedPreferences, API, etc.)
    final model = await dataSource.getMember();
    
    // Convert model to entity before returning to domain layer
    // This ensures the domain layer never knows about data layer models
    return model.toEntity();
  }

  /// Updates the member's profile in the data source.
  /// 
  /// **Implementation**:
  /// - Converts domain entity ([Member]) to data model ([MemberModel])
  /// - Delegates to [dataSource] to persist the data
  /// - Maintains layer separation by converting between entity and model
  /// 
  /// [member] - The [Member] domain entity containing updated profile information.
  /// 
  /// Returns a [Future] that completes when the profile has been successfully
  /// saved. The future completes with void (no return value).
  /// 
  /// Throws exceptions if the data source operation fails. In a production
  /// app, these would be caught and converted to domain-specific exceptions.
  /// 
  /// **Persistence**: The data source determines how data is persisted
  /// (local storage, remote API, etc.). This repository doesn't need to know.
  @override
  Future<void> updateProfile(Member member) async {
    // Convert entity to model before saving to data source
    // This ensures the data source only works with data models, not domain entities
    final model = MemberModel.fromEntity(member);
    
    // Save to data source
    // The data source handles the actual persistence mechanism
    return await dataSource.saveMember(model);
  }
}
