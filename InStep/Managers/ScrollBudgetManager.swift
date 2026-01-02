import Foundation
import Combine

class ScrollBudgetManager: ObservableObject {
    @Published var totalScrollsAvailable: Double = 0
    @Published var scrollsUsed: Double = 0
    @Published var purchasedScrolls: Double = 0

    private let scrollsPerStep: Double = 5.0
    private let userDefaults = UserDefaults.standard
    private let scrollsUsedKey = "scrollsUsedToday"
    private let purchasedScrollsKey = "purchasedScrolls"
    private let lastResetDateKey = "lastResetDate"

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadData()
        resetIfNewDay()
    }

    var remainingScrolls: Double {
        max(0, totalScrollsAvailable - scrollsUsed)
    }

    var percentageUsed: Double {
        guard totalScrollsAvailable > 0 else { return 0 }
        return min(1.0, scrollsUsed / totalScrollsAvailable)
    }

    var hasScrollsRemaining: Bool {
        remainingScrolls > 0
    }

    func updateStepCount(_ steps: Int) {
        let baseScrolls = Double(steps) * scrollsPerStep
        totalScrollsAvailable = baseScrolls + purchasedScrolls
    }

    func consumeScroll(amount: Double = 1.0) {
        guard hasScrollsRemaining else { return }
        scrollsUsed = min(scrollsUsed + amount, totalScrollsAvailable)
        saveData()
    }

    func purchaseScrolls(amount: Double) {
        purchasedScrolls += amount
        totalScrollsAvailable += amount
        saveData()
    }

    private func resetIfNewDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastReset = userDefaults.object(forKey: lastResetDateKey) as? Date {
            let lastResetDay = calendar.startOfDay(for: lastReset)
            if today > lastResetDay {
                resetDailyData()
            }
        } else {
            resetDailyData()
        }
    }

    private func resetDailyData() {
        scrollsUsed = 0
        purchasedScrolls = 0
        totalScrollsAvailable = 0
        userDefaults.set(Date(), forKey: lastResetDateKey)
        saveData()
    }

    private func saveData() {
        userDefaults.set(scrollsUsed, forKey: scrollsUsedKey)
        userDefaults.set(purchasedScrolls, forKey: purchasedScrollsKey)
    }

    private func loadData() {
        scrollsUsed = userDefaults.double(forKey: scrollsUsedKey)
        purchasedScrolls = userDefaults.double(forKey: purchasedScrollsKey)
    }
}
