# InStep Architecture Documentation

## Project Overview

InStep is a SwiftUI-based iOS application that gamifies physical activity by limiting social media scrolling based on daily step count. The core concept: **1 step = 5 scrolls**.

### Key Metrics
- **Scroll Conversion Rate**: 1 step = 5 screen heights
- **Target iOS Version**: 16.0+
- **Architecture**: SwiftUI + Combine
- **Data Persistence**: UserDefaults
- **External APIs**: HealthKit, StoreKit 2

---

## Architecture Layers

### 1. App Layer
**File**: `InStepApp.swift`

Entry point that initializes and provides app-wide state management.

```swift
@StateObject private var healthKitManager = HealthKitManager()
@StateObject private var scrollBudgetManager = ScrollBudgetManager()
```

**Responsibilities**:
- Initialize managers as `@StateObject`
- Inject managers into environment
- Request HealthKit authorization on app launch

---

### 2. Manager Layer

#### HealthKitManager
**File**: `InStep/Managers/HealthKitManager.swift`

Handles all HealthKit interactions.

**Published Properties**:
- `stepCount: Int` - Current day's step count
- `isAuthorized: Bool` - HealthKit permission status
- `authorizationError: String?` - Error messages

**Key Methods**:
- `requestAuthorization()` - Request HealthKit permissions
- `fetchTodaySteps()` - Query today's cumulative steps
- `observeStepCount()` - Set up real-time step updates via HKObserverQuery

**Implementation Details**:
- Uses `HKStatisticsQuery` for cumulative step count
- Queries from start of day to now
- Background delivery enabled for real-time updates
- All UI updates dispatched to main thread

---

#### ScrollBudgetManager
**File**: `InStep/Managers/ScrollBudgetManager.swift`

Core business logic for scroll budget calculation and tracking.

**Published Properties**:
- `totalScrollsAvailable: Double` - Total scrolls from steps + purchases
- `scrollsUsed: Double` - Scrolls consumed today
- `purchasedScrolls: Double` - Extra scrolls bought via IAP

**Constants**:
- `scrollsPerStep: Double = 5.0` - Conversion rate

**Computed Properties**:
- `remainingScrolls: Double` - Available scrolls left
- `percentageUsed: Double` - Progress from 0.0 to 1.0
- `hasScrollsRemaining: Bool` - Whether user can still scroll

**Key Methods**:
- `updateStepCount(_ steps: Int)` - Convert steps to scrolls
- `consumeScroll(amount: Double)` - Deduct from budget
- `purchaseScrolls(amount: Double)` - Add purchased scrolls
- `resetIfNewDay()` - Auto-reset at midnight

**Persistence Keys**:
- `scrollsUsedKey`: "scrollsUsedToday"
- `purchasedScrollsKey`: "purchasedScrolls"
- `lastResetDateKey`: "lastResetDate"

**Daily Reset Logic**:
- Compares current date with `lastResetDate`
- If new day detected, resets `scrollsUsed` and `purchasedScrolls`
- Preserves step count (fetched fresh from HealthKit)

---

#### StoreManager
**File**: `InStep/Managers/StoreManager.swift`

Handles in-app purchases using StoreKit 2.

**Published Properties**:
- `products: [Product]` - Available IAP products
- `purchasedProductIDs: Set<String>` - Purchased product tracking

**Product IDs**:
- `com.instep.app.scrolls.100` → 100 scrolls
- `com.instep.app.scrolls.500` → 500 scrolls
- `com.instep.app.scrolls.1000` → 1000 scrolls

**Key Methods**:
- `loadProducts()` - Fetch products from App Store
- `purchase(_ product: Product) async throws -> Int` - Process purchase and return scroll amount
- `checkVerified()` - Verify transaction authenticity

**Note**: Products must be created in App Store Connect before IAP will work.

---

### 3. Model Layer

#### Post
**File**: `InStep/Models/Post.swift`

Represents a social media post in the feed.

**Properties**:
- `id: UUID` - Unique identifier
- `username: String` - Display name
- `userAvatar: String` - Avatar letter/emoji
- `imageColor: Color` - Placeholder gradient color
- `caption: String` - Post caption
- `likes: Int` - Like count
- `timestamp: String` - Relative time (e.g., "3h ago")

**Static Method**:
- `generateSamplePosts() -> [Post]` - Creates 100 simulated posts with varied content

**Current Implementation**: Generates placeholder posts with random colors and captions. Ready for future integration with real social media APIs.

---

### 4. View Layer

#### ContentView
**File**: `InStep/ContentView.swift`

Root view that orchestrates onboarding vs. main app flow.

**State**:
- `showOnboarding: Bool` - Controls onboarding visibility

**Logic**:
- Shows `OnboardingView` if not authorized
- Shows main feed (`ScrollBudgetView` + `FeedView`) after authorization
- Listens to `healthKitManager.isAuthorized` changes

---

#### OnboardingView
**File**: `InStep/Views/OnboardingView.swift`

4-page onboarding experience with HealthKit permission request.

