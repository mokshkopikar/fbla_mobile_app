# FBLA Presentation Guide (7-Minute Script)

## Setup (3 Minutes)
- **Device**: iPhone 12 (Standalone mode).
- **Settings**: Airplane Mode ON (Demonstrate offline capability).
- **Launch**: Open App to Onboarding/Logo.

## Presentation (7 Minutes)

### 1. Introduction (1 Minute)
"Good morning, judges. We present 'FBLA Future Engagement', a mobile solution built using **Flutter and Clean Architecture** to solve the challenge of member connectivity in a digital-first era."

### 2. The Member Heart: Profile & Onboarding (1.5 Minutes)
- **Action**: Show the Profile tab.
- **Key Point**: "We prioritize data integrity. Our input validation is semantic—it understands that a 12th grader shouldn't select 'Middle Level' conferences." (Demonstrate validation). 
- **Tech Hint**: Mentions `Shared_Preferences` for local persistence.

### 3. Staying Informed: News & Resources (1.5 Minutes)
- **Action**: Search for "Leadership" in News.
- **Key Point**: "Our app is a single source of truth. Notice the high-contrast UI and Semantics labels, ensuring every member, regardless of ability, stays informed."
- **Action**: Open a Resource PDF link.

### 4. Taking Action: Calendar & Social (2 Minutes)
- **Action**: Filter events by "National".
- **Key Point**: "The 'Reminder' feature (show dialog) bridges the gap between seeing an event and attending it."
- **Action**: Go to Social tab and tap **Share**.
- **Key Point**: "Sharing engagement is built-in. With one tap, members can push FBLA updates to their own social circles (Native Share Demo)."

### 5. Technical Excellence & Stability (1 Minute)
- **Point**: "Notice we are in **Airplane Mode**. The app's architecture uses a Mock Data Provider layer to ensure 100% stability during our demo today, mirroring real-world resilience."

## Q&A Preparation
- **Q: Why Flutter?** "Cross-platform consistency and industry-standard performance."
- **Q: How is data secured?** "Sensitive profile data is stored locally on the device's sandbox, never transmitted without encryption."
- **Q: Accessibility?** "We follow WCAG-inspired guidelines, utilizing Flutter's Semantics tree and accessible color contrasts."
