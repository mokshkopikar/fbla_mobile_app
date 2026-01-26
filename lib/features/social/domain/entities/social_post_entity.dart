import 'package:equatable/equatable.dart';

class SocialPostEntity extends Equatable {
  final String id;
  final String authorName;
  final String authorHandle;
  final String content;
  final DateTime timestamp;
  final int likes;
  final String? imageUrl;

  const SocialPostEntity({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.content,
    required this.timestamp,
    required this.likes,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, authorName, authorHandle, content, timestamp, likes, imageUrl];
}
