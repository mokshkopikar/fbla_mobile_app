/// Domain-level validation for FBLA Member Profile data.
/// 
/// Provides both Syntactical (format) and Semantic (business rules) validation.
class ProfileValidator {
  
  /// [Syntactical Validation]: Checks if the email follows standard format.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  /// [Semantic Validation]: Ensures the grade level is within valid FBLA high school ranges (9-12).
  /// 
  /// This is a business rule, not just a formatting rule.
  static String? validateGradeLevel(String? value) {
    if (value == null || value.isEmpty) return 'Grade level is required';
    final grade = int.tryParse(value);
    if (grade == null || grade < 9 || grade > 12) {
      return 'FBLA High School membership is for grades 9-12';
    }
    return null;
  }

  /// [Semantic Validation]: Ensures the chapter name is not just empty nonsense.
  static String? validateChapter(String? value) {
    if (value == null || value.isEmpty) return 'Chapter name is required';
    if (value.length < 3) return 'Chapter name must be at least 3 characters';
    return null;
  }
}
