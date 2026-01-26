# UX Design Rationale & User Journey

## Design Philosophy

The **FBLA Future Engagement** app is designed with accessibility, clarity, and member engagement at its core. Our UX approach prioritizes:

1. **Inclusivity**: Every member, regardless of ability, can fully engage with FBLA resources
2. **Efficiency**: Critical information (deadlines, events) is immediately accessible
3. **Clarity**: Intuitive navigation reduces cognitive load during competition season
4. **Consistency**: Unified design language across all features builds user confidence

## User Journey Map

### Onboarding Flow
1. **First Launch**: User sees the Dashboard with News tab active (most engaging content)
2. **Discovery**: Help icon in AppBar provides contextual instructions without overwhelming
3. **Profile Setup**: Accessible via profile icon - encourages personalization
4. **Engagement**: Bottom navigation enables quick switching between core features

### Primary User Flows

#### Flow 1: Member Checking Competition Deadlines
1. User opens app → Dashboard (News tab)
2. Taps "Events" in bottom navigation
3. Sees calendar view with upcoming events
4. Filters by "Competition Deadline" category
5. Sets reminder for critical deadline (e.g., NLC registration)
6. **Outcome**: Member never misses an important deadline

#### Flow 2: Chapter Officer Sharing News
1. User navigates to "News" tab
2. Searches for "Leadership" to find relevant updates
3. Reads article summary
4. Taps article to open in browser (external link)
5. Returns to app, navigates to "Social" tab
6. Uses native Share button to distribute to chapter members
7. **Outcome**: Information spreads efficiently through member network

#### Flow 3: Member Accessing Resources
1. User needs competitive event guidelines
2. Navigates to "Resources" tab
3. Uses search bar: "competitive events"
4. Finds relevant PDF/document
5. Taps to open official FBLA resource
6. **Outcome**: Member has quick access to official documentation

#### Flow 4: Profile Management
1. User taps profile icon in AppBar
2. Views current profile information
3. Taps "Edit Profile"
4. Form validates input in real-time:
   - Email format checked (syntactical)
   - Grade level validated (9-12 semantic rule)
   - Chapter name length verified
5. Saves changes → Success feedback
6. **Outcome**: Profile data is accurate and secure

## Accessibility Features

### Visual Accessibility
- **High Contrast**: FBLA Blue (#003366) on white provides WCAG AA compliant contrast ratios
- **Text Scaling**: All text uses Flutter's default scaling, respecting system accessibility settings
- **Color Independence**: Information is never conveyed by color alone (icons + text)

### Screen Reader Support
- **Semantics Widgets**: All interactive elements have descriptive labels
- **Header Semantics**: AppBar uses `Semantics(header: true)` for proper navigation
- **Form Labels**: All input fields have clear, descriptive labels

### Motor Accessibility
- **Touch Target Size**: All buttons meet minimum 44x44pt touch target guidelines
- **Spacing**: Adequate padding prevents accidental taps
- **Error Recovery**: Validation errors are clear and actionable

## Design Rationale by Feature

### Dashboard
**Why Bottom Navigation?**
- Thumb-friendly zone on modern smartphones
- Persistent visibility of all core features
- Industry-standard pattern reduces learning curve

**Why IndexedStack?**
- Preserves state when switching tabs (no data loss)
- Faster navigation (no rebuilds)
- Better user experience during rapid tab switching

### Event Calendar
**Why Filter Chips?**
- Visual categorization reduces scrolling
- Immediate feedback on selection
- Accessible via keyboard navigation

**Why Reminder Feature?**
- Bridges the gap between awareness and action
- Demonstrates "Innovation and Creativity" (rubric requirement)
- Practical utility for competition-focused members

### News Feed
**Why Search-First Approach?**
- Members often know what they're looking for
- Reduces cognitive load vs. browsing all articles
- Demonstrates advanced functionality

### Resources
**Why Category Badges?**
- Quick visual scanning
- Helps members find resources by type
- Consistent with event calendar design language

### Social Feed
**Why Native Share Integration?**
- Meets rubric requirement: "App is integrated to work directly with at least one social media application"
- Leverages platform capabilities (iOS Share Sheet, Android Share Intent)
- No third-party SDK dependencies = better stability

## Accessibility Testing Checklist

- [x] All interactive elements have Semantics labels
- [x] Color contrast meets WCAG AA standards
- [x] Text scales with system settings
- [x] Touch targets are minimum 44x44pt
- [x] Form validation provides clear error messages
- [x] Navigation is keyboard accessible (web platform)
- [x] Screen reader can navigate all features

## Future Enhancements (Post-Competition)

1. **Dark Mode**: High contrast dark theme for low-light environments
2. **Offline Mode Indicator**: Visual feedback when app is using cached data
3. **Push Notifications**: For critical deadline reminders
4. **Accessibility Settings Panel**: User-configurable text size, contrast preferences
