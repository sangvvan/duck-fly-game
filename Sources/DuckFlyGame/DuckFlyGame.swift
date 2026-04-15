import SwiftUI

@main
struct DuckFlyGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var gameState: GameScreenState = .mainMenu
    @StateObject var flowCoordinator = MultiplayerFlowCoordinator()
    @StateObject var levelProgress = LevelProgressManager()

    var body: some View {
        switch gameState {
        case .mainMenu:
            MainMenuView(gameState: $gameState)

        case .levelMap:
            LevelMapView(levelProgress: levelProgress, gameState: $gameState)

        case .menu, .playing, .gameOver:
            SoloGameView(levelProgress: levelProgress, gameState: $gameState)

        case .multiplayerSetup:
            MultiplayerSetupView(
                flowCoordinator: flowCoordinator,
                gameState: $gameState
            )

        case .multiplayerPlaying:
            if let gameManager = flowCoordinator.gameManager {
                MultiplayerGameView(gameManager: gameManager)
                    .ignoresSafeArea()
                    .onReceive(Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()) { _ in
                        if gameManager.isGameOver {
                            flowCoordinator.finishGame()
                            gameState = .multiplayerGameOver
                        }
                    }
            }

        case .multiplayerGameOver:
            MultiplayerGameOverView(flowCoordinator: flowCoordinator)
        }
    }
}

struct SoloGameView: View {
    @StateObject var gameManager = GameManager()
    @StateObject var progressionManager = RoundProgressionManager()
    @ObservedObject var levelProgress: LevelProgressManager
    @Binding var gameState: GameScreenState
    @State private var soloPhase: SoloPhase = .intro
    @State private var levelConfig: LevelConfig = LevelConfig.make(level: 1)

    enum SoloPhase {
        case intro
        case collecting
        case bossFighting
        case roundComplete
        case death
    }

    var body: some View {
        ZStack {
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            BackgroundScenery()
                .ignoresSafeArea()

            switch soloPhase {
            case .intro:
                BossRoundIntroView(round: levelConfig.theme, progressionManager: progressionManager)

            case .collecting:
                GameView(gameManager: gameManager)
                    .ignoresSafeArea()

            case .bossFighting:
                BossArenaView(progressionManager: progressionManager, round: levelConfig.theme)

            case .roundComplete:
                RoundCompleteView(
                    progressionManager: progressionManager,
                    round: levelConfig.theme
                ) {
                    levelProgress.markCompleted(level: levelProgress.currentLevel)
                    levelProgress.unlockNextLevel()
                    gameState = .levelMap
                }

            case .death:
                BossDeathView(progressionManager: progressionManager) {
                    gameState = .levelMap
                }
            }
        }
        .onAppear {
            configureForLevel(levelProgress.currentLevel)
        }
        .onChange(of: gameManager.foodCollectionComplete) { completed in
            if completed {
                // Transfer collected food to battle points
                progressionManager.foodBattlePoints = gameManager.foodCollected
                soloPhase = .bossFighting
            }
        }
        .onChange(of: progressionManager.playerHP) { hp in
            if hp <= 0 {
                soloPhase = .death
            }
        }
        .onChange(of: progressionManager.phase) { phase in
            switch phase {
            case .roundIntro:
                soloPhase = .intro
            case .collecting:
                soloPhase = .collecting
            case .bossFighting:
                soloPhase = .bossFighting
            case .roundComplete:
                soloPhase = .roundComplete
            case .gameOver, .bossDeathOptions:
                soloPhase = .death
            default:
                break
            }
        }
    }

    private func configureForLevel(_ levelNum: Int) {
        levelConfig = LevelConfig.make(level: levelNum)

        gameManager.foodTarget = levelConfig.foodTarget
        gameManager.foodCollected = 0
        gameManager.foodCollectionComplete = false
        gameManager.startGame(difficulty: .normal)

        progressionManager.startNewGame()
        progressionManager.currentRound = levelConfig.theme
        progressionManager.playerHP = progressionManager.duckStats.maxHP
        progressionManager.phase = .roundIntro
        progressionManager.bossState = BossState(
            round: levelConfig.theme,
            bossHP: levelConfig.bossHP,
            bossAttackDamage: levelConfig.bossAttackDamage
        )

        soloPhase = .intro
    }
}

struct MultiplayerSetupView: View {
    @ObservedObject var flowCoordinator: MultiplayerFlowCoordinator
    @Binding var gameState: GameScreenState

