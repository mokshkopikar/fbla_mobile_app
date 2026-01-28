import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/member_model.dart';
import 'member_data_source.dart';

/// Local data source implementation using [SharedPreferences] for persistent storage.
/// 
/// **Architecture**: This is part of the Data layer in Clean Architecture.
/// It handles low-level data operations (reading/writing to device storage).
/// 
/// **Storage Mechanism**: Uses [SharedPreferences], which:
/// - Stores data in the device's app sandbox (secure)
/// - Persists data between app restarts
/// - Provides key-value storage (we store JSON string)
/// - Is platform-agnostic (works on iOS, Android, Web)
/// 
/// **Data Security**: 
/// - Data is stored in the app's private directory (sandbox)
/// - Not accessible by other apps
/// - Cleared when app is uninstalled
/// 
/// **Data Format**: Member data is stored as a JSON string for flexibility.
/// This allows easy serialization/deserialization of the [MemberModel].
/// 
/// **First-Time Users**: Returns a default mock member profile if no data
/// exists, ensuring the app works immediately without requiring user setup.
/// 
/// **Standalone Ready**: This implementation ensures the app works completely
/// offline, meeting FBLA competition requirements.
class MemberLocalDataSourceImpl implements MemberDataSource {
  /// The SharedPreferences instance for storing/retrieving data.
  /// 
  /// Injected via constructor for testability (can inject mock SharedPreferences).
  final SharedPreferences sharedPreferences;
  
  /// The key used to store member profile data in SharedPreferences.
  /// 
  /// Using a constant key ensures consistency and makes it easy to clear
  /// the cache if needed.
  static const String _key = 'CACHED_MEMBER';

  /// Creates a new [MemberLocalDataSourceImpl] instance.
  /// 
  /// [sharedPreferences] - The SharedPreferences instance to use for storage (required).
  ///                      Dependency is injected for testability.
  MemberLocalDataSourceImpl({required this.sharedPreferences});

  /// Retrieves the member's profile from local storage.
  /// 
  /// **Implementation**:
  /// 1. Attempts to read cached profile data from SharedPreferences
  /// 2. If data exists: Deserializes JSON string to [MemberModel]
  /// 3. If no data exists: Returns default mock member profile
  /// 
  /// **First-Time Users**: Returns a default member profile with:
  /// - ID: 'FBLA-2026-001'
  /// - Name: 'Future Leader'
  /// - Email: 'leader@fbla.org'
  /// - Chapter: 'Blue Ridge High School'
  /// - Grade: '11'
  /// 
  /// Returns a [Future] that completes with a [MemberModel] representing
  /// the stored member profile, or a default profile if none exists.
  /// 
  /// **Error Handling**: If JSON deserialization fails, this will throw
  /// a [FormatException]. In production, you might want to catch this and
  /// return a default profile or log the error.
  @override
  Future<MemberModel> getMember() async {
    // Attempt to read cached profile from SharedPreferences
    final jsonString = sharedPreferences.getString(_key);
    
    if (jsonString != null) {
      // Profile data exists - deserialize JSON to MemberModel
      // This handles returning previously saved profile data
      return MemberModel.fromJson(json.decode(jsonString));
    } else {
      // No profile data found (first-time user)
      // Return default mock profile to ensure app works immediately
      // This meets the "Standalone Ready" requirement for FBLA competition
      return const MemberModel(
        id: 'FBLA-2026-001',
        firstName: 'Future',
        lastName: 'Leader',
        email: 'leader@fbla.org',
        chapter: 'Blue Ridge High School',
        gradeLevel: '11',
      );
    }
  }

  /// Saves the member's profile to local storage.
  /// 
  /// **Implementation**:
  /// 1. Serializes [MemberModel] to JSON string
  /// 2. Stores JSON string in SharedPreferences using the cache key
  /// 3. Data persists between app sessions
  /// 
  /// **Storage Format**: Data is stored as a JSON string, which:
  /// - Is human-readable (for debugging)
  /// - Allows easy serialization/deserialization
  /// - Can be easily migrated if data structure changes
  /// 
  /// [member] - The [MemberModel] containing the profile data to save.
  /// 
  /// Returns a [Future] that completes when the data has been successfully
  /// saved to SharedPreferences.
  /// 
  /// **Error Handling**: If JSON serialization fails, this will throw
  /// an exception. In production, you might want to validate the model
  /// before saving.
  @override
  Future<void> saveMember(MemberModel member) async {
    // Serialize MemberModel to JSON string
    // This converts the model to a format suitable for storage
    final jsonString = json.encode(member.toJson());
    
    // Save JSON string to SharedPreferences
    // This persists the data to device storage, making it available after app restarts
    await sharedPreferences.setString(_key, jsonString);
  }
}
