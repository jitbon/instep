# InStep Development Guide

This document contains practical information for developers working on InStep.

---

## Quick Start

### First Time Setup

1. **Clone and open**:
```bash
git clone <your-repo-url>
cd instep
open InStep.xcodeproj
```

2. **Configure signing**:
   - Select InStep target in Xcode
   - Go to "Signing & Capabilities"
   - Choose your Team
   - Xcode will auto-generate provisioning profile

3. **Run on simulator**:
   - Select iPhone simulator (iOS 16.0+)
   - Press Cmd+R
   - Grant HealthKit permission when prompted

4. **Add test steps** (Simulator only):
   - Open Health app in simulator
   - Browse → Activity → Steps → Add Data
   - Add 1000-5000 steps
   - Return to InStep to see updated budget

### Daily Development Workflow

```bash
# Pull latest changes
git pull origin main

# Open project
open InStep.xcodeproj

# Make changes, test, commit
git add .
git commit -m "feat: your feature description"
git push origin main
```

---

## Project Structure Explained

### File Organization

```
instep/
├── InStep.xcodeproj/          # Xcode project file
│   └── project.pbxproj         # Build configuration
├── InStep/                     # Main source directory
│   ├── InStepApp.swift         # App entry point, manager initialization
│   ├── ContentView.swift       # Root view, onboarding logic
│   ├── Info.plist              # App metadata, permissions
│   ├── InStep.entitlements     # Capabilities (HealthKit, IAP)
│   ├── Managers/               # Business logic layer
│   │   ├── HealthKitManager.swift      # HealthKit API wrapper
│   │   ├── ScrollBudgetManager.swift   # Scroll budget calculations
│   │   └── StoreManager.swift          # In-app purchase handling
│   ├── Models/                 # Data models
│   │   └── Post.swift          # Post model + sample data
│   └── Views/                  # UI layer
│       ├── FeedView.swift              # Main scrollable feed
│       ├── PostCardView.swift          # Individual post card
│       ├── ScrollBudgetView.swift      # Budget indicator header
│       └── OnboardingView.swift        # 4-page onboarding
├── .gitignore                  # Git ignore rules (Xcode-specific)
├── LICENSE                     # MIT license
├── README.md                   # User-facing documentation
├── ARCHITECTURE.md             # Technical architecture doc
├── ROADMAP.md                  # Feature roadmap
├── CHANGELOG.md                # Version history
└── DEVELOPMENT.md              # This file
```

### What Each File Does

| File | Purpose | Key Components |
|------|---------|----------------|
| `InStepApp.swift` | App entry point | `@main`, StateObject managers |
| `ContentView.swift` | Root view | Onboarding vs. main app logic |
| `HealthKitManager.swift` | Step tracking | `fetchTodaySteps()`, `observeStepCount()` |
| `ScrollBudgetManager.swift` | Budget logic | `consumeScroll()`, `resetIfNewDay()` |
| `StoreManager.swift` | IAP handling | `purchase()`, product definitions |
| `Post.swift` | Post model | `generateSamplePosts()` |
| `FeedView.swift` | Main feed | Scroll tracking, budget enforcement |
| `PostCardView.swift` | Post UI | Instagram-style card layout |
| `ScrollBudgetView.swift` | Budget display | Progress indicators, step count |
| `OnboardingView.swift` | Onboarding | 4 pages, HealthKit permission request |

---

## Common Development Tasks

### 1. Modifying the Scroll-to-Step Ratio

**Current**: 1 step = 5 scrolls

**To Change**:
1. Open `InStep/Managers/ScrollBudgetManager.swift`
2. Find `private let scrollsPerStep: Double = 5.0`
3. Change to desired value (e.g., `10.0` for easier scrolling, `3.0` for harder)
4. Update documentation:
   - `README.md` (scroll calculation section)
   - `ARCHITECTURE.md` (ScrollBudgetManager constants)
   - `OnboardingView.swift` (page 2 text)

### 2. Adding a New View

**Example**: Adding a settings screen

```swift
// 1. Create InStep/Views/SettingsView.swift
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var scrollBudgetManager: ScrollBudgetManager

    var body: some View {
        NavigationView {
            Form {
                Section("Preferences") {
                    // Your settings here
                }
            }
            .navigationTitle("Settings")
        }
    }
}
```

```swift
// 2. Add to ContentView.swift
NavigationLink("Settings") {
    SettingsView()
}
```

```swift
// 3. Update project.pbxproj (or add via Xcode)
// Right-click InStep/Views → Add Files to "InStep" → Select SettingsView.swift
```

### 3. Adding Sample Posts

