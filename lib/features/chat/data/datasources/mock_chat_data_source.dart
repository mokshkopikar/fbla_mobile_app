/// Interface for Chat/Messaging DataSource.
abstract class ChatDataSource {
  Future<List<Map<String, dynamic>>> getMessages();
}

/// A mock implementation for the demo.
/// 
/// [Expert Architecture]: Using abstract classes for data sources allows
/// us to easily swap this Mock for a Firebase or WebSocket implementation 
/// without changing the UI or Domain layers.
class MockChatDataSource implements ChatDataSource {
  @override
  Future<List<Map<String, dynamic>>> getMessages() async {
    // Simulating local database retrieval
    return [
      {
        'id': '101',
        'sender': 'FBLA National',
        'text': 'Welcome to the Future of Member Engagement!',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 60)).toIso8601String(),
      },
      {
        'id': '102',
        'sender': 'State Advisor',
        'text': 'Registration for SLC is now open!',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
      },
    ];
  }
}
