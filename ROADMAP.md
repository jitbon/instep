# InStep Development Roadmap

## Project Status: MVP Complete ✅

**Current Version**: 1.0 (pre-release)
**Last Updated**: 2026-01-01

---

## Phase 1: MVP Foundation ✅ COMPLETE

### Core Features
- [x] HealthKit integration for step tracking
- [x] Scroll budget calculation (1 step = 5 scrolls)
- [x] Daily budget reset at midnight
- [x] Instagram-like feed UI with placeholder posts
- [x] Scroll tracking and enforcement
- [x] Soft lock overlay when out of scrolls
- [x] Visual scroll budget indicator
- [x] Onboarding flow with HealthKit permission
- [x] StoreKit 2 integration structure
- [x] Basic in-app purchase support

### Technical Infrastructure
- [x] SwiftUI app architecture
- [x] Manager layer (Health, ScrollBudget, Store)
- [x] Model layer (Post)
- [x] View layer (Feed, OnboardingPostCard, ScrollBudget)
- [x] UserDefaults persistence
- [x] Xcode project configuration
- [x] Entitlements and Info.plist setup
- [x] Documentation (README, ARCHITECTURE)

---

## Phase 2: App Store Ready 🚧 IN PROGRESS

### Must-Have for Launch

#### Design Assets
- [ ] Create app icon (1024x1024px)
  - Design concept: Footprint + scroll arrow
  - Color scheme: Blue gradient (matches app theme)
  - Required sizes: All iOS app icon sizes

- [ ] Generate screenshots
  - iPhone 6.9" (Pro Max)
  - iPhone 6.7" (Pro)
  - iPhone 6.5" (Plus)
  - iPhone 5.5"
  - Screenshots needed:
    1. Onboarding intro screen
    2. HealthKit permission request
    3. Main feed with scroll budget
    4. Out of scrolls overlay
    5. Purchase options screen

#### App Store Connect Setup
- [ ] Create app listing in App Store Connect
- [ ] Configure IAP products:
  - `com.instep.app.scrolls.100` - 100 Extra Scrolls - $0.99
  - `com.instep.app.scrolls.500` - 500 Extra Scrolls - $2.99
  - `com.instep.app.scrolls.1000` - 1000 Extra Scrolls - $4.99
- [ ] Write app description
- [ ] Add keywords for ASO
- [ ] Set content rating

#### Legal & Compliance
- [ ] Write privacy policy
  - Explain HealthKit data usage (steps only)
  - Data retention policy (local only)
  - No third-party sharing
  - Host on website or GitHub Pages
- [ ] Terms of Service
- [ ] Update Info.plist with privacy policy URL

#### Code Completion
- [ ] Connect FeedView purchase button to StoreManager
- [ ] Add product selection UI (show 3 price tiers)
- [ ] Implement purchase error handling
- [ ] Add loading states during purchase
- [ ] Test IAP in sandbox environment
- [ ] Add purchase restoration

#### Testing
- [ ] Test on iOS 16, 17, 18
- [ ] Test on various iPhone models
- [ ] Test HealthKit permission denial flow
- [ ] Test midnight daily reset
- [ ] Test IAP purchase flow
- [ ] Test with 0 steps, 1000 steps, 10000 steps
- [ ] Test scroll tracking accuracy
- [ ] Memory/performance testing

#### Polish
- [ ] Add haptic feedback when budget depletes
- [ ] Smooth animations for scroll budget updates
- [ ] Loading skeleton for posts
- [ ] Error state when HealthKit unavailable
- [ ] Empty state when 0 steps taken

**Target**: Submit to App Store by Q1 2026

---

## Phase 3: Social Media Integration 📱

### Reddit Integration (Recommended First)
- [ ] Add Reddit API client
- [ ] Implement subreddit selection
- [ ] Parse Reddit JSON responses
- [ ] Image loading and caching (Kingfisher or SDWebImage)
- [ ] Handle video posts (thumbnail only)
- [ ] Infinite scroll with pagination
- [ ] Pull-to-refresh
- [ ] Save favorite subreddits

**Why Reddit First**:
- No auth required for read-only access
- Open API with good documentation
- Variety of content types
- Large user base

### Twitter/X Integration (Optional)
- [ ] Twitter API v2 setup (requires paid tier)
- [ ] OAuth authentication flow
- [ ] Timeline fetching
- [ ] Media handling (images, videos)
- [ ] Rate limit handling

### Instagram Graph API (Challenging)
- [ ] Research current API limitations
- [ ] May not be possible (Instagram restricts third-party feeds)
- [ ] Alternative: Web scraping (violates TOS, not recommended)

**Deliverable**: v1.1 - Reddit feed integration

---

## Phase 4: Gamification & Engagement 🎮

