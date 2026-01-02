# InStep

Walk more, scroll more. InStep is an iOS app that limits your social media scrolling based on your daily step count.

## Concept

InStep gamifies physical activity by converting your steps into scrolling credits:
- **1 step = 5 scrolls** (approximately 5 screen heights of content)
- Walk 1,000 steps = Unlock 5,000 scrolls
- Out of scrolls? Take a walk or purchase extra scrolls!

## Features

- **HealthKit Integration**: Tracks your daily steps from Apple Health
- **Scroll Budget System**: Converts steps to scrolling credits (1 step = 5 scrolls)
- **Instagram-like Feed**: Simulated social media feed with placeholder posts
- **Soft Lock**: When out of scrolls, users can purchase extra credits
- **Visual Progress**: Real-time scroll budget indicator showing remaining scrolls
- **Onboarding**: Smooth onboarding flow to request HealthKit permissions

## Project Structure

```
InStep/
├── InStepApp.swift          # App entry point
├── ContentView.swift        # Main view with onboarding logic
├── Info.plist              # HealthKit permissions & configuration
├── InStep.entitlements     # HealthKit & IAP capabilities
├── Managers/
│   ├── HealthKitManager.swift       # Step tracking from Apple Health
│   ├── ScrollBudgetManager.swift    # Scroll budget calculations
│   └── StoreManager.swift          # In-app purchase handling
├── Models/
│   └── Post.swift                  # Post model & sample data
└── Views/
    ├── FeedView.swift              # Main scrollable feed
    ├── PostCardView.swift          # Individual post card
    ├── ScrollBudgetView.swift      # Budget indicator UI
    └── OnboardingView.swift        # Permission onboarding
```

## Setup Instructions

### Prerequisites
- macOS with Xcode 15.0+
- iOS 16.0+ device or simulator
- Apple Developer account (for App Store deployment)

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd instep
```

2. Open the project in Xcode:
```bash
open InStep.xcodeproj
```

3. Configure your development team:
   - Select the InStep project in Xcode
   - Go to "Signing & Capabilities"
   - Select your Team from the dropdown

4. Enable HealthKit capability:
   - The project already includes HealthKit entitlements
   - Make sure your provisioning profile supports HealthKit

5. Build and run:
   - Select your target device or simulator
   - Press Cmd+R to build and run

### Testing on Simulator

The iOS Simulator can simulate step data for testing:
1. Open the Health app in simulator
2. Go to Browse > Activity > Steps
3. Tap "Add Data" to manually add step counts
4. Return to InStep to see your scroll budget update

### Testing on Device

For real step tracking, deploy to a physical iPhone:
1. Connect your iPhone via USB
2. Select it as the run destination in Xcode
3. Build and run (you may need to trust the developer certificate in Settings)
4. Grant HealthKit permissions when prompted
5. Walk around and watch your scroll budget increase!

## App Store Deployment Checklist

Before submitting to the App Store:

1. **App Icon**: Add app icon images to `Assets.xcassets/AppIcon.appiconset/`
   - Required: 1024x1024px PNG

2. **Bundle Identifier**: Update in Xcode project settings
   - Default: `com.instep.app`
   - Change to your unique identifier

3. **Development Team**: Set your Apple Developer team in Signing & Capabilities

4. **In-App Purchase Setup**:
   - Create products in App Store Connect:
     - `com.instep.app.scrolls.100` - 100 extra scrolls
     - `com.instep.app.scrolls.500` - 500 extra scrolls
     - `com.instep.app.scrolls.1000` - 1000 extra scrolls

5. **Privacy Policy**: Create and host a privacy policy URL
   - Required for HealthKit apps
   - Explain what health data you collect (step count only)

6. **Screenshots**: Prepare app screenshots for all required device sizes

7. **App Review Notes**:
   - Explain the step-to-scroll conversion mechanic
   - Provide test account if needed
   - Note that simulator testing requires manual Health data entry

## Scroll Calculation Logic

```swift
// Conversion rate
scrollsPerStep = 5.0

// Example calculation
steps = 1000
totalScrolls = steps * scrollsPerStep  // 5000 scrolls
```

Each "scroll" represents approximately one screen height of content. Based on:
- Average step: ~2.5 feet (0.76m)
- Phone screen: ~6 inches (0.15m)
- Ratio: ~5 screen heights per step

## Future Enhancements

- [ ] Actual social media API integration (Reddit, Twitter)
- [ ] Daily streak tracking
- [ ] Achievement system
- [ ] Share progress with friends
- [ ] Customizable step-to-scroll ratio
- [ ] Widget showing today's scroll budget
- [ ] Apple Watch companion app

## Technical Notes

- **Minimum iOS**: 16.0
- **SwiftUI**: Native SwiftUI app, no UIKit
- **HealthKit**: Requires physical device or simulator with Health app
- **StoreKit 2**: Modern in-app purchase implementation
- **Data Persistence**: UserDefaults for scroll usage tracking
- **Daily Reset**: Automatically resets scroll budget at midnight

## License

See [LICENSE](LICENSE) file for details.

## Support

For issues or questions, please open an issue on GitHub
