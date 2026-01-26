# FBLA 2025-2026: Mobile Application Development Judging Checklist

This document maps the official scoring rubric items to specific features and code locations within the **FBLA Future Engagement** application.

## 1. Design and Code Quality

| Rubric Item | Evidence in App | Code Location |
| :--- | :--- | :--- |
| **Planning Process** | Industry-standard documentation (Wireframes, User Stories). | `docs/planning.md` |
| **Appropriate use of Classes/Modules** | Feature-First Clean Architecture (Domain, Data, Presentation). | `lib/features/` |
| **Architectural Patterns** | Solid use of BLoC pattern and Dependency Injection. | `lib/main.dart`, `lib/injection_container.dart` |
| **Innovation and Creativity** | Personalized "Competition Reminders" feature and comprehensive accessibility support. | `lib/features/event_calendar/presentation/widgets/event_calendar_tab.dart` (lines 192-212) |

## 2. User Experience (UX)

| Rubric Item | Evidence in App | Code Location |
| :--- | :--- | :--- |
| **Accessibility Features** | Full Semantics support, High-Contrast support, Flexible text scaling. | `lib/main.dart` (Theme), `Semantics` widgets |
| **User Journey / Rationale** | Documented UX flow from onboarding to core engagement. | `docs/ux_rationale.md` |
| **Instructions / Intuitive UI** | Help dialog with instructions and intuitive bottom navigation. | `lib/features/dashboard/presentation/pages/dashboard_page.dart` (lines 31-56) |
| **Custom Icons/Graphics** | Consistent FBLA-themed icons and visual identity throughout app. | `lib/main.dart` (Theme), Material icons with FBLA color scheme |
| **Input Validation** | Semantic validation (e.g., Grade level ranges) with inline errors. | `lib/features/member_profile/domain/entities/profile_validator.dart` |

## 3. Application Functionality

| Rubric Item | Evidence in App | Code Location |
| :--- | :--- | :--- |
| **Addresses Prompt** | All 5 required topics (Profile, Calendar, Resources, News, Social) implemented. | `lib/features/` |
| **Social Media Integration** | Native "Share" functionality and direct links to FBLA social platforms. | `lib/features/social/` |
| **Standalone Stability** | App runs 100% offline using mock data sources for demonstration. | `lib/features/*/data/datasources/mock_*` |

## 4. Data Handling & Storage

| Rubric Item | Evidence in App | Code Location |
| :--- | :--- | :--- |
| **Secure Data Handling** | Local persistent storage using SharedPreferences for Profile. | `lib/features/member_profile/data/datasources/member_local_data_source.dart` |
| **Data Integrity** | State-managed data flow ensuring no data loss during navigation. | `lib/features/*/presentation/bloc/` |

## 5. Documentation & Copyright

| Rubric Item | Evidence in App | Code Location |
| :--- | :--- | :--- |
| **Copyright Compliance** | Professional citations for ALL FBLA external resources. | `THIRD_PARTY.md`, `LICENSE` |
| **Source Citations** | Resource center links directly to official fbla.org documents. | `lib/features/resources/data/datasources/` |