### Achievements System
- [ ] Design achievement badges
- [ ] Define achievement criteria:
  - First 1000 steps
  - First 10,000 steps
  - 7-day streak
  - 30-day streak
  - 100,000 lifetime steps
  - Reach scroll limit (motivate walking)
  - Purchase scrolls (monetization)
- [ ] Achievement notification system
- [ ] Achievement gallery view

### Streak Tracking
- [ ] Daily step streak counter
- [ ] Streak milestone rewards (bonus scrolls?)
- [ ] Streak freeze option (1 rest day per week)
- [ ] Calendar view showing active days
- [ ] Push notifications for streak maintenance

### Statistics Dashboard
- [ ] Weekly step summary
- [ ] Monthly step trends
- [ ] Average scrolls per day
- [ ] Total distance walked (convert steps to miles/km)
- [ ] Charts using Swift Charts framework
- [ ] Export data to CSV

**Deliverable**: v1.2 - Gamification features

---

## Phase 5: Customization & Settings ⚙️

### Settings Screen
- [ ] Scroll-to-step ratio customization (3-10 scrolls per step)
- [ ] Notification preferences
  - Daily step reminder
  - Low scroll budget alert
  - Streak reminder
- [ ] Appearance settings (dark mode support)
- [ ] Data management
  - View purchase history
  - Reset tutorial
  - Delete all data
- [ ] About section (version, credits, support)

### Widget Support
- [ ] Home screen widget showing:
  - Today's steps
  - Remaining scrolls
  - Circular progress indicator
- [ ] Lock screen widget (iOS 16+)
- [ ] Multiple widget sizes (small, medium, large)

### Advanced Features
- [ ] Custom step goals (beyond scroll unlocking)
- [ ] Multiple feed sources (Reddit + Twitter)
- [ ] Content filters (SFW only, specific topics)
- [ ] Reading mode (disable scroll limits for educational content)
- [ ] Family sharing for IAP

**Deliverable**: v1.3 - Customization update

---

## Phase 6: Social Features 👥

### Friend System
- [ ] Add friends via username/email
- [ ] Share daily step count with friends
- [ ] Leaderboard (weekly step competition)
- [ ] Challenge friends to step goals
- [ ] Privacy controls (who can see your stats)

### Sharing
- [ ] Share achievement to social media
- [ ] Share interesting posts (with scroll budget watermark)
- [ ] Weekly recap story generator
- [ ] Referral system (both get bonus scrolls)

### Community
- [ ] In-app community feed (users share walking routes)
- [ ] Walking challenges (city-wide events)
- [ ] Integration with fitness apps (Strava, Nike Run Club)

**Deliverable**: v2.0 - Social features

---

## Phase 7: Apple Watch & Extensions ⌚

### Apple Watch App
- [ ] Complications showing steps/scrolls
- [ ] Quick glance at scroll budget
- [ ] Haptic notification when milestone reached
- [ ] Standalone step tracking (without iPhone)

### Shortcuts Support
- [ ] "Show scroll budget" shortcut
- [ ] "Log manual steps" shortcut
- [ ] Siri integration ("How many scrolls do I have left?")

### HealthKit Expansion
- [ ] Factor in other activities (cycling, swimming)
- [ ] Convert active calories to scrolls
- [ ] Bonus scrolls for hitting Apple Watch rings

**Deliverable**: v2.1 - Apple ecosystem expansion

---

## Phase 8: Monetization & Growth 💰

### Revenue Streams
- [x] IAP for extra scrolls (already implemented)
- [ ] Subscription tier:
  - $4.99/month or $39.99/year
  - Unlimited scrolls
  - Exclusive themes
  - Advanced statistics
  - Early access to features
  - Ad-free (if ads added)
- [ ] Partnerships with fitness brands
- [ ] Sponsored walking challenges

### Marketing
- [ ] App Store optimization (ASO)
- [ ] Social media presence (TikTok, Instagram)
- [ ] Influencer partnerships (fitness/wellness)
- [ ] Press kit and media outreach
- [ ] Blog content (benefits of walking, screen time management)

### Analytics
- [ ] App analytics (Firebase or AppsFlyer)
- [ ] User behavior tracking
- [ ] Conversion funnel analysis
- [ ] A/B testing framework
- [ ] Retention cohort analysis

**Deliverable**: v2.2 - Growth optimization

---

## Phase 9: Advanced Tech 🔬

### AI/ML Features
- [ ] Smart step prediction (forecast daily scrolls)
- [ ] Personalized content recommendation
- [ ] Walking route suggestions based on location
- [ ] Optimal walking time suggestions

