# Changelog

All notable changes to InStep will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### To Be Added (Phase 2 - App Store Ready)
- App icon assets (1024x1024px)
- Complete IAP integration with product selection UI
- App Store screenshots for all device sizes
- Privacy policy document
- Purchase error handling and loading states
- Haptic feedback on scroll budget depletion
- Loading skeleton states
- Empty state when 0 steps

---

## [1.0.0-alpha] - 2026-01-01

### Added - MVP Complete ✅

#### Core Features
- HealthKit integration for real-time step tracking
- Scroll budget system with 1 step = 5 scrolls conversion rate
- Daily automatic reset at midnight
- Instagram-like feed with 100 simulated posts
- Real-time scroll position tracking
- Scroll budget enforcement (hard stop when depleted)
- Soft lock modal overlay when out of scrolls
- Visual scroll budget indicator in header
- Circular progress indicator showing remaining budget
- 4-page onboarding flow with HealthKit permission request
- StoreKit 2 integration framework
- Basic in-app purchase structure (3 product tiers)

#### Technical Implementation
- SwiftUI-based architecture
- Combine framework for reactive state management
- `HealthKitManager` for step tracking and authorization
- `ScrollBudgetManager` for budget calculations and persistence
- `StoreManager` for in-app purchase handling (structure only)
- `Post` model with sample data generator
- UserDefaults persistence for scroll usage tracking
- GeometryReader + PreferenceKey for scroll offset measurement
- Background HealthKit delivery for real-time step updates

#### Views & UI
- `ContentView` - Root view with onboarding orchestration
- `OnboardingView` - 4-page tutorial with TabView
- `FeedView` - Main scrollable feed with budget tracking
- `PostCardView` - Instagram-style post card component
- `ScrollBudgetView` - Persistent header with budget display
- Color-coded progress indicators (blue → red as budget depletes)
- SF Symbols throughout for consistent iconography

#### Configuration
- Xcode project structure (`InStep.xcodeproj`)
- Info.plist with HealthKit usage descriptions
- Entitlements file with HealthKit and IAP capabilities
- Asset catalog with AppIcon and AccentColor
- iOS 16.0+ deployment target
- iPhone-only support (portrait orientation)

#### Documentation
- README.md with setup instructions and feature overview
- ARCHITECTURE.md with detailed technical documentation
- ROADMAP.md with future development plans
- CHANGELOG.md (this file)
- LICENSE file (MIT)

#### Project Structure
```
InStep/
├── InStepApp.swift
├── ContentView.swift
├── Info.plist
├── InStep.entitlements
├── Managers/
│   ├── HealthKitManager.swift
│   ├── ScrollBudgetManager.swift
│   └── StoreManager.swift
├── Models/
│   └── Post.swift
└── Views/
    ├── FeedView.swift
    ├── PostCardView.swift
    ├── ScrollBudgetView.swift
    └── OnboardingView.swift
```

### Known Issues
- IAP purchase button in FeedView not connected to StoreManager (adds 100 scrolls directly)
- No error handling for HealthKit authorization failures
- No loading states during data fetching
- Scroll tracking may fire frequently (potential battery impact)
- No analytics or crash reporting
- No unit or UI tests

### Technical Details
- **Language**: Swift 5.0
- **Minimum iOS**: 16.0
- **Frameworks**: SwiftUI, Combine, HealthKit, StoreKit
- **Architecture**: MVVM-inspired with ObservableObject managers
- **Persistence**: UserDefaults
- **State Management**: @Published properties + @EnvironmentObject

---

## Version Template (for future releases)

## [X.X.X] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes to existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements

---

## Release Notes Format

When publishing releases, use this format:

### v1.0.0 - Walk More, Scroll More 🎉
**Initial Release**

InStep is here! Turn your steps into scrolling credits and gamify your physical activity.

**What's New**:
- Track steps via Apple Health
- Earn 5 scrolls per step
- Browse an Instagram-like feed
- Purchase extra scrolls when needed
- Beautiful onboarding experience

**Requirements**:
- iPhone running iOS 16.0 or later
- Access to Apple Health data

**Known Limitations**:
- Simulated feed content (Reddit integration coming in v1.1)
- US App Store only at launch

Download now and start walking!

---

## Future Changelog Entries (Planned)

### [1.1.0] - Reddit Integration (Planned Q1 2026)
- Reddit API client implementation
- Subreddit selection and management
- Real post loading with images
- Infinite scroll with pagination
- Image caching system
- Pull-to-refresh functionality

### [1.2.0] - Gamification Update (Planned Q2 2026)
- Achievement system with badges
- Daily streak tracking
- Weekly and monthly statistics
- Swift Charts integration
- Push notifications for streaks

### [1.3.0] - Customization & Widgets (Planned Q2 2026)
- Settings screen
- Customizable scroll-to-step ratio
- Home screen widgets
- Lock screen widgets (iOS 16+)
- Notification preferences

### [2.0.0] - Social Features (Planned Q3 2026)
- Friend system
- Leaderboards
- Step challenges
- Share achievements
- Referral program

---

## Development Notes

### Commit Message Format
Use conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

Example: `feat: add Reddit API integration for real posts`

### Versioning Strategy
- **Major (X.0.0)**: Breaking changes, major features
- **Minor (0.X.0)**: New features, backwards compatible
- **Patch (0.0.X)**: Bug fixes, small improvements

### Release Process
1. Update CHANGELOG.md with new version
2. Update version in Xcode project settings
3. Create git tag: `git tag v1.0.0`
4. Push tag: `git push origin v1.0.0`
5. Create GitHub release with notes from CHANGELOG
6. Submit to App Store via Xcode or Transporter

---

**Legend**:
- ✅ Complete
- 🚧 In Progress
- 📝 Planned
- ❌ Cancelled/Removed