**Location**: `InStep/Models/Post.swift`

**To modify**:
```swift
static func generateSamplePosts() -> [Post] {
    // Add more usernames, colors, captions here
    let usernames = ["your_username", "another_user"]
    let captions = ["Your caption here"]

    // Increase range for more posts
    return (0..<200).map { index in
        // ...
    }
}
```

### 4. Testing HealthKit on Simulator

**Add Steps Manually**:
1. Health app → Browse → Activity → Steps
2. Tap "Add Data" in top right
3. Enter step count (e.g., 5000)
4. Set date to today
5. Tap "Add"
6. Return to InStep (it should auto-update)

**Programmatic Testing** (for automated tests):
```swift
let healthStore = HKHealthStore()
let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: 1000)
let sample = HKQuantitySample(type: stepType, quantity: quantity, start: Date(), end: Date())

healthStore.save(sample) { success, error in
    // Steps added
}
```

### 5. Debugging Scroll Tracking

**Add print statements** in `FeedView.swift`:

```swift
.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
    let delta = lastScrollOffset - value
    print("📜 Scroll delta: \(delta)")

    if abs(delta) > 1 {
        let scrollDistance = abs(delta) / UIScreen.main.bounds.height
        print("📊 Scrolls consumed: \(scrollDistance)")
        scrollBudgetManager.consumeScroll(amount: scrollDistance)
    }
    lastScrollOffset = value
}
```

Run app and watch Xcode console while scrolling.

### 6. Resetting App State

**During Development**:
- Delete app from simulator/device
- Reinstalls with fresh UserDefaults
- HealthKit permissions will be re-requested

**Programmatically**:
```swift
// Add to SettingsView or debug menu
Button("Reset All Data") {
    UserDefaults.standard.removeObject(forKey: "scrollsUsedToday")
    UserDefaults.standard.removeObject(forKey: "purchasedScrolls")
    UserDefaults.standard.removeObject(forKey: "lastResetDate")
}
```

### 7. Testing Daily Reset

**Option 1 - Change System Time**:
1. Settings app (simulator) → General → Date & Time
2. Turn off "Set Automatically"
3. Set time to 11:59 PM
4. Use app, consume scrolls
5. Set time to 12:01 AM
6. Relaunch app → scrolls should reset

**Option 2 - Modify Code** (temporary):
```swift
// In ScrollBudgetManager.swift, change resetIfNewDay()
private func resetIfNewDay() {
    // Force reset every time for testing
    resetDailyData()
}
```

Remember to revert before committing!

---

## Building and Running

### Build Configurations

**Debug** (default):
- Includes debug symbols
- No optimization
- Faster builds
- Use for development

**Release**:
- Optimized code
- Smaller binary
- Slower builds
- Use for App Store submission

**To switch**:
Product → Scheme → Edit Scheme → Run → Build Configuration

### Running on Physical Device

1. **Connect iPhone** via USB
2. **Trust computer** on iPhone (popup)
3. **Select device** in Xcode toolbar
4. **Run** (Cmd+R)
5. **Trust developer** on iPhone:
   - Settings → General → VPN & Device Management
   - Tap your developer account → Trust

### Common Build Errors

**Error**: "No profiles for 'com.instep.app' were found"
- **Fix**: Set your Team in Signing & Capabilities

**Error**: "HealthKit is not available on the simulator"
- **Fix**: Health app IS available on modern simulators (iOS 16+)
- Make sure simulator is fully booted

**Error**: "Missing required entitlement"
- **Fix**: Ensure InStep.entitlements includes HealthKit capability
- Check Info.plist has HealthKit usage descriptions

**Error**: "Undefined symbol: Post"
- **Fix**: Ensure Post.swift is added to target membership
- Check project.pbxproj includes Post.swift in build files

---

## Testing Strategy

### Manual Testing Checklist

**First Launch**:
- [ ] Onboarding appears
- [ ] All 4 pages display correctly
- [ ] HealthKit permission prompt appears
- [ ] After granting, feed loads
- [ ] Scroll budget shows 0 scrolls (if 0 steps)

**With Steps**:
- [ ] Add 1000 steps in Health app
- [ ] Scroll budget updates to 5000
- [ ] Can scroll through feed
- [ ] Scrolls decrease as you scroll
- [ ] Progress bar updates
- [ ] Circular indicator updates

**Out of Scrolls**:
- [ ] Soft lock overlay appears
- [ ] "Walk More" button dismisses overlay
- [ ] "Purchase" button works (adds 100 scrolls temporarily)

