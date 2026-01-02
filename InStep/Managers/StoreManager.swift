import Foundation
import StoreKit

class StoreManager: NSObject, ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()

    private let productIDs = [
        "com.instep.app.scrolls.100",
        "com.instep.app.scrolls.500",
        "com.instep.app.scrolls.1000"
    ]

    override init() {
        super.init()
        Task {
            await loadProducts()
        }
    }

    @MainActor
    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Int {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()

            let scrollAmount: Int
            switch product.id {
            case "com.instep.app.scrolls.100":
                scrollAmount = 100
            case "com.instep.app.scrolls.500":
                scrollAmount = 500
            case "com.instep.app.scrolls.1000":
                scrollAmount = 1000
            default:
                scrollAmount = 0
            }

            return scrollAmount

        case .userCancelled, .pending:
            return 0

        @unknown default:
            return 0
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
