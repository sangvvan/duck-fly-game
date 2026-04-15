import Foundation
import Combine

enum GamePhase {
    case setup
    case roundIntro
    case collecting
    case bossIntro
    case bossFighting
    case roundComplete
    case cosmeticUnlock
    case bossDeathOptions
    case gameOver
}

class RoundProgressionManager: ObservableObject {
    @Published var currentRound: BossRound = .amazon
    @Published var phase: GamePhase = .setup
    @Published var foodBattlePoints: Int = 0
    @Published var playerHP: Int = 100
    @Published var lives: Int = 3
    @Published var unlockedCosmetics: [DuckCosmetic] = []
    @Published var totalScore: Int = 0
    @Published var roundsCompleted: Int = 0
    @Published var duckStats: DuckStats = DuckStats()
    @Published var bossState: BossState?

    private let foodPerRound = 50
    private var foodCollectedThisRound: Int = 0

    init() {}

    // MARK: - Food Collection Phase
    func onFoodCollected(_ type: FoodType) {
        foodBattlePoints += type.points
        foodCollectedThisRound += 1

        if foodCollectedThisRound >= foodPerRound {
            startBossPhase()
        }
    }

    // MARK: - Boss Fight Phase
    func startBossPhase() {
        phase = .bossIntro
        createBossState()
    }

    func createBossState() {
        bossState = BossState(round: currentRound)
    }

    func startBossFight() {
        phase = .bossFighting
    }

    func attackBoss(cost: Int = 25) -> Bool {
        guard foodBattlePoints >= cost else { return false }
        guard let boss = bossState else { return false }

        foodBattlePoints -= cost
        let damage = duckStats.attackPower + cost / 5
        boss.takeDamage(damage)

        if !boss.isAlive {
            roundComplete()
            return true
        }
        return false
    }

    func bossDamagesPlayer() {
        guard let boss = bossState else { return }
        guard boss.canAttack() else { return }

        let damage = duckStats.calculateDamageTaken(boss.attackDamage)
        playerHP -= damage
        boss.triggerAttack()

        if playerHP <= 0 {
            playerHP = 0
            phase = .bossDeathOptions
        }
    }

    // MARK: - Round Completion
    private func roundComplete() {
        roundsCompleted += 1
        totalScore += foodBattlePoints * 10

        if DuckCosmetic.forRound(currentRound) != nil {
            phase = .cosmeticUnlock
        } else {
            phase = .roundComplete
        }
    }

    func advanceToNextRound() {
        // Cycle through the themes
        let themes: [BossRound] = [.amazon, .sahara, .himalayas, .coralReef, .arctic]
        let currentIndex = themes.firstIndex(of: currentRound) ?? 0
        let nextIndex = (currentIndex + 1) % themes.count
        currentRound = themes[nextIndex]

        // Unlock cosmetic if available
        if let cosmetic = DuckCosmetic.forRound(currentRound) {
            if !unlockedCosmetics.contains(cosmetic) {
                unlockedCosmetics.append(cosmetic)
                var updatedStats = duckStats
                updatedStats.apply(cosmetic: cosmetic)
                duckStats = updatedStats
            }
        }

        resetForNewRound()
        phase = .roundIntro
    }

    private func resetForNewRound() {
        foodCollectedThisRound = 0
        foodBattlePoints = 0
        playerHP = duckStats.maxHP
        bossState = nil
    }

    // MARK: - Death Handling
    func getDeathOptions() -> [String] {
        return ["Restart Round", "End Game"]
    }

    func handleDeathOption(_ option: String) {
        switch option {
        case "Restart Round":
            resetCurrentRound()
        case "End Game":
            phase = .gameOver
        default:
            break
        }
    }

    func resetCurrentRound() {
        playerHP = duckStats.maxHP
        foodCollectedThisRound = 0
        foodBattlePoints = 0
        bossState = nil
        phase = .collecting
    }

    // MARK: - Game State
    func startNewGame() {
        currentRound = .amazon
        phase = .setup
        foodBattlePoints = 0
        playerHP = 100
        lives = 3
        unlockedCosmetics = []
        totalScore = 0
        roundsCompleted = 0
        duckStats = DuckStats()
        bossState = nil
    }

    func updateBossCooldowns(_ deltaTime: TimeInterval) {
        bossState?.updateCooldown(deltaTime)
    }
}
