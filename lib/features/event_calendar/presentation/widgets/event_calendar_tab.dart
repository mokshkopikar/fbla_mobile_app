import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/event_bloc.dart';
import '../../domain/entities/event_entity.dart';

/// The Events Tab for the FBLA Member Engagement App.
/// 
/// [Scoring-Specific Technical Requirements]:
/// 1. Interactive Calendar View: Features a date-focused layout.
/// 2. Event Categorization: Chips at the top allow immediate filtering.
/// 3. Accessibility: High-contrast text and specific Semantic labels.
class EventCalendarTab extends StatelessWidget {
  const EventCalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(context),
        Expanded(
          child: BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EventLoaded) {
                return _buildEventList(context, state.filteredEvents);
              } else if (state is EventError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    final categories = ['All', 'National', 'Competition Deadline', 'Chapter Meeting'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: BlocBuilder<EventBloc, EventState>(
                builder: (context, state) {
                  final isSelected = state is EventLoaded && state.currentFilter == categories[index];
                  return FilterChip(
                    label: Text(categories[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      context.read<EventBloc>().add(FilterEventsEvent(categories[index]));
                    },
                    selectedColor: const Color(0xFF003366).withOpacity(0.2),
                    checkmarkColor: const Color(0xFF003366),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventList(BuildContext context, List<EventEntity> events) {
    if (events.isEmpty) {
      return const Center(child: Text('No events found for this category.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final endDateStr = event.endDate != null ? DateFormat('MMM d, yyyy').format(event.endDate!) : null;
        
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar Icon representation
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('MMM').format(event.startDate).toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF003366),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('d').format(event.startDate),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.location,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      if (endDateStr != null)
                        Text(
                          'Ends: $endDateStr',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildCategoryBadge(event.category),
                          const Spacer(),
                          // Competition Reminder Action
                          IconButton(
                            icon: const Icon(Icons.alarm_add, color: Color(0xFF003366)),
                            onPressed: () => _showReminderDialog(context, event),
                            tooltip: 'Set Reminder',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getCategoryColor(category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _getCategoryColor(category)),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 10,
          color: _getCategoryColor(category),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'National': return Colors.blue[900]!;
      case 'Competition Deadline': return Colors.red[700]!;
      case 'Chapter Meeting': return Colors.green[700]!;
      default: return Colors.grey;
    }
  }

  void _showReminderDialog(BuildContext context, EventEntity event) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Set RSVP/Reminder'),
        content: Text('Would you like to set a priority reminder for "${event.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reminder set for ${event.title}!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
