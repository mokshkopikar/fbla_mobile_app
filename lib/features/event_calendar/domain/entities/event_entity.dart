import 'package:equatable/equatable.dart';

/// Represents a specific FBLA event or deadline in the domain layer.
/// 
/// [User Journey]: 
/// 1. Member opens the 'Events' tab to see what is happening.
/// 2. Member filters by 'National' or 'Competition Deadline'.
/// 3. Member selects an event to see more info and set a local reminder.
class EventEntity extends Equatable {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime? endDate;
  final String location;
  final String category; // e.g., 'National', 'Competition Deadline', 'Chapter Meeting'
  final String? notes;

  const EventEntity({
    required this.id,
    required this.title,
    required this.startDate,
    this.endDate,
    required this.location,
    required this.category,
    this.notes,
  });

  @override
  List<Object?> get props => [id, title, startDate, endDate, location, category, notes];
}
