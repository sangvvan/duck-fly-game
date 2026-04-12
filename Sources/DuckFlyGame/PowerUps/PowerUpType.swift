import SwiftUI

/// Power-up food types for multiplayer gameplay
enum PowerUpType: String, CaseIterable, Identifiable {
    case speedBoost
    case doublePoints
    case shield
    case starFood

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .speedBoost:
            return "Speed Boost"
        case .doublePoints:
            return "Double Points"
        case .shield:
            return "Shield"
        case .starFood:
            return "Star"
        }
    }

    var emoji: String {
        switch self {
        case .speedBoost:
            return "⚡"
        case .doublePoints:
            return "💪"
        case .shield:
            return "🛡"
        case .starFood:
            return "✨"
        }
    }

    var duration: TimeInterval {
        switch self {
        case .speedBoost:
            return 5.0
        case .doublePoints:
            return 8.0
        case .shield:
            return 10.0
        case .starFood:
            return 0.0 // Instant effect
        }
    }

    var bonusPoints: Int {
        switch self {
        case .speedBoost:
            return 0 // Speed doesn't grant points directly
        case .doublePoints:
            return 0 // Multiplier applied to collected food
        case .shield:
            return 0 // Defensive benefit
        case .starFood:
            return 100 // Instant 100 points
        }
    }

    var primaryColor: Color {
        switch self {
        case .speedBoost:
            return Color(red: 1.0, green: 0.843, blue: 0.0) // #FFD700 Yellow
        case .doublePoints:
            return Color(red: 1.0, green: 0.420, blue: 0.420) // #FF6B6B Red
        case .shield:
            return Color(red: 0.267, green: 0.608, blue: 0.859) // #449BDB Blue
        case .starFood:
            return Color(red: 1.0, green: 0.843, blue: 0.0) // #FFD700 Gold
        }
    }

    var size: CGFloat {
        switch self {
        case .speedBoost:
            return 36
        case .doublePoints:
            return 40
        case .shield:
            return 38
        case .starFood:
            return 44
        }
    }

    var spawnWeight: Double {
        switch self {
        case .speedBoost:
            return 0.25 // 25% of power-ups
        case .doublePoints:
            return 0.35 // 35%
        case .shield:
            return 0.25 // 25%
        case .starFood:
            return 0.15 // 15%
        }
    }

    /// Random power-up selection
    static func random() -> PowerUpType {
        let rand = Double.random(in: 0...1)
        var cumulative = 0.0

        for powerUp in PowerUpType.allCases {
            cumulative += powerUp.spawnWeight
            if rand <= cumulative {
                return powerUp
            }
        }

        return .starFood
    }

    var description: String {
        switch self {
        case .speedBoost:
            return "Move 60% faster for 5 seconds"
        case .doublePoints:
            return "All food worth 2x points for 8 seconds"
        case .shield:
            return "Absorb one missed catch for 10 seconds"
        case .starFood:
            return "Instant +100 points"
        }
    }
}

/// Active power-up state for a player
struct ActivePowerUp {
    let type: PowerUpType
    let startTime: Date

    var scoreMultiplier: Double {
        switch type {
        case .doublePoints:
            return 2.0
        default:
            return 1.0
        }
    }

    var isExpired: Bool {
        let elapsed = Date().timeIntervalSince(startTime)
        return elapsed > type.duration
    }

    var remainingTime: Double {
        let elapsed = Date().timeIntervalSince(startTime)
        let remaining = max(0, type.duration - elapsed)
        return remaining
    }

    var remainingPercentage: Double {
        guard type.duration > 0 else { return 0 }
        return max(0, min(1.0, remainingTime / type.duration))
    }
}