**Pages**:
1. **Walk More, Scroll More** - Intro to concept
2. **1 Step = 5 Scrolls** - Explain conversion rate
3. **Stay Active & Engaged** - Value proposition
4. **Health Access** - Permission request with CTA button

**Features**:
- TabView with page indicator
- Continue button for pages 1-3
- "Enable Health Access" button on page 4
- "Get Started" button appears after authorization

---

#### FeedView
**File**: `InStep/Views/FeedView.swift`

Main scrollable feed with scroll tracking and limiting.

**Key Features**:
1. **Scroll Tracking**: Uses `GeometryReader` + `PreferenceKey` to measure scroll offset
2. **Budget Consumption**: Converts scroll distance to screen heights and deducts from budget
3. **Hard Stop**: Shows end-of-feed message when budget exhausted
4. **Soft Lock Overlay**: Modal overlay when user tries to scroll beyond budget

**Scroll Tracking Implementation**:
```swift
.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
    let delta = lastScrollOffset - value
    let scrollDistance = abs(delta) / UIScreen.main.bounds.height
    scrollBudgetManager.consumeScroll(amount: scrollDistance)
}
```

**Overlay Actions**:
- "Walk More Steps" - Dismisses overlay
- "Purchase Extra Scrolls" - Triggers IAP (currently adds 100 scrolls directly)
- "Close" - Dismisses overlay

**TODO**: Integrate StoreManager for real IAP flow.

---

#### PostCardView
**File**: `InStep/Views/PostCardView.swift`

Individual post card component styled like Instagram.

**Layout**:
- Header: Avatar circle + username + timestamp + menu
- Image: Gradient rectangle with icon (placeholder for real images)
- Actions: Like, comment, share, bookmark buttons
- Footer: Like count + username + caption

**Styling**: Matches iOS native social media apps with SF Symbols for icons.

---

#### ScrollBudgetView
**File**: `InStep/Views/ScrollBudgetView.swift`

Persistent header showing scroll budget status.

**Components**:
1. **Step Count Display**: Shows current steps with walk icon
2. **Remaining Scrolls**: Shows scrolls left with icon
3. **Circular Progress**: Percentage remaining (blue > 30%, red ≤ 30%)
4. **Progress Bar**: Linear bar showing budget consumption

**Updates**:
- Automatically updates when `healthKitManager.stepCount` changes
- Calls `scrollBudgetManager.updateStepCount()` to recalculate budget

---

## Data Flow

### Step Count → Scroll Budget Flow

```
1. HealthKitManager fetches steps from HealthKit
   └─> stepCount published property updates

2. ScrollBudgetView observes stepCount change
   └─> Calls scrollBudgetManager.updateStepCount(steps)

3. ScrollBudgetManager calculates scrolls
   └─> totalScrollsAvailable = (steps × 5.0) + purchasedScrolls

4. UI updates automatically via @Published properties
   └─> ScrollBudgetView, FeedView reflect new budget
```

### Scroll Consumption Flow

```
1. User scrolls in FeedView
   └─> GeometryReader measures scroll offset change

2. Convert pixels to screen heights
   └─> scrollDistance = abs(delta) / UIScreen.main.bounds.height

3. Deduct from budget
   └─> scrollBudgetManager.consumeScroll(amount: scrollDistance)

4. If budget exhausted
   └─> Show soft lock overlay with purchase option
```

### Daily Reset Flow

```
1. ScrollBudgetManager.init() calls resetIfNewDay()

2. Compare today vs. lastResetDate
   └─> If new day detected:
       - scrollsUsed = 0
       - purchasedScrolls = 0
       - Save new lastResetDate

3. HealthKit re-fetches today's steps
   └─> Budget recalculates from fresh step count
```

---

## Configuration Files

### Info.plist
**File**: `InStep/Info.plist`

**Required Keys**:
- `NSHealthShareUsageDescription`: "InStep needs access to your step count to calculate your daily scroll budget. Walk more, scroll more!"
- `NSHealthUpdateUsageDescription`: "InStep needs to update your health data."

### InStep.entitlements
**File**: `InStep/InStep.entitlements`

**Capabilities**:
- `com.apple.developer.healthkit`: true
- `com.apple.developer.healthkit.access`: ["health-records"]
- `com.apple.developer.in-app-payments`: ["merchant.com.instep.app"]

---

## Build Configuration

### Target Settings
- **Bundle Identifier**: `com.instep.app`
- **Deployment Target**: iOS 16.0
- **Supported Platforms**: iPhone only (portrait)
- **Swift Version**: 5.0

### Frameworks
- SwiftUI (UI framework)
- Combine (reactive programming)
- HealthKit (step tracking)
- StoreKit (in-app purchases)

---

## Current State

### ✅ Implemented Features

1. **HealthKit Integration**
   - Step count fetching
   - Real-time updates
   - Permission handling
   - Background delivery

2. **Scroll Budget System**
   - 1 step = 5 scrolls conversion
   - Budget tracking
   - Daily auto-reset
   - Persistence

