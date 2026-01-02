import SwiftUI

struct ScrollBudgetView: View {
    @EnvironmentObject var scrollBudgetManager: ScrollBudgetManager
    @EnvironmentObject var healthKitManager: HealthKitManager

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 14))
                        Text("\(healthKitManager.stepCount) steps")
                            .font(.system(size: 14, weight: .semibold))
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 14))
                        Text("\(Int(scrollBudgetManager.remainingScrolls)) scrolls left")
                            .font(.system(size: 14, weight: .medium))
                    }
                }

                Spacer()

                CircularProgressView(progress: 1.0 - scrollBudgetManager.percentageUsed)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 4)

                    Rectangle()
                        .fill(scrollBudgetManager.hasScrollsRemaining ? Color.blue.gradient : Color.red.gradient)
                        .frame(width: geometry.size.width * (1.0 - scrollBudgetManager.percentageUsed), height: 4)
                }
            }
            .frame(height: 4)
            .padding(.horizontal, 16)
        }
        .onChange(of: healthKitManager.stepCount) { newValue in
            scrollBudgetManager.updateStepCount(newValue)
        }
    }
}

struct CircularProgressView: View {
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 4)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(progress > 0.3 ? Color.blue : Color.red, lineWidth: 4)
                .rotationEffect(.degrees(-90))

            Text("\(Int(progress * 100))%")
                .font(.system(size: 10, weight: .bold))
        }
        .frame(width: 44, height: 44)
    }
}
