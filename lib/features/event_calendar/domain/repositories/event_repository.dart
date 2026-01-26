import '../entities/event_entity.dart';

/// Interface for Event-related data fetching and persistence.
/// 
/// [Offline Data Handling]: Implementations are responsible for local caching
/// to ensure data accessibility during conferences with poor Wi-Fi.
abstract class EventRepository {
  Future<List<EventEntity>> getEvents();
  
  /// [Semantic Validation]: Ensures the reminder date is in the future
  /// and before the event actually starts.
  Future<void> setReminder(String eventId, DateTime reminderTime);
}
