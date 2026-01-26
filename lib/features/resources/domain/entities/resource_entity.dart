import 'package:equatable/equatable.dart';

class ResourceEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category; // e.g., 'Competitive Events', 'Chapter Management', 'Lead FBLA'
  final String? url;
  final String? type; // e.g., 'PDF', 'Link', 'Video'

  const ResourceEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.url,
    this.type,
  });

  @override
  List<Object?> get props => [id, title, description, category, url, type];
}
