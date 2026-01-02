import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @Binding var isPresented: Bool

    @State private var currentPage = 0

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    icon: "figure.walk",
                    title: "Walk More, Scroll More",
                    description: "InStep limits your scrolling based on how many steps you take each day. The more you walk, the more you can scroll!",
                    color: .blue
                )
                .tag(0)

                OnboardingPageView(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "1 Step = 5 Scrolls",
                    description: "Every step you take earns you 5 screen heights of scrolling. Take 1,000 steps and unlock 5,000 scrolls worth of content!",
                    color: .green
                )
                .tag(1)

                OnboardingPageView(
                    icon: "heart.text.square.fill",
                    title: "Stay Active & Engaged",
                    description: "Balance your screen time with physical activity. Your health and your social media can coexist in harmony.",
                    color: .purple
                )
                .tag(2)

                VStack(spacing: 32) {
                    Image(systemName: "figure.walk.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.orange)

                    VStack(spacing: 16) {
                        Text("Allow Health Access")
                            .font(.system(size: 28, weight: .bold))

                        Text("InStep needs permission to read your step count from Apple Health to calculate your daily scroll budget.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    Button {
                        requestHealthKitPermission()
                    } label: {
                        Text("Enable Health Access")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange.gradient)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 32)

                    if healthKitManager.isAuthorized {
                        Button {
                            isPresented = false
                        } label: {
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.gradient)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 32)
                    }
                }
                .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            if currentPage < 3 {
                Button {
                    withAnimation {
                        if currentPage < 3 {
                            currentPage += 1
                        }
                    }
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.gradient)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
    }

    private func requestHealthKitPermission() {
        healthKitManager.requestAuthorization()
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 100))
                .foregroundColor(color)

            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
    }
}
