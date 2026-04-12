import Foundation
import SwiftUI

/// Manages the overall state and coordination of multiplayer game
class MultiplayerGameManager: ObservableObject {
    @Published var gameMode: GameMode
    @Published var gameSimulation: GameSimulation
    @Published var teams: [TeamState] = []
    @Published var gameState: MultiplayerGameState = .setup
    @Published var gameTime: Double = 60.0
    @Published var remainingTime: Double = 60.0
    @Published var difficulty: GameDifficulty = .normal

    private var gameTimer: Timer?

    init(gameMode: GameMode, difficulty: GameDifficulty = .normal) {
        self.gameMode = gameMode
        self.difficulty = difficulty
        self.gameSimulation = GameSimulation(difficulty: difficulty)

        // Initialize teams
        let teamRed = TeamState(teamIdentifier: .red)
        let teamBlue = TeamState(teamIdentifier: .blue)
        self.teams = [teamRed, teamBlue]
    }

    func addPlayer(_ player: PlayerState) {
        if let team = teams.first(where: { $0.teamIdentifier == player.team }) {
            team.addMember(player)
        }
    }

    func startGame() {
        gameState = .playing
        remainingTime = gameTime
        gameSimulation.start()

        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            self?.updateGameTimer()
        }
    }

    func stopGame() {
        gameState = .gameOver
        gameSimulation.stop()
        gameTimer?.invalidate()
        gameTimer = nil

        // Update final team scores
        teams.forEach { $0.updateTotalScore() }
    }

    private func updateGameTimer() {
        remainingTime -= 0.016

        if remainingTime <= 0 {
            stopGame()
        }

        // Update collision detection and scoring
        updateCollisions()

        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    private func updateCollisions() {
        for team in teams {
            for player in team.members {
                var foodToRemove: [UUID] = []

                for food in gameSimulation.foodItems {
                    // Skip if already claimed or not in this player's zone
                    guard food.claimedBy == nil else { continue }

                    if isInPlayerZone(food: food, playerNumber: player.playerNumber) {
                        let duckHitbox = CGRect(
                            x: player.position.x - 30,
                            y: player.position.y - 30,
                            width: 60,
                            height: 60
                        )

                        if duckHitbox.intersects(food.hitbox()) {
                            player.addScore(food.type.points)
                            foodToRemove.append(food.id)
                        }
                    }
                }

                for foodID in foodToRemove {
                    gameSimulation.removeFood(gameSimulation.foodItems.first { $0.id == foodID }!)
                }
            }
        }
    }

    private func isInPlayerZone(food: FoodItem, playerNumber: Int) -> Bool {
        let screenWidth = UIScreen.main.bounds.width
        let zoneWidth = screenWidth / CGFloat(gameMode.playersPerTeam)
        let zoneIndex = playerNumber % gameMode.playersPerTeam
        let minX = CGFloat(zoneIndex) * zoneWidth
        let maxX = minX + zoneWidth

        return food.position.x >= minX && food.position.x <= maxX
    }

    func resetForNewGame() {
        teams.forEach { $0.resetForNewGame() }
        gameState = .setup
        remainingTime = gameTime
        gameSimulation.foodItems.removeAll()
    }

    var winningTeam: TeamState? {
        return teams.max(by: { $0.totalScore < $1.totalScore })
    }

    var isGameOver: Bool {
        gameState == .gameOver
    }
}

/// Game state for multiplayer
enum MultiplayerGameState {
    case setup
    case playing
    case gameOver
}