### Accessibility
- [ ] VoiceOver optimization
- [ ] Dynamic Type support
- [ ] Reduce Motion support
- [ ] Alternative input methods (for users who can't walk)
  - Wheelchair pushes
  - Arm movements
  - Other exercise types

### Performance
- [ ] Implement advanced caching
- [ ] Optimize scroll tracking (reduce battery drain)
- [ ] Background app refresh optimization
- [ ] Reduce app size (asset compression)

**Deliverable**: v3.0 - AI-powered experience

---

## Long-Term Vision 🚀

### Potential Pivots
1. **B2B Version**: Enterprise wellness programs
   - Team step competitions
   - Admin dashboards
   - Corporate wellness integration

2. **Education Mode**:
   - Unlimited scrolls for educational content
   - Curated learning feeds
   - Student discount tier

3. **Parental Controls**:
   - Parents set scroll budgets for kids
   - Incentivize outdoor play
   - Screen time management tool

4. **Platform Expansion**:
   - Android version
   - iPad optimization
   - macOS app (track movement via Apple Watch)

---

## Technical Debt & Refactoring

### Code Quality
- [ ] Add comprehensive unit tests
  - ScrollBudgetManager logic
  - HealthKit manager
  - StoreManager purchase flow
- [ ] Add UI tests for critical paths
- [ ] Set up CI/CD pipeline (GitHub Actions)
- [ ] Code coverage >80%
- [ ] SwiftLint integration
- [ ] Documentation comments (DocC)

### Architecture Improvements
- [ ] Move to MVVM architecture (if complexity grows)
- [ ] Implement dependency injection
- [ ] Add network layer abstraction
- [ ] Implement proper error handling system
- [ ] Add logging framework (OSLog or third-party)

### Security
- [ ] Jailbreak detection
- [ ] Prevent HealthKit data tampering
- [ ] Secure IAP receipt validation
- [ ] API key management (for social media APIs)

---

## Feature Requests & Ideas Backlog

### Community Suggestions
- [ ] Dark mode themes (multiple color schemes)
- [ ] Export walking history
- [ ] Integration with music apps (play music while walking)
- [ ] Podcast recommendations for walking
- [ ] Walking meditation mode
- [ ] Pet avatar that grows with steps
- [ ] Virtual walking tours of cities
- [ ] Charity step donations (steps = donations)

---

## Success Metrics

### MVP Launch (Phase 2)
- 1,000 downloads in first month
- 20% DAU/MAU ratio
- 4.0+ App Store rating
- <2% crash rate
- 10% IAP conversion rate

### Growth Phase (Phase 3-6)
- 50,000 active users
- 30% DAU/MAU ratio
- Featured by Apple in Health & Fitness
- $5,000 MRR (monthly recurring revenue)
- 4.5+ App Store rating

### Scale Phase (Phase 7+)
- 500,000+ users
- Partnerships with major fitness brands
- Media coverage (TechCrunch, Verge, etc.)
- $50,000+ MRR
- International expansion (localization)

---

## Next Steps (Immediate)

**This Week**:
1. Design app icon
2. Create App Store Connect entry
3. Set up IAP products
4. Write privacy policy
5. Test app on physical device

**This Month**:
1. Complete IAP integration in FeedView
2. Generate all required screenshots
3. Submit for App Review
4. Set up social media accounts
5. Prepare launch marketing

**This Quarter**:
1. Launch v1.0 on App Store
2. Gather user feedback
3. Plan Reddit integration (v1.1)
4. Monitor analytics and iterate

---

## Resources Needed

### Design
- App icon designer (Fiverr, 99designs)
- Screenshot generator (Previewed.app, Screenshot.studio)
- Marketing materials (social media graphics)

### Legal
- Privacy policy generator (TermsFeed, iubenda)
- Legal review for IAP terms

### Development
- Apple Developer account ($99/year)
- App Store Connect access
- TestFlight for beta testing
- Analytics platform (Firebase - free tier)

### Marketing
- Website/landing page (optional)
- Social media presence
- Press kit materials

---

## Questions to Resolve

1. **IAP Pricing**: Are $0.99/$2.99/$4.99 the right price points?
2. **Social Media Priority**: Reddit first, or different platform?
3. **Monetization**: Free with IAP, or add premium subscription?
4. **Target Audience**: Fitness enthusiasts or screen time reducers?
5. **Geographic Launch**: US only or worldwide?
6. **Localization**: Which languages first after English?

---

## Version History (Planned)

- **v1.0** - MVP: HealthKit + simulated feed + IAP
- **v1.1** - Reddit integration
- **v1.2** - Gamification (achievements, streaks)
- **v1.3** - Customization & widgets
- **v2.0** - Social features (friends, challenges)
- **v2.1** - Apple Watch app
- **v2.2** - Growth optimization
- **v3.0** - AI-powered features

---

**Current Focus**: Complete Phase 2 for App Store launch

Track progress by moving items from ROADMAP.md to CHANGELOG.md as they're completed.