**Daily Reset** (see testing instructions above):
- [ ] Scrolls reset at midnight
- [ ] Purchased scrolls reset
- [ ] Step count fetches fresh from HealthKit

### Unit Testing (Future)

Create `InStepTests/` directory with:

```swift
import XCTest
@testable import InStep

class ScrollBudgetManagerTests: XCTestCase {
    var manager: ScrollBudgetManager!

    override func setUp() {
        manager = ScrollBudgetManager()
    }

    func testStepConversion() {
        manager.updateStepCount(100)
        XCTAssertEqual(manager.totalScrollsAvailable, 500)
    }

    func testScrollConsumption() {
        manager.updateStepCount(100)
        manager.consumeScroll(amount: 10)
        XCTAssertEqual(manager.remainingScrolls, 490)
    }

    func testBudgetDepletion() {
        manager.updateStepCount(10) // 50 scrolls
        manager.consumeScroll(amount: 60)
        XCTAssertFalse(manager.hasScrollsRemaining)
    }
}
```

Run with Cmd+U

---

## Code Style Guidelines

### SwiftUI Best Practices

1. **View Composition**: Break large views into smaller components
   ```swift
   // Good
   struct FeedView: View {
       var body: some View {
           ScrollView {
               ForEach(posts) { post in
                   PostCardView(post: post)
               }
           }
       }
   }

   // Avoid: 200-line view body
   ```

2. **@EnvironmentObject**: Use for shared state
   ```swift
   @EnvironmentObject var healthKitManager: HealthKitManager
   // Not @ObservedObject in child views
   ```

3. **@Published Properties**: Use for observable state
   ```swift
   @Published var stepCount: Int = 0
   // UI auto-updates when this changes
   ```

4. **Computed Properties**: For derived values
   ```swift
   var remainingScrolls: Double {
       max(0, totalScrollsAvailable - scrollsUsed)
   }
   // Don't use @Published for computed properties
   ```

### Naming Conventions

- **Classes/Structs**: `PascalCase` (HealthKitManager, Post)
- **Variables/Functions**: `camelCase` (stepCount, fetchTodaySteps)
- **Constants**: `camelCase` (scrollsPerStep) or `SCREAMING_SNAKE_CASE` for globals
- **Files**: Match primary type name (HealthKitManager.swift)
- **Groups**: Plural (Managers/, Views/, Models/)

### Comments

```swift
// MARK: - Section Header (for large files)
// MARK: HealthKit Authorization

// TODO: Implement this feature
// TODO: Add error handling

// FIXME: This is a known issue
// FIXME: Scroll tracking fires too frequently

// NOTE: Important context
// NOTE: This value must match App Store Connect product ID
```

---

## Debugging Tips

### Xcode Console Filters

**Show only app logs**:
```
subsystem:com.instep.app
```

**Filter by keyword**:
```
scrolls
```

### Common Issues

**Issue**: "App crashes on launch"
- Check crash log in Xcode
- Look for `Thread 1: signal SIGABRT`
- Usually a force unwrap (`!`) on nil value

**Issue**: "Scroll budget not updating"
- Check HealthKit authorization: `print(healthKitManager.isAuthorized)`
- Verify steps are being fetched: Add print in `fetchTodaySteps()`
- Check `updateStepCount()` is called in ScrollBudgetView

**Issue**: "Purchases not working"
- StoreKit products must exist in App Store Connect
- Use StoreKit Configuration File for testing (File → New → StoreKit Configuration)
- Check sandbox account is signed in

### Memory Leaks

Use **Instruments** to detect:
1. Product → Profile (Cmd+I)
2. Choose "Leaks" template
3. Run app and interact
4. Check for memory leaks

**Common causes**:
- Strong reference cycles (use `[weak self]` in closures)
- Unused observers not removed

---

## Performance Optimization

### Current Performance

- **App Size**: ~2-3 MB (minimal)
- **Memory Usage**: ~50-100 MB (typical for SwiftUI)
- **Battery Impact**: Low (HealthKit queries are efficient)

### Potential Improvements

1. **Scroll Tracking Optimization**:
   - Currently updates on every scroll change
   - Could throttle to update every 50ms
   ```swift
   .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
       // Add debouncing here
   }
   ```

2. **Image Caching** (when adding Reddit):
   - Use `AsyncImage` with caching
   - Or integrate Kingfisher/SDWebImage

3. **Lazy Loading**:
   - Already using `LazyVStack` ✅
   - Consider pagination for 1000+ posts

4. **Background Refresh**:
   - HealthKit already uses background delivery ✅
   - Could optimize query frequency

---

## Deployment Preparation

### Pre-Submission Checklist

