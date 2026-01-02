import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var showOnboarding = true

    var body: some View {
        ZStack {
            if !showOnboarding && healthKitManager.isAuthorized {
                VStack(spacing: 0) {
                    ScrollBudgetView()

                    FeedView()
                }
            } else {
                OnboardingView(isPresented: $showOnboarding)
            }
        }
        .onAppear {
            if healthKitManager.isAuthorized {
                showOnboarding = false
            }
        }
        .onChange(of: healthKitManager.isAuthorized) { isAuthorized in
            if isAuthorized {
                showOnboarding = false
                healthKitManager.fetchTodaySteps()
            }
        }
    }
}
