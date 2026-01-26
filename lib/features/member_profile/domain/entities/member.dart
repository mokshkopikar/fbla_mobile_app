import 'package:equatable/equatable.dart';

/// Represents an FBLA Member in the domain layer.
/// 
/// This is a plain Dart class that defines the core business data.
/// It is independent of any data framework or UI logic.
/// 
/// [Dependency Inversion]: This entity is the source of truth for the feature.
class Member extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String chapter;
  final String gradeLevel;

  /// Const constructor for immutability and performance.
  const Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.chapter,
    required this.gradeLevel,
  });

  /// Business Logic: Get full name of the member.
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, email, chapter, gradeLevel];
}
