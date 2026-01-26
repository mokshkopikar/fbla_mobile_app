# FBLA Future Engagement

**FBLA 2025-2026 Mobile Application Development Competition Entry**

A comprehensive mobile application designed to serve as the official FBLA member app, helping students stay connected, informed, and engaged with FBLA, its events, and its broader community.

## 📱 Project Overview

This Flutter application implements all required features for the FBLA Mobile Application Development competition:

- ✅ **Member Profiles**: View and edit personal FBLA member information with semantic validation
- ✅ **Event Calendar**: Interactive calendar with filtering and reminder functionality for NLC, SLC, and competition deadlines
- ✅ **Resources**: Access to key FBLA resources, documents, and competitive event guidelines
- ✅ **News Feed**: Real-time updates and announcements from FBLA National with search functionality
- ✅ **Social Integration**: Native share functionality and integration with social media platforms

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **Feature-First** structure:

```
lib/
├── core/                    # Shared utilities, use cases, error handling
├── features/                # Feature modules (Domain, Data, Presentation layers)
│   ├── dashboard/           # Main navigation hub
│   ├── member_profile/      # Profile management
│   ├── event_calendar/      # Events and calendar
│   ├── news_feed/          # News and announcements
│   ├── resources/          # Resource library
│   └── social/             # Social media integration
├── injection_container.dart # Dependency Injection setup
└── main.dart               # App entry point
```

### Design Patterns

- **BLoC Pattern**: State management using `flutter_bloc`
- **Repository Pattern**: Abstraction layer between data sources and business logic
- **Dependency Injection**: Service locator pattern using `get_it`
- **Clean Architecture**: Separation of concerns (Domain, Data, Presentation)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- iOS Simulator / Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd fbla_mobile_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📚 Key Features

### Member Profile
- View and edit personal information
- Semantic validation (grade level, email format, chapter name)
- Local persistence using SharedPreferences
- Accessible form inputs with clear error messages

### Event Calendar
- Filter events by category (National, Competition Deadline, Chapter Meeting)
- Set reminders for important events
- Visual calendar representation with date badges
- Offline-ready with mock data sources

### News Feed
- Search functionality for finding specific articles
- External link integration to official FBLA resources
- Real-time updates (mock implementation for demo)
- High-contrast UI for accessibility

### Resources
- Searchable resource library
- Categorized resources (Competitive Events, Chapter Management, etc.)
- Direct links to official FBLA documents
- Visual type indicators (PDF, Video, Link)

### Social Integration
- Native share functionality (iOS Share Sheet / Android Share Intent)
- Social feed with mock posts
- Integration with platform sharing capabilities
- Demonstrates direct social media application integration

## 🎨 Design & Accessibility

### Branding
- **Primary Color**: FBLA Blue (#003366)
- **Material Design 3**: Modern, accessible UI components
- **High Contrast**: WCAG AA compliant color schemes

### Accessibility Features
- Full Semantics support for screen readers
- Flexible text scaling (respects system settings)
- High-contrast color schemes
- Minimum touch target sizes (44x44pt)
- Clear error messages and form validation

See [UX Design Rationale](docs/ux_rationale.md) for detailed design decisions.

## 🧪 Testing

Run the complete test suite:
```bash
flutter test
```

Individual test files:
- `test/fbla_suite_test.dart` - Complete test suite
- `test/core/accessibility_test.dart` - Accessibility validation
- `test/features/*/` - Feature-specific tests

## 📖 Documentation

- [Planning Document](docs/planning.md) - Product planning and design rationale
- [UX Rationale](docs/ux_rationale.md) - User journey and design decisions
- [Judging Checklist](docs/judging_checklist.md) - Rubric mapping to code features
- [Presentation Guide](docs/presentation.md) - 7-minute presentation script
- [Third-Party Resources](THIRD_PARTY.md) - Copyright and license information

## 🏆 Competition Requirements

This application addresses all requirements from the FBLA 2025-2026 Mobile Application Development guidelines:

### Required Features ✅
- [x] Member profiles
- [x] Calendar for events and competition reminders
- [x] Access to key FBLA resources and documents
- [x] News feed with announcements and updates
- [x] Integration with chapter social media channels

### Technical Requirements ✅
- [x] Standalone functionality (no programming errors)
- [x] Smartphone deployable
- [x] Clean Architecture with appropriate use of classes/modules
- [x] Mobile app architectural patterns (BLoC, Repository)
- [x] Social media integration (native share)
- [x] Data handling and storage (local persistence)
- [x] Input validation (syntactical and semantic)
- [x] Accessibility features

## 📝 Code Quality

### Standards
- **Clean Code**: Meaningful variable names, clear function purposes
- **Documentation**: Comprehensive comments explaining architectural decisions
- **Testing**: Unit and widget tests for critical features
- **Error Handling**: Graceful error states with user-friendly messages

### Dependencies
- `flutter_bloc` - State management
- `get_it` - Dependency injection
- `equatable` - Value equality
- `shared_preferences` - Local storage
- `url_launcher` - External link handling
- `share_plus` - Native share functionality
- `intl` - Date formatting

See [pubspec.yaml](pubspec.yaml) for complete dependency list.

## 🔒 Data & Privacy

- **Local Storage**: Member profile data stored locally using SharedPreferences
- **No External APIs**: App uses mock data sources for demonstration (standalone ready)
- **Offline Capable**: All features work without internet connection
- **Data Security**: Sensitive data stored in device sandbox

## 🤝 Contributing

This is a competition entry for FBLA 2025-2026. For questions or issues, please refer to the competition guidelines.

## 📄 License

See [LICENSE](LICENSE) file for details. This project uses third-party libraries with their respective licenses. See [THIRD_PARTY.md](THIRD_PARTY.md) for attribution.

## 🙏 Acknowledgments

- FBLA for providing competition guidelines and resources
- Flutter team for the excellent framework
- All open-source contributors whose libraries made this project possible

---

**Built with ❤️ for FBLA 2025-2026 Mobile Application Development Competition**
