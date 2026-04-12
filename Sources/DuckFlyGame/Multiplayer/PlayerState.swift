import Foundation
import SwiftUI

/// Represents the state of a single player in multiplayer game
class PlayerState: ObservableObject, Identifiable {
    let id: UUID
    let playerNumber: Int
    let team: TeamIdentifier
    let character: AnimalCharacter

    @Published var position: CGPoint = .zero
    @Published var score: Int = 0
    @Published var consecutiveCatches: Int = 0
    @Published var activePowerUp: ActivePowerUp? = nil

    init(
        playerNumber: Int,
        team: TeamIdentifier,
        character: AnimalCharacter
    ) {
        self.id = UUID()
        self.playerNumber = playerNumber
        self.team = team
        self.character = character
    }

    func resetForNewGame() {
        score = 0
        consecutiveCatches = 0
        activePowerUp = nil
        position = .zero
    }

    func addScore(_ points: Int) {
        let multiplier = activePowerUp?.scoreMultiplier ?? 1.0
        score += Int(Double(points) * multiplier)
        consecutiveCatches += 1
    }

    func resetCombo() {
        consecutiveCatches = 0
    }
}

/// Active power-up state for a player
struct ActivePowerUp {
    let type: PowerUpFoodType
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
}

/// Power-up food types for multiplayer
enum PowerUpFoodType {
    case speedBoost      // 5s, +60% speed
    case doublePoints    // 8s, 2x score multiplier
    case shield          // 10s, absorb one hit
    case starFood        // instant +100 pts

    var duration: Double {
        switch self {
        case .speedBoost:
            return 5.0
        case .doublePoints:
            return 8.0
        case .shield:
            return 10.0
        case .starFood:
            return 0.0 // instant
        }
    }

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
}
