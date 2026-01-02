import SwiftUI

@main
struct InStepApp: App {
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var scrollBudgetManager = ScrollBudgetManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager)
                .environmentObject(scrollBudgetManager)
                .onAppear {
                    healthKitManager.requestAuthorization()
                }
        }
    }
}
