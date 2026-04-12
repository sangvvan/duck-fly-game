import Foundation
import SwiftUI

/// Shared game simulation loop for multiplayer - handles food generation and physics at 60fps
class GameSimulation: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var elapsedTime: Double = 0
    @Published var isRunning: Bool = false

    private var displayLink: CADisplayLink?
    private let difficulty: GameDifficulty
    private var lastFoodSpawnTime: Double = 0
    private let foodSpawnInterval: Double = 0.5

    init(difficulty: GameDifficulty = .normal) {
        self.difficulty = difficulty
    }

    func start() {
        isRunning = true
        elapsedTime = 0
        lastFoodSpawnTime = 0
        foodItems.removeAll()

        displayLink = CADisplayLink(
            target: self,
            selector: #selector(updateSimulation)
        )
        displayLink?.preferredFramesPerSecond = 60
        displayLink?.add(to: .main, forMode: .common)
    }

    func stop() {
        isRunning = false
        displayLink?.invalidate()
        displayLink = nil
    }

    @objc private func updateSimulation() {
        guard isRunning else { return }

        elapsedTime += (displayLink?.duration ?? 1.0 / 60.0)

        // Spawn new food
        if elapsedTime - lastFoodSpawnTime >= foodSpawnInterval {
            spawnFood()
            lastFoodSpawnTime = elapsedTime
        }

        // Update food positions
        updateFoodPositions()

        // Remove food that fell off screen
        foodItems.removeAll { $0.position.y > 1000 }

        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    private func spawnFood() {
        let screenWidth = UIScreen.main.bounds.width
        let randomX = CGFloat.random(in: 50...(screenWidth - 50))
        let randomType = FoodType.random()

        let foodItem = FoodItem(
            id: UUID(),
            type: randomType,
            position: CGPoint(x: randomX, y: -50),
            velocity: CGPoint(x: 0, y: calculateFoodSpeed()),
            rotation: 0
        )
        foodItems.append(foodItem)
    }

    private func updateFoodPositions() {
        for (index, var food) in foodItems.enumerated() {
            food.position.y += food.velocity.y
            food.rotation += 360.0 / 180.0 // One full rotation per 3 seconds (360 degrees / 180 frames at 60fps)

            foodItems[index] = food
        }
    }

    private func calculateFoodSpeed() -> CGFloat {
        let baseSpeed: CGFloat = 150.0
        let speedMultiplier = difficulty.foodSpeedModifier
        return baseSpeed * speedMultiplier / 60.0 // Normalize to 60fps
    }

    func removeFood(_ foodItem: FoodItem) {
        foodItems.removeAll { $0.id == foodItem.id }
    }
}

/// Food item in the game
struct FoodItem: Identifiable {
    let id: UUID
    let type: FoodType
    var position: CGPoint
    var velocity: CGPoint
    var rotation: Double
    var claimedBy: UUID? = nil // Prevents double-collection in same frame

    func hitbox() -> CGRect {
        let size = type.size
        return CGRect(
            x: position.x - size / 2,
            y: position.y - size / 2,
            width: size,
            height: size
        )
    }
}
