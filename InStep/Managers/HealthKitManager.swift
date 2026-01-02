import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()

    @Published var stepCount: Int = 0
    @Published var isAuthorized: Bool = false
    @Published var authorizationError: String?

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            authorizationError = "Health data is not available on this device"
            return
        }

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        healthStore.requestAuthorization(toShare: [], read: [stepType]) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if let error = error {
                    self?.authorizationError = error.localizedDescription
                } else if success {
                    self?.fetchTodaySteps()
                    self?.observeStepCount()
                }
            }
        }
    }

    func fetchTodaySteps() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { [weak self] _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                DispatchQueue.main.async {
                    self?.stepCount = 0
                }
                return
            }

            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            DispatchQueue.main.async {
                self?.stepCount = steps
            }
        }

        healthStore.execute(query)
    }

    private func observeStepCount() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!

        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, _, error in
            if error == nil {
                self?.fetchTodaySteps()
            }
        }

        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { _, _ in }
    }
}
