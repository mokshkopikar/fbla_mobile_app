import '../../domain/entities/member.dart';

/// Data model for FBLA Member with JSON serialization.
/// 
/// [Separation of Concerns]: Models belong to the Data layer. They extend
/// Entities from the Domain layer to add data-specific logic like JSON parsing.
/// This keeps the Domain layer pure and free from external dependencies or 
/// framework-specific code like `fromJson`.
class MemberModel extends Member {
  const MemberModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.chapter,
    required super.gradeLevel,
  });

  /// Factory constructor to create a [MemberModel] from a JSON map.
  /// 
  /// Used when receiving data from an API or local storage.
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      chapter: json['chapter'] as String,
      gradeLevel: json['gradeLevel'] as String,
    );
  }

  /// Converts the [MemberModel] instance into a JSON map.
  /// 
  /// Used when sending data to an API or saving to local storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'chapter': chapter,
      'gradeLevel': gradeLevel,
    };
  }

  /// Helper to convert a [Member] entity into a [MemberModel].
  factory MemberModel.fromEntity(Member member) {
    return MemberModel(
      id: member.id,
      firstName: member.firstName,
      lastName: member.lastName,
      email: member.email,
      chapter: member.chapter,
      gradeLevel: member.gradeLevel,
    );
  }
}
