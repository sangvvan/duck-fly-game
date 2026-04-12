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
    @Published var shieldActive: Bool = false // Shield absorbs next miss

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

