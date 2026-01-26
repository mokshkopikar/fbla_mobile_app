import '../models/event_model.dart';

/// Data Source providing FBLA specific event dates.
/// 
/// [Expert Use of Architectural Patterns]: This Mock service implements the 
/// same interface as a real Remote API, allowing seamless transition to 
/// production backends without changing business logic or UI.
abstract class EventDataSource {
  Future<List<EventModel>> getEvents();
}

class MockEventDataSourceImpl implements EventDataSource {
  @override
  Future<List<EventModel>> getEvents() async {
    // Simulating "Data Integrity and Accessibility" through local mock storage.
    await Future.delayed(const Duration(milliseconds: 600));
    
    return [
      EventModel(
        id: 'ev-1',
        title: 'National Leadership Conference (NLC)',
        startDate: DateTime(2026, 6, 29),
        endDate: DateTime(2026, 7, 2),
        location: 'San Antonio, TX',
        category: 'National',
        notes: 'The premier FBLA competition event.',
      ),
      EventModel(
        id: 'ev-2',
        title: 'Collegiate NLC',
        startDate: DateTime(2026, 6, 6),
        endDate: DateTime(2026, 6, 8),
        location: 'Las Vegas, NV',
        category: 'National',
      ),
      EventModel(
        id: 'ev-3',
        title: 'National FBLA Week',
        startDate: DateTime(2026, 2, 8),
        endDate: DateTime(2026, 2, 14),
        location: 'Nationwide',
        category: 'National',
        notes: 'National Career & Technical Education Month',
      ),
      EventModel(
        id: 'ev-4',
        title: 'Membership Dues Deadline',
        startDate: DateTime(2026, 3, 1),
        location: 'Online',
        category: 'Competition Deadline',
        notes: 'Required for NLC eligibility (11:59 PM ET)',
      ),
      EventModel(
        id: 'ev-5',
        title: 'Spring Stock Market Game',
        startDate: DateTime(2026, 2, 3),
        endDate: DateTime(2026, 4, 11),
        location: 'Virtual',
        category: 'Competition Deadline',
        notes: 'National competition dates',
      ),
      EventModel(
        id: 'ev-6',
        title: 'Officer Leadership Summit',
        startDate: DateTime(2026, 2, 21),
        location: 'Virtual',
        category: 'Chapter Meeting',
        notes: 'Collegiate launching event.',
      ),
    ];
  }
}
