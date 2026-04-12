import SwiftUI

/// Team-based color scheme
struct TeamColorTheme {
    static func teamColor(_ team: TeamIdentifier) -> Color {
        switch team {
        case .red:
            return Color(red: 1.0, green: 0.282, blue: 0.341) // #FF4757
        case .blue:
            return Color(red: 0.267, green: 0.608, blue: 0.859) // #449BDB
        }
    }

    static func characterAccentColor(_ character: AnimalCharacter) -> Color {
        switch character {
        case .duck:
            return Color(red: 1.0, green: 0.702, blue: 0.290) // #FFB347 (Orange)
        case .bunny:
            return Color(red: 1.0, green: 0.529, blue: 0.808) // #FF87CF (Pink)
        case .fox:
            return Color(red: 1.0, green: 0.549, blue: 0.0) // #FF8C00 (Orange-Red)
        case .penguin:
            return Color(red: 0.2, green: 0.2, blue: 0.2) // #333333 (Dark Gray)
        case .squirrel:
            return Color(red: 0.545, green: 0.271, blue: 0.075) // #8B4513 (Brown)
        case .panda:
            return Color(red: 0.0, green: 0.0, blue: 0.0) // #000000 (Black)
        case .cat:
            return Color(red: 1.0, green: 0.843, blue: 0.0) // #FFD700 (Gold)
        case .frog:
            return Color(red: 0.184, green: 0.843, blue: 0.451) // #2ED573 (Green)
        }
    }

    static func gradientForTeam(_ team: TeamIdentifier) -> LinearGradient {
        let color = teamColor(team)
        return LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.1), color.opacity(0.05)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