3. **Feed Experience**
   - Instagram-like UI
   - 100 sample posts
   - Scroll tracking
   - Budget enforcement

4. **Visual Feedback**
   - Scroll budget header
   - Progress indicators
   - Soft lock overlay

5. **Onboarding**
   - 4-page walkthrough
   - Permission request
   - Smooth UX flow

6. **In-App Purchases**
   - StoreManager structure
   - Product definitions
   - Purchase flow skeleton

---

## 🚧 Not Yet Implemented

### High Priority

1. **Full IAP Integration**
   - Connect FeedView purchase button to StoreManager
   - Add product selection UI (100/500/1000 options)
   - Handle purchase errors and loading states
   - Verify App Store Connect product setup

2. **App Store Assets**
   - App icon (1024x1024px)
   - Screenshots for all device sizes
   - Privacy policy URL
   - App Store description

3. **Testing**
   - Unit tests for ScrollBudgetManager
   - UI tests for critical flows
   - HealthKit permission edge cases
   - Daily reset boundary testing

### Medium Priority

4. **Real Social Media Integration**
   - Reddit API integration (open API, no auth needed)
   - Replace Post.generateSamplePosts() with API calls
   - Image loading and caching
   - Infinite scroll with pagination

5. **Enhanced UX**
   - Pull-to-refresh
   - Haptic feedback on budget depletion
   - Animations for scroll budget updates
   - Empty state when no steps

6. **Settings Screen**
   - Customize scroll-per-step ratio
   - Toggle notifications
   - View purchase history
   - Reset tutorial option

### Low Priority

7. **Advanced Features**
   - Daily streak tracking
   - Achievement badges
   - Widget showing scroll budget
   - Apple Watch companion
   - Share to social media
   - Weekly/monthly statistics

---

## Known Issues & Considerations

### Technical Debt

1. **FeedView IAP**: Currently `purchaseScrolls()` directly adds 100 scrolls without actual StoreKit flow
2. **No Error Handling**: Network errors, HealthKit failures not gracefully handled
3. **Hard-coded Values**: Scroll conversion rate (5.0) should be configurable
4. **Memory**: 100 posts loaded at once, could use lazy loading for larger feeds

### Edge Cases

1. **Midnight Transition**: User actively scrolling during midnight reset
2. **HealthKit Denial**: What if user denies permission after onboarding?
3. **Negative Steps**: HealthKit corrections could theoretically reduce step count
4. **Purchase Restoration**: Need to handle restoring previous purchases

### Performance

1. **Scroll Tracking**: GeometryReader updates frequently, could optimize
2. **Image Loading**: Placeholder colors are fine, but real images need caching
3. **HealthKit Queries**: Currently query on every app launch, could cache

---

## Development Guidelines

### Adding New Features

1. **New Manager**: Create in `Managers/`, use `ObservableObject` + `@Published`
2. **New View**: Create in `Views/`, inject managers via `@EnvironmentObject`
3. **New Model**: Create in `Models/`, make `Identifiable` if used in lists

### Modifying Scroll Conversion

To change the 1 step = X scrolls ratio:
1. Edit `ScrollBudgetManager.scrollsPerStep`
2. Update documentation in README.md
3. Update onboarding text in OnboardingView.swift

### Testing Changes

1. **Simulator**: Add steps via Health app → Browse → Activity → Steps → Add Data
2. **Device**: Walk around, or use Health app to add test data
3. **Reset**: Delete app to clear UserDefaults and test fresh install

---

## API Integration Guide (Future)

### Reddit Integration Example

When implementing real social media:

```swift
// In Post.swift
static func fetchRedditPosts(subreddit: String) async -> [Post] {
    let url = URL(string: "https://www.reddit.com/r/\(subreddit)/hot.json")!
    let (data, _) = try await URLSession.shared.data(from: url)
    let json = try JSONDecoder().decode(RedditResponse.self, from: data)

    return json.data.children.map { child in
        Post(
            username: child.data.author,
            userAvatar: String(child.data.author.prefix(1)),
            imageUrl: child.data.thumbnail,
            caption: child.data.title,
            likes: child.data.ups,
            timestamp: formatTimestamp(child.data.created_utc)
        )
    }
}
```

Replace `Post.generateSamplePosts()` calls in FeedView with async Reddit fetch.

---

## Deployment Checklist

Before App Store submission:

- [ ] Add app icon assets
- [ ] Create App Store Connect entry
- [ ] Set up IAP products (100/500/1000 scrolls)
- [ ] Write and host privacy policy
- [ ] Add App Store screenshots
- [ ] Test on multiple iOS versions
- [ ] Test IAP in sandbox environment
- [ ] Submit for App Review
- [ ] Prepare app review notes explaining step-to-scroll mechanic

---

## Contact & Contribution

This is a v1.0 MVP. Future versions should focus on:
1. Real social media integration
2. Advanced gamification (streaks, achievements)
3. Social features (share with friends)
4. Analytics and insights

Maintain this architecture doc when adding major features.
