import '../../domain/entities/news_entry.dart';

class NewsModel extends NewsEntry {
  const NewsModel({
    required super.id,
    required super.title,
    required super.date,
    required super.summary,
    super.imageUrl,
    required super.link,
    required super.category,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      summary: json['summary'] as String,
      imageUrl: json['imageUrl'] as String?,
      link: json['link'] as String,
      category: json['category'] as String? ?? 'National Center News',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'summary': summary,
      'imageUrl': imageUrl,
      'link': link,
      'category': category,
    };
  }
}
