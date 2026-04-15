import Foundation

/// Coordinates the flow of multiplayer setup (mode selection → character selection → game)
class MultiplayerFlowCoordinator: ObservableObject {
    @Published var currentStep: SetupStep = .modeSelection
    @Published var selectedMode: GameMode? = nil
    @Published var selectedDifficulty: GameDifficulty = .normal
    @Published var playerSelections: [Int: AnimalCharacter] = [:] // playerNumber -> character
    @Published var gameManager: MultiplayerGameManager? = nil

    enum SetupStep {
        case modeSelection
        case difficultySelection
        case characterSelection
        case teamLobby
        case playing
        case gameOver
    }

    func selectMode(_ mode: GameMode) {
        selectedMode = mode
        currentStep = .difficultySelection
    }

    func selectDifficulty(_ difficulty: GameDifficulty) {
        selectedDifficulty = difficulty
        currentStep = .characterSelection
        playerSelections = [:]
    }

    func selectCharacterForPlayer(_ playerNumber: Int, character: AnimalCharacter) {
        playerSelections[playerNumber] = character

        // Check if all players have selected characters
        let expectedCount = selectedMode?.playerCount ?? 0
        if playerSelections.count == expectedCount {
            currentStep = .teamLobby
        }
    }

    func startGame() {
        guard let mode = selectedMode else { return }

        let gameManager = MultiplayerGameManager(gameMode: mode, difficulty: selectedDifficulty)
        self.gameManager = gameManager

        // Assign players to teams and characters
        var playerNumber = 0
        for teamIndex in 0..<2 {
            let _ = gameManager.teams[teamIndex]
            let teamIdentifier: TeamIdentifier = teamIndex == 0 ? .red : .blue

            for _ in 0..<mode.playersPerTeam {
                if let character = playerSelections[playerNumber] {
                    let player = PlayerState(
                        playerNumber: playerNumber,
                        team: teamIdentifier,
                        character: character
                    )
                    gameManager.addPlayer(player)
                }
                playerNumber += 1
            }
        }

        gameManager.startGame()
        currentStep = .playing
    }

    func finishGame() {
        currentStep = .gameOver
    }

    func playAgain() {
        gameManager?.resetForNewGame()
        gameManager?.startGame()
        currentStep = .playing
    }

    func returnToMainMenu() {
        currentStep = .modeSelection
        selectedMode = nil
        selectedDifficulty = .normal
        playerSelections = [:]
        gameManager = nil
    }
}