**Code**:
- [ ] Remove all `print()` statements (or use `#if DEBUG`)
- [ ] Remove TODOs from critical paths
- [ ] No force unwraps (`!`) in production code
- [ ] Error handling for all network/HealthKit calls

**Assets**:
- [ ] App icon (1024x1024px) added to Assets.xcassets
- [ ] All image assets are optimized (compressed)
- [ ] No placeholder images in production

**Configuration**:
- [ ] Bundle ID matches App Store Connect
- [ ] Version number incremented
- [ ] Build number incremented
- [ ] Deployment target set to iOS 16.0

**Testing**:
- [ ] Tested on multiple iPhone models
- [ ] Tested on iOS 16, 17, 18
- [ ] No crashes in 30-minute session
- [ ] HealthKit permission denial handled gracefully
- [ ] IAP flow tested in sandbox

**Legal**:
- [ ] Privacy policy URL in App Store Connect
- [ ] HealthKit usage description is clear and accurate
- [ ] Terms of Service (if applicable)

### Archiving for App Store

1. **Select "Any iOS Device"** in scheme selector
2. **Product → Archive** (Cmd+Shift+B won't work)
3. **Wait for build** (2-5 minutes)
4. **Organizer opens** → Select archive → "Distribute App"
5. **Choose "App Store Connect"**
6. **Upload**
7. **Wait for processing** (30 min - 2 hours)
8. **Submit for review** in App Store Connect

### TestFlight Distribution

1. **Archive as above**
2. **Upload to App Store Connect**
3. **Go to App Store Connect → TestFlight**
4. **Add internal testers** (up to 100)
5. **Add external testers** (up to 10,000, requires Beta App Review)
6. **Testers receive email** with TestFlight link

---

## Git Workflow

### Branch Strategy

**Main Branch**: `main`
- Always deployable
- Protected (require PR for changes)

**Feature Branches**: `feature/your-feature-name`
```bash
git checkout -b feature/reddit-integration
# Make changes
git commit -m "feat: add Reddit API client"
git push origin feature/reddit-integration
# Create PR on GitHub
```

**Hotfix Branches**: `hotfix/critical-bug`
```bash
git checkout -b hotfix/crash-on-zero-steps
# Fix bug
git commit -m "fix: handle zero steps edge case"
git push origin hotfix/crash-on-zero-steps
# Merge immediately after review
```

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add Reddit API integration
fix: prevent crash when HealthKit denied
docs: update README with new features
style: format code with SwiftLint
refactor: extract scroll tracking to separate class
test: add unit tests for ScrollBudgetManager
chore: update Xcode project settings
```

**Examples**:
- `feat: implement achievement system`
- `fix: scroll budget not resetting at midnight`
- `docs: add API integration guide to DEVELOPMENT.md`
- `refactor: move networking to separate layer`

---

## Useful Xcode Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd+R | Build and run |
| Cmd+B | Build only |
| Cmd+. | Stop running |
| Cmd+Shift+K | Clean build folder |
| Cmd+Shift+O | Open quickly (find file) |
| Cmd+/ | Toggle comment |
| Cmd+[ / Cmd+] | Decrease/increase indent |
| Cmd+Shift+F | Find in project |
| Cmd+Shift+L | Show library (SF Symbols, views) |
| Cmd+0 | Toggle navigator |
| Cmd+Opt+0 | Toggle inspector |

---

## Additional Resources

### Apple Documentation
- [HealthKit Framework](https://developer.apple.com/documentation/healthkit)
- [StoreKit 2](https://developer.apple.com/documentation/storekit)
- [SwiftUI](https://developer.apple.com/documentation/swiftui)
- [Combine](https://developer.apple.com/documentation/combine)

### Third-Party Tools
- [SF Symbols](https://developer.apple.com/sf-symbols/) - Icon library
- [SwiftLint](https://github.com/realm/SwiftLint) - Code style enforcer
- [Kingfisher](https://github.com/onevcat/Kingfisher) - Image caching (for future)

### Community
- [Swift Forums](https://forums.swift.org/)
- [r/iOSProgramming](https://reddit.com/r/iOSProgramming)
- [Hacking with Swift](https://www.hackingwithswift.com/)

---

## Getting Help

**Build Issues**: Check [Apple Developer Forums](https://developer.apple.com/forums/)
**HealthKit Issues**: Review [HealthKit documentation](https://developer.apple.com/documentation/healthkit)
**General Swift**: [Stack Overflow - iOS tag](https://stackoverflow.com/questions/tagged/ios)

**Internal Questions**: Update this document with solutions as you learn!

---

Last Updated: 2026-01-01