    var body: some View {
        ZStack {
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            switch flowCoordinator.currentStep {
            case .modeSelection:
                ModeSelectionView(flowCoordinator: flowCoordinator)

            case .difficultySelection:
                DifficultySelectionView(
                    selectedDifficulty: $flowCoordinator.selectedDifficulty,
                    onConfirm: { flowCoordinator.currentStep = .characterSelection }
                )

            case .characterSelection:
                CharacterSelectionView(flowCoordinator: flowCoordinator)

            case .teamLobby:
                TeamLobbyView(flowCoordinator: flowCoordinator)
                    .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                        if flowCoordinator.currentStep == .playing {
                            gameState = .multiplayerPlaying
                        }
                    }

            default:
                ModeSelectionView(flowCoordinator: flowCoordinator)
            }
        }
    }
}

struct DifficultySelectionView: View {
    @Binding var selectedDifficulty: GameDifficulty
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Select Difficulty")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .padding(.top, 32)

                VStack(spacing: 12) {
                    ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                        DifficultyButton(
                            difficulty: difficulty,
                            isSelected: selectedDifficulty == difficulty,
                            action: { selectedDifficulty = difficulty }
                        )
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                Button(action: onConfirm) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(.white)
                        .background(ColorTheme.primaryAction)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

struct DifficultyButton: View {
    let difficulty: GameDifficulty
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.label)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)

                    Text(difficulty.description)
                        .font(.system(size: 14))
                        .foregroundColor(ColorTheme.textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorTheme.success)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(ColorTheme.lightBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorTheme.success : ColorTheme.veryLightBackground, lineWidth: 2)
            )
        }
        .onTapGesture(perform: action)
    }
}

class GameManager: NSObject, ObservableObject {
    @Published var duckPosition = CGPoint(x: 100, y: 200)
    @Published var foodItems: [FoodItem] = []
    @Published var score = 0
    @Published var gameActive = false
    @Published var comboCount = 0
    @Published var gameTime: TimeInterval = 0
    @Published var foodCollected: Int = 0
    @Published var foodCollectionComplete: Bool = false

    private var displayLink: CADisplayLink?
    private var difficulty: GameDifficulty = .normal
    private var lastCollectionTime: TimeInterval = 0
    private var gameStartTime: TimeInterval = 0
    private let comboTimeout: TimeInterval = 1.5
    private let gameTimeLimit: TimeInterval = 60  // 60 second game
    var foodTarget: Int = 50

    // Physics
    private var duckVelocityY: CGFloat = 0
    private let gravity: CGFloat = 0.08  // Very slow fall (like Flappy Bird)
    private let jumpForce: CGFloat = -6  // Jump force
    private let duckWidth: CGFloat = 50
    private let duckHeight: CGFloat = 50

    // Game constants
    private let baseGameSpeed: CGFloat = 5
    private let collisionRadius: CGFloat = 40
    private let maxFoodOnScreen = 3
    private let foodStartY: CGFloat = -30
    private let foodEndSpacing: CGFloat = 50

    // Cached screen dimensions
    private let screenWidth = getScreenBounds().width
    private let screenHeight = getScreenBounds().height

    func startGame(difficulty: GameDifficulty) {
        self.difficulty = difficulty
        score = 0
        comboCount = 0
        gameTime = 0
        duckPosition = CGPoint(x: screenWidth / 2, y: screenHeight - 150)  // Start near bottom
        duckVelocityY = 0
        foodItems.removeAll()
        gameActive = true
        gameStartTime = Date().timeIntervalSince1970
        generateFood()
        startGameLoop()
    }

    func jumpDuck() {
        duckVelocityY = jumpForce
    }

    func resetGame() {
        stopGameLoop()
        score = 0
        comboCount = 0
        gameTime = 0
        foodItems.removeAll()
        gameActive = false
        foodCollected = 0
        foodCollectionComplete = false
    }

    func startGameLoop() {
        displayLink = CADisplayLink(
            target: self,
            selector: #selector(update)
        )
        displayLink?.add(to: .main, forMode: .common)
    }

