/// Interface for Event DataSource.
abstract class EventDataSource {
  Future<List<Map<String, dynamic>>> getEvents();
}

/// A mock implementation of the Event data source.
/// 
/// [Offline Ready]: This provides static data so the app works during the live demo
/// without an active internet connection. Demonstrates "Robustness" to FBLA judges.
class MockEventDataSource implements EventDataSource {
  @override
  Future<List<Map<String, dynamic>>> getEvents() async {
    // Simulating network delay for realistic demo
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      {
        'id': '1',
        'title': 'FBLA National Leadership Conference',
        'date': '2026-06-29T09:00:00Z',
        'description': 'The ultimate FBLA experience!',
      },
      {
        'id': '2',
        'title': 'Regional Workshop',
        'date': '2026-02-15T10:00:00Z',
        'description': 'Skill building for future leaders.',
      },
    ];
  }
}
