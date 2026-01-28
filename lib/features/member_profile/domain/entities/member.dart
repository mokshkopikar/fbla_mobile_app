import 'package:equatable/equatable.dart';

/// Domain entity representing an FBLA member's profile information.
/// 
/// **Architecture**: This is a Domain layer entity in Clean Architecture.
/// It is a pure Dart class with no dependencies on Flutter, external frameworks,
/// or data sources. This makes it:
/// - Highly testable
/// - Independent of data layer changes
/// - Reusable across different data sources
/// - Free from framework-specific code
/// 
/// **Immutability**: Uses const constructor and final fields to ensure
/// immutability, which:
/// - Prevents accidental modifications
/// - Improves performance (can be const)
/// - Makes state management predictable
/// 
/// **Equality**: Implements [Equatable] for value-based equality comparison,
/// which is essential for:
/// - State management (BLoC can detect changes)
/// - Testing (can compare entities easily)
/// - Caching (can check if data changed)
/// 
/// **Business Logic**: Contains computed properties (like [fullName]) that
/// represent business rules. This keeps business logic in the domain layer
/// where it belongs.
/// 
/// **Usage**: This entity is used throughout the application layers:
/// - Domain layer: Business logic operations, validation
/// - Data layer: Converted from/to [MemberModel]
/// - Presentation layer: Displayed in UI widgets
class Member extends Equatable {
  /// Unique identifier for the member (e.g., 'FBLA-2026-001').
  final String id;
  
  /// Member's first name.
  final String firstName;
  
  /// Member's last name.
  final String lastName;
  
  /// Member's email address.
  /// 
  /// Should be validated for proper email format before creating a [Member] instance.
  /// See [ProfileValidator] for validation logic.
  final String email;
  
  /// Name of the member's FBLA chapter (e.g., 'Blue Ridge High School').
  final String chapter;
  
  /// Member's grade level as a string (e.g., '9', '10', '11', '12').
  /// 
  /// Should be validated to ensure it's within valid range (typically 8-13
  /// for middle/high school). See [ProfileValidator] for validation logic.
  final String gradeLevel;

  /// Creates a new [Member] instance.
  /// 
  /// All parameters are required. Use const constructor for performance
  /// optimization when values are compile-time constants.
  /// 
  /// [id] - Unique identifier (required).
  /// [firstName] - First name (required).
  /// [lastName] - Last name (required).
  /// [email] - Email address (required, should be validated).
  /// [chapter] - Chapter name (required).
  /// [gradeLevel] - Grade level (required, should be validated).
  const Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.chapter,
    required this.gradeLevel,
  });

  /// Computed property that returns the member's full name.
  /// 
  /// **Business Logic**: This represents a business rule - how to display
  /// a member's name. By putting this in the domain entity, we ensure
  /// consistent name formatting across the entire application.
  /// 
  /// Returns a string in the format: "firstName lastName"
  /// Example: "Future Leader"
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, firstName, lastName, email, chapter, gradeLevel];
}