    func stopGameLoop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func update() {
        guard gameActive else { return }

        // Update game time
        gameTime = Date().timeIntervalSince1970 - gameStartTime

        // Check time limit
        if gameTime >= gameTimeLimit {
            gameActive = false
            return
        }

        // Apply gravity to duck
        duckVelocityY += gravity
        duckPosition.y += duckVelocityY

        // Clamp duck to screen bounds (top and bottom)
        let duckRadius = duckWidth / 2
        if duckPosition.y < duckRadius {
            duckPosition.y = duckRadius
            duckVelocityY = 0
        }
        if duckPosition.y > screenHeight - duckRadius {
            duckPosition.y = screenHeight - duckRadius
            duckVelocityY = 0
            gameActive = false  // Duck hit ground = game over
        }

        // Clamp duck to screen width
        duckPosition.x = max(duckRadius, min(duckPosition.x, screenWidth - duckRadius))

        // Update food items and remove off-screen items
        for i in stride(from: foodItems.count - 1, through: 0, by: -1) {
            let speedAdjusted = baseGameSpeed * foodItems[i].type.speedModifier * difficulty.foodSpeedMultiplier
            foodItems[i].position.y += speedAdjusted

            if foodItems[i].position.y > screenHeight {
                foodItems.remove(at: i)
            }
        }

        // Check collisions
        for i in stride(from: foodItems.count - 1, through: 0, by: -1) {
            let distance = duckPosition.distance(to: foodItems[i].position)
            if distance < collisionRadius {
                let points = foodItems[i].type.points
                score += points
                foodCollected += 1

                // Check if food target reached
                if foodCollected >= foodTarget {
                    foodCollectionComplete = true
                }

                // Update combo
                let currentTime = Date().timeIntervalSince1970
                if currentTime - lastCollectionTime < comboTimeout {
                    comboCount += 1
                } else {
                    comboCount = 1
                }
                lastCollectionTime = currentTime

                // Haptic feedback
                HapticManager.shared.impact(.light)

                foodItems.remove(at: i)
            }
        }

        // Reset combo if timeout
        let currentTime = Date().timeIntervalSince1970
        if currentTime - lastCollectionTime > comboTimeout {
            comboCount = 0
        }

        // Maintain minimum food on screen
        while foodItems.count < maxFoodOnScreen {
            generateFood()
        }
    }

    private func generateFood() {
        let randomX = CGFloat.random(in: foodEndSpacing...(screenWidth - foodEndSpacing))
        let foodType = selectRandomFoodType()

        let food = FoodItem(
            id: UUID(),
            type: foodType,
            position: CGPoint(x: randomX, y: foodStartY),
            velocity: .zero,
            rotation: 0
        )
        foodItems.append(food)
    }

    private func selectRandomFoodType() -> FoodType {
        let rand = Double.random(in: 0...1)

        if rand < FoodType.corn.spawnWeight {
            return .corn
        } else if rand < FoodType.corn.spawnWeight + FoodType.berries.spawnWeight {
            return .berries
        } else {
            return .seeds
        }
    }

    func moveDuck(to position: CGPoint) {
        duckPosition = position
    }

    deinit {
        stopGameLoop()
    }
}

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    @StateObject private var popupManager = PointPopupManager()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Food items
                ForEach(gameManager.foodItems) { food in
                    FoodView(foodType: food.type)
                        .position(food.position)
                }

                // Duck
                DuckView()
                    .position(gameManager.duckPosition)

                // Particle effects
                ForEach(popupManager.popups) { popup in
                    PointPopupView(popup: popup)
                        .position(popup.position)
                }

                // Game HUD
                VStack {
                    GameHUD(
                        score: gameManager.score,
                        comboCount: gameManager.comboCount,
                        isComboActive: gameManager.comboCount > 0
                    )

                    Spacer()

                    // Timer at bottom
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 12))
                            Text(formatTime(gameManager.gameTime))
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(ColorTheme.textPrimary)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(ColorTheme.lightBackground)
                        )
                        .padding()
                    }
                }
                .zIndex(10)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                gameManager.jumpDuck()
            }
            .accessibilityElement(
                label: "Duck Fly Game",
                hint: "Tap to make duck fly"
            )
        }
    }

    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let remaining = max(0, 60 - timeInterval)
        let seconds = Int(remaining) % 60
        return String(format: "%02d", seconds)
    }
}

struct DuckView: View {
    var body: some View {
        DuckCharacter(size: 60)
    }
}

struct FoodView: View {
    let foodType: FoodType

    var body: some View {
        if #available(iOS 16.0, *) {
            FoodItemView(type: foodType)
        } else {
            // Fallback on earlier versions
        }
    }
}

private struct ContinuousHoverModifier: ViewModifier {
    let onHover: (CGPoint) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onContinuousHover { phase in
                if case .active(let location) = phase {
                    onHover(location)
                }
            }
        } else {
            content
        }
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

#Preview {
    ContentView()
}
