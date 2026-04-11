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
    private let gameSpeed: CGFloat = 5

    init() {
        generateFood()
        startGameLoop()
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

        // Update food items
        for i in 0..<foodItems.count {
            foodItems[i].position.y += gameSpeed

            // Remove food that went off screen
            if foodItems[i].position.y > UIScreen.main.bounds.height {
                foodItems.remove(at: i)
            }
        }

        // Check collisions with duck
        for i in 0..<foodItems.count {
            let distance = duckPosition.distance(to: foodItems[i].position)
            if distance < 40 {
                score += 10
                foodItems.remove(at: i)

                if foodItems.count < 3 {
                    generateFood()
                }
            }
        }

        // Generate new food occasionally
        if foodItems.isEmpty {
            generateFood()
        }
    }

    private func generateFood() {
        let width = UIScreen.main.bounds.width
        let randomX = CGFloat.random(in: 50...(width - 50))
        let food = FoodItem(
            position: CGPoint(x: randomX, y: -30),
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
