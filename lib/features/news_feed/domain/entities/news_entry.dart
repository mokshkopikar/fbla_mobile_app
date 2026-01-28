import 'package:equatable/equatable.dart';

/// Domain entity representing a news article or announcement from FBLA.
/// 
/// **Architecture**: This is a Domain layer entity in Clean Architecture.
/// It is a pure Dart class with no dependencies on Flutter, external frameworks,
/// or data sources. This makes it:
/// - Highly testable
/// - Independent of data layer changes
/// - Reusable across different data sources
/// 
/// **Equality**: Implements [Equatable] for value-based equality comparison,
/// which is essential for state management and testing.
/// 
/// **Usage**: This entity is used throughout the application layers:
/// - Domain layer: Business logic operations
/// - Data layer: Converted from/to [NewsModel]
/// - Presentation layer: Displayed in UI widgets
class NewsEntry extends Equatable {
  /// Unique identifier for the news article.
  final String id;
  
  /// The headline/title of the news article.
  final String title;
  
  /// Publication date of the article (formatted as string).
  /// 
  /// Format may vary, but typically follows: "MMM DD, YYYY" (e.g., "Jan 15, 2026").
  final String date;
  
  /// Brief summary or excerpt of the article content.
  /// 
  /// This is typically displayed in list views before the user taps to read more.
  final String summary;
  
  /// Optional URL to an image associated with the article.
  /// 
  /// If null, the UI should display a placeholder or default image.
  final String? imageUrl;
  
  /// URL link to the full article (typically on fbla.org).
  /// 
  /// This is opened in an external browser when the user taps the article.
  final String link;
  
  /// Category of the news article (e.g., 'National Center News', 'Chapter Spotlight').
  /// 
  /// Categories match those used on the FBLA website newsroom:
  /// - 'All Categories' (for filtering - shows all)
  /// - 'National Center News'
  /// - 'Chapter Spotlight'
  /// - 'State Spotlight'
  /// - 'Alumni Spotlight'
  final String category;

  /// Creates a new [NewsEntry] instance.
  /// 
  /// [id] - Unique identifier (required).
  /// [title] - Article headline (required).
  /// [date] - Publication date (required).
  /// [summary] - Article summary (required).
  /// [imageUrl] - Optional image URL.
  /// [link] - Link to full article (required).
  /// [category] - News category (required).
  const NewsEntry({
    required this.id,
    required this.title,
    required this.date,
    required this.summary,
    this.imageUrl,
    required this.link,
    required this.category,
  });

  @override
  List<Object?> get props => [id, title, date, summary, imageUrl, link, category];
}
