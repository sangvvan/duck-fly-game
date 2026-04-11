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

            // Content based on game state
            switch gameState {
            case .menu:
                StartMenuView(gameState: $gameState, selectedDifficulty: $selectedDifficulty)
                    .transition(.opacity)

            case .playing:
                GameView(gameManager: gameManager)
                    .ignoresSafeArea()
                    .transition(.opacity)

            case .gameOver:
                GameOverView(score: gameManager.score) {
                    gameState = .menu
                    gameManager.resetGame()
                }
                .transition(.opacity)
            }
        }
        .onAppear {
            ColorTheme.verifyAccessibility()
        }
        .onChange(of: gameState) { newState in
            if newState == .playing {
                gameManager.startGame(difficulty: selectedDifficulty)
            }
        }
        .onChange(of: gameManager.gameActive) { isActive in
            if !isActive && gameState == .playing {
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

    private var displayLink: CADisplayLink?
    private var difficulty: GameDifficulty = .normal
    private var lastCollectionTime: TimeInterval = 0
    private let comboTimeout: TimeInterval = 1.5  // Time to maintain combo

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
        duckPosition = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        foodItems.removeAll()
        gameActive = true
        generateFood()
        startGameLoop()
    }

    func resetGame() {
        stopGameLoop()
        score = 0
        comboCount = 0
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

        // Update food items and remove off-screen items (reverse iteration to avoid index issues)
        for i in stride(from: foodItems.count - 1, through: 0, by: -1) {
            let speedAdjusted = baseGameSpeed * foodItems[i].type.speedModifier * difficulty.foodSpeedMultiplier
            foodItems[i].position.y += speedAdjusted

            // Remove food that went off screen
            if foodItems[i].position.y > screenHeight {
                foodItems.remove(at: i)
            }
        }

        // Check collisions with duck (reverse iteration for safe removal)
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

        // Simple game over condition: time limit (30 seconds for demo)
        // In Phase 3, this can be replaced with lives system or other mechanics
    }

    private func generateFood() {
        let randomX = CGFloat.random(in: foodEndSpacing...(screenWidth - foodEndSpacing))

        // Select food type based on spawn weights
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

                // Point popups
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
                }
                .zIndex(10)
            }
            .contentShape(Rectangle())
            .onContinuousHover { phase in
                if case .active(let location) = phase {
                    gameManager.moveDuck(to: location)
                }
            }
        }
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
