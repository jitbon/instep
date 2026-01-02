import SwiftUI

struct FeedView: View {
    @EnvironmentObject var scrollBudgetManager: ScrollBudgetManager
    @State private var posts = Post.generateSamplePosts()
    @State private var scrollOffset: CGFloat = 0
    @State private var lastScrollOffset: CGFloat = 0
    @State private var showOutOfScrollsOverlay = false

    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(posts) { post in
                            PostCardView(post: post)
                                .id(post.id)
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear.preference(
                                            key: ScrollOffsetPreferenceKey.self,
                                            value: geometry.frame(in: .named("scroll")).minY
                                        )
                                    }
                                )
                        }

                        if !scrollBudgetManager.hasScrollsRemaining {
                            VStack(spacing: 16) {
                                Image(systemName: "figure.walk")
                                    .font(.system(size: 60))
                                    .foregroundColor(.secondary)

                                Text("You've reached your scroll limit!")
                                    .font(.headline)

                                Text("Walk more steps or purchase scrolls to continue")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(40)
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    let delta = lastScrollOffset - value
                    if abs(delta) > 1 {
                        let scrollDistance = abs(delta) / UIScreen.main.bounds.height

                        if scrollBudgetManager.hasScrollsRemaining {
                            scrollBudgetManager.consumeScroll(amount: scrollDistance)
                        } else if delta < 0 {
                            showOutOfScrollsOverlay = true
                        }
                    }
                    lastScrollOffset = value
                }
            }

            if showOutOfScrollsOverlay {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showOutOfScrollsOverlay = false
                    }

                VStack(spacing: 24) {
                    Image(systemName: "figure.walk.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)

                    VStack(spacing: 12) {
                        Text("Out of Scrolls!")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        Text("You've used all your scrolls for today")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    VStack(spacing: 12) {
                        Button {
                            showOutOfScrollsOverlay = false
                        } label: {
                            HStack {
                                Image(systemName: "figure.walk")
                                Text("Walk More Steps")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.gradient)
                            .cornerRadius(12)
                        }

                        Button {
                            purchaseScrolls()
                        } label: {
                            HStack {
                                Image(systemName: "cart.fill")
                                Text("Purchase Extra Scrolls")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.gradient)
                            .cornerRadius(12)
                        }
                    }

                    Button {
                        showOutOfScrollsOverlay = false
                    } label: {
                        Text("Close")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                )
                .padding(24)
            }
        }
    }

    private func purchaseScrolls() {
        scrollBudgetManager.purchaseScrolls(amount: 100)
        showOutOfScrollsOverlay = false
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
