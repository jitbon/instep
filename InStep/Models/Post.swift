import Foundation
import SwiftUI

struct Post: Identifiable {
    let id = UUID()
    let username: String
    let userAvatar: String
    let imageColor: Color
    let caption: String
    let likes: Int
    let timestamp: String

    static func generateSamplePosts() -> [Post] {
        let colors: [Color] = [.blue, .purple, .pink, .orange, .green, .red, .cyan, .indigo, .mint, .teal]
        let usernames = ["traveler_jane", "foodie_mike", "nature_lover", "fitness_guru", "art_enthusiast", "tech_wizard", "book_worm", "music_maestro", "adventure_seeker", "photo_ninja"]
        let captions = [
            "Living my best life! ✨",
            "Can't believe this view 🌅",
            "New adventures await 🚀",
            "Grateful for moments like these 🙏",
            "Making memories one step at a time 👣",
            "Chasing dreams and sunsets 🌇",
            "Good vibes only ☀️",
            "Life is beautiful 🌸",
            "Exploring the unknown 🗺️",
            "Stay positive, work hard, make it happen 💪"
        ]

        return (0..<100).map { index in
            Post(
                username: usernames[index % usernames.count],
                userAvatar: String(usernames[index % usernames.count].prefix(1)).uppercased(),
                imageColor: colors[index % colors.count],
                caption: captions[index % captions.count],
                likes: Int.random(in: 100...10000),
                timestamp: "\(Int.random(in: 1...24))h ago"
            )
        }
    }
}
