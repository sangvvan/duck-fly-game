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

    var body: some View {
        ZStack {
            // Background
            Color.cyan
                .ignoresSafeArea()

            // Game canvas
            GameView(gameManager: gameManager)
                .ignoresSafeArea()
        }
    }
}

class GameManager: ObservableObject {
    @Published var duckPosition = CGPoint(x: 100, y: 200)
    @Published var foodItems: [FoodItem] = []
    @Published var score = 0
    @Published var gameActive = true

    private var displayLink: CADisplayLink?

    // Game constants
    private let gameSpeed: CGFloat = 5
    private let collisionRadius: CGFloat = 40
    private let maxFoodOnScreen = 3
    private let foodStartY: CGFloat = -30
    private let foodEndSpacing: CGFloat = 50

    // Cached screen dimensions
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height

    init() {
        generateFood()
        startGameLoop()
    }

    deinit {
        stopGameLoop()
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
            foodItems[i].position.y += gameSpeed

            // Remove food that went off screen
            if foodItems[i].position.y > screenHeight {
                foodItems.remove(at: i)
            }
        }

        // Check collisions with duck (reverse iteration for safe removal)
        for i in stride(from: foodItems.count - 1, through: 0, by: -1) {
            let distance = duckPosition.distance(to: foodItems[i].position)
            if distance < collisionRadius {
                score += 10
                foodItems.remove(at: i)
            }
        }

        // Maintain minimum food on screen
        while foodItems.count < maxFoodOnScreen {
            generateFood()
        }
    }

    private func generateFood() {
        let randomX = CGFloat.random(in: foodEndSpacing...(screenWidth - foodEndSpacing))
        let food = FoodItem(
            position: CGPoint(x: randomX, y: foodStartY),
            id: UUID()
        )
        foodItems.append(food)
    }

    func moveDuck(to position: CGPoint) {
        duckPosition = position
    }
}

struct FoodItem: Identifiable {
    var position: CGPoint
    let id: UUID
}

struct GameView: View {
    @ObservedObject var gameManager: GameManager

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Food items
                ForEach(gameManager.foodItems) { food in
                    FoodView()
                        .position(food.position)
                }

                // Duck
                DuckView()
                    .position(gameManager.duckPosition)

                // Score
                VStack {
                    HStack {
                        Text("Score: \(gameManager.score)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
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
        Text("🦆")
            .font(.system(size: 40))
    }
}

struct FoodView: View {
    var body: some View {
        Text("🌽")
            .font(.system(size: 24))
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
