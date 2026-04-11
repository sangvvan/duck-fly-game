import SwiftUI

/// Game difficulty levels
enum GameDifficulty: String, CaseIterable {
    case easy
    case normal
    case hard

    var label: String {
        switch self {
        case .easy: return "Easy"
        case .normal: return "Normal"
        case .hard: return "Hard"
        }
    }

    var description: String {
        switch self {
        case .easy: return "Slower food, larger hitbox"
        case .normal: return "Standard gameplay"
        case .hard: return "Faster food, smaller hitbox"
        }
    }

    var foodSpeedMultiplier: CGFloat {
        switch self {
        case .easy: return 0.7
        case .normal: return 1.0
        case .hard: return 1.3
        }
    }
}

/// Overall game state
enum GameScreenState {
    case menu
    case playing
    case gameOver
}
