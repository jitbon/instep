import SwiftUI

struct PostCardView: View {
    let post: Post

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Circle()
                    .fill(post.imageColor.opacity(0.3))
                    .frame(width: 32, height: 32)
                    .overlay {
                        Text(post.userAvatar)
                            .font(.system(size: 14, weight: .semibold))
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text(post.username)
                        .font(.system(size: 14, weight: .semibold))
                    Text(post.timestamp)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "ellipsis")
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            Rectangle()
                .fill(post.imageColor.gradient)
                .aspectRatio(1.0, contentMode: .fit)
                .overlay {
                    VStack {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.5))
                        Text("Sample Post")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    Image(systemName: "heart")
                        .font(.system(size: 24))
                    Image(systemName: "message")
                        .font(.system(size: 24))
                    Image(systemName: "paperplane")
                        .font(.system(size: 24))

                    Spacer()

                    Image(systemName: "bookmark")
                        .font(.system(size: 24))
                }
                .foregroundColor(.primary)

                Text("\(post.likes.formatted()) likes")
                    .font(.system(size: 14, weight: .semibold))

                HStack(spacing: 4) {
                    Text(post.username)
                        .font(.system(size: 14, weight: .semibold))
                    Text(post.caption)
                        .font(.system(size: 14))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)

            Divider()
                .padding(.top, 8)
        }
    }
}
