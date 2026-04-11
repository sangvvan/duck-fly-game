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
    @StateObject var gameManager = GameManager()
    @State private var gameState: GameScreenState = .menu
    @State private var selectedDifficulty: GameDifficulty = .normal

    var body: some View {
        ZStack {
            // Sky gradient background
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            // Animated background scenery
            BackgroundScenery()
                .ignoresSafeArea()

            // Content based on game state
            switch gameState {
            case .menu:
                StartMenuView(gameState: $gameState, selectedDifficulty: $selectedDifficulty)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))

            case .playing:
                GameView(gameManager: gameManager)
                    .ignoresSafeArea()
                    .transition(.opacity)

            case .gameOver:
                GameOverView(score: gameManager.score) {
                    HapticManager.shared.selection()
                    gameState = .menu
                    gameManager.resetGame()
                }
                .transition(.opacity.combined(with: .scale(scale: 1.05)))
            }
        }
        .onAppear {
            ColorTheme.verifyAccessibility()
            HapticManager.shared.notification(.Success)
        }
        .onChange(of: gameState) { newState in
            if newState == .playing {
                gameManager.startGame(difficulty: selectedDifficulty)
                HapticManager.shared.impact(.light)
            }
        }
        .onChange(of: gameManager.gameActive) { isActive in
            if !isActive && gameState == .playing {
                HapticManager.shared.notification(.Warning)
                gameState = .gameOver
            }
        }
    }
}

class GameManager: ObservableObject {
    @Published var duckPosition = CGPoint(x: 100, y: 200)
    @Published var foodItems: [FoodItem] = []
    @Published var score = 0
    @Published var gameActive = false
    @Published var comboCount = 0
    @Published var gameTime: TimeInterval = 0

    private var displayLink: CADisplayLink?
    private var difficulty: GameDifficulty = .normal
    private var lastCollectionTime: TimeInterval = 0
    private var gameStartTime: TimeInterval = 0
    private let comboTimeout: TimeInterval = 1.5
    private let gameTimeLimit: TimeInterval = 60  // 60 second game

    // Game constants
    private let baseGameSpeed: CGFloat = 5
    private let collisionRadius: CGFloat = 40
    private let maxFoodOnScreen = 3
    private let foodStartY: CGFloat = -30
    private let foodEndSpacing: CGFloat = 50

    // Cached screen dimensions
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height

    func startGame(difficulty: GameDifficulty) {
        self.difficulty = difficulty
        score = 0
        comboCount = 0
        gameTime = 0
        duckPosition = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        foodItems.removeAll()
        gameActive = true
        gameStartTime = Date().timeIntervalSince1970
        generateFood()
        startGameLoop()
    }

    func resetGame() {
        stopGameLoop()
        score = 0
        comboCount = 0
        gameTime = 0
        foodItems.removeAll()
        gameActive = false
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
            position: CGPoint(x: randomX, y: foodStartY),
            id: UUID(),
            type: foodType
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

struct FoodItem: Identifiable {
    var position: CGPoint
    let id: UUID
    let type: FoodType
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
            .onContinuousHover { phase in
                if case .active(let location) = phase {
                    gameManager.moveDuck(to: location)
                }
            }
            .accessibilityElement(
                label: "Duck Fly Game",
                hint: "Move duck to collect falling food"
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
        FoodItemView(type: foodType)
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
