import 'package:equatable/equatable.dart';

/// Represents a news article or announcement from FBLA.
/// 
/// [Clean Architecture]: Entities are pure Dart classes without external dependencies.
class NewsEntry extends Equatable {
  final String id;
  final String title;
  final String date;
  final String summary;
  final String? imageUrl;
  final String link;

  const NewsEntry({
    required this.id,
    required this.title,
    required this.date,
    required this.summary,
    this.imageUrl,
    required this.link,
  });

  @override
  List<Object?> get props => [id, title, date, summary, imageUrl, link];
}
