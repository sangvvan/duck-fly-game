import Foundation
import SwiftUI

/// Shared game simulation loop for multiplayer - handles food generation and physics at 60fps
class GameSimulation: ObservableObject {
    @Published var foodItems: [FoodItem] = []
    @Published var powerUpItems: [PowerUpItem] = []
    @Published var elapsedTime: Double = 0
    @Published var isRunning: Bool = false

    private var displayLink: CADisplayLink?
    private let difficulty: GameDifficulty
    private var lastFoodSpawnTime: Double = 0
    private let foodSpawnInterval: Double = 0.5
    private var lastPowerUpSpawnTime: Double = 0
    private let powerUpSpawnInterval: Double = 10.0 // Max 1 power-up every 10 seconds

    init(difficulty: GameDifficulty = .normal) {
        self.difficulty = difficulty
    }

    func start() {
        isRunning = true
        elapsedTime = 0
        lastFoodSpawnTime = 0
        lastPowerUpSpawnTime = 0
        foodItems.removeAll()
        powerUpItems.removeAll()

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

        // Spawn power-ups occasionally (max 1 every 10 seconds)
        if elapsedTime - lastPowerUpSpawnTime >= powerUpSpawnInterval {
            if Double.random(in: 0...1) < 0.3 { // 30% chance each spawn window
                spawnPowerUp()
                lastPowerUpSpawnTime = elapsedTime
            }
        }

        // Update food positions
        updateFoodPositions()
        updatePowerUpPositions()

        // Remove food that fell off screen
        foodItems.removeAll { $0.position.y > 1000 }
        powerUpItems.removeAll { $0.position.y > 1000 }

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

    private func spawnPowerUp() {
        let screenWidth = UIScreen.main.bounds.width
        let randomX = CGFloat.random(in: 50...(screenWidth - 50))
        let powerUpType = PowerUpType.random()

        let powerUpItem = PowerUpItem(
            id: UUID(),
            type: powerUpType,
            position: CGPoint(x: randomX, y: -50),
            velocity: CGPoint(x: 0, y: calculateFoodSpeed() * 0.8),
            rotation: 0
        )
        powerUpItems.append(powerUpItem)
    }

    private func updateFoodPositions() {
        for (index, var food) in foodItems.enumerated() {
            food.position.y += food.velocity.y
            food.rotation += 360.0 / 180.0 // One full rotation per 3 seconds (360 degrees / 180 frames at 60fps)

            foodItems[index] = food
        }
    }

    private func updatePowerUpPositions() {
        for (index, var powerUp) in powerUpItems.enumerated() {
            powerUp.position.y += powerUp.velocity.y
            powerUp.rotation += 360.0 / 150.0 // Faster rotation than regular food

            powerUpItems[index] = powerUp
        }
    }

    private func calculateFoodSpeed() -> CGFloat {
        let baseSpeed: CGFloat = 150.0
        let speedMultiplier = difficulty.foodSpeedMultiplier
        return baseSpeed * speedMultiplier / 60.0 // Normalize to 60fps
    }

    func removeFood(_ foodItem: FoodItem) {
        foodItems.removeAll { $0.id == foodItem.id }
    }

    func removePowerUp(_ powerUpItem: PowerUpItem) {
        powerUpItems.removeAll { $0.id == powerUpItem.id }
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

/// Power-up item in the game
struct PowerUpItem: Identifiable {
    let id: UUID
    let type: PowerUpType
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
