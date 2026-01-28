/// FBLA 2025-2026 Competitive Event - Test Suite
/// 
/// This file aggregates all feature tests into a single suite to ensure
/// no regressions occur during development.
/// 
/// Total Coverage categories:
/// 1. Member Profile (Auth & Profile persistence)
/// 2. Dashboard (Navigation & Layout)
/// 3. Newsfeed (Data fetching & Search)

/// FBLA 2025-2026 Competitive Event - Complete Test Suite
/// 
/// This file aggregates all feature tests into a single suite to ensure
/// no regressions occur during development. All tests mirror the demo script
/// used for the competition presentation.
/// 
/// Total Coverage categories:
/// 1. Member Profile (Auth & Profile persistence, Validation)
/// 2. Dashboard (Navigation & Layout, Help Dialog)
/// 3. Newsfeed (Data fetching & Search)
/// 4. Event Calendar (Filtering, Reminders)
/// 5. Resources (Search, Link handling)
/// 6. Social (Share functionality)
/// 7. Accessibility (Semantics, High contrast)
/// 8. Integration (Complete demo script flow)

import 'package:flutter_test/flutter_test.dart';
import 'features/member_profile/presentation/pages/member_profile_page_test.dart' as profile_test;
import 'features/dashboard/presentation/pages/dashboard_page_test.dart' as dashboard_test;
import 'features/event_calendar/presentation/widgets/event_calendar_tab_test.dart' as event_test;
import 'features/resources/presentation/widgets/resource_list_tab_test.dart' as resource_test;
import 'features/social/presentation/widgets/social_feed_tab_test.dart' as social_test;
import 'features/news_feed/presentation/widgets/news_feed_tab_test.dart' as news_test;
import 'features/member_profile/data/datasources/member_local_data_source_test.dart' as persistence_test;
import 'features/news_feed/data/datasources/news_local_data_source_test.dart' as news_cache_test;
import 'features/event_calendar/data/datasources/event_local_data_source_test.dart' as event_cache_test;
import 'features/news_feed/data/repositories/news_repository_cache_test.dart' as news_repo_cache_test;
import 'core/accessibility_test.dart' as accessibility_test;
import 'demo_script_integration_test.dart' as integration_test;

void main() {
  group('FBLA COMPETITION COMPLETE SUITE', () {
    // Core & Persistence
    persistence_test.main();
    
    // Caching Tests (News & Events)
    news_cache_test.main();
    event_cache_test.main();
    news_repo_cache_test.main();
    
    accessibility_test.main();

    // Feature: Member Profile
    profile_test.main();
    
    // Feature: Dashboard & Newsfeed
    dashboard_test.main();
    
    // Feature: News Feed (Category filter, Clear button)
    news_test.main();

    // Feature: Event Calendar
    event_test.main();

    // Feature: Resource Center
    resource_test.main();

    // Feature: Social Media
    social_test.main();

    // Integration: Complete Demo Script Flow
    integration_test.main();
  });
}
