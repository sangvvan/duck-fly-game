import Foundation

/// Procedurally generated configuration for any level in the infinite progression
struct LevelConfig {
    let levelNumber: Int
    var theme: BossRound
    var foodTarget: Int
    var bossHP: Int
    var bossAttackDamage: Int
    var foodSpeedMultiplier: Double
    var hazardSpawnRate: Double
    var cosmeticUnlocked: DuckCosmetic?

    var title: String {
        "Level \(levelNumber) — \(theme.name)"
    }

    var difficulty: String {
        switch levelNumber {
        case 1...5: "Easy"
        case 6...15: "Medium"
        case 16...30: "Hard"
        default: "Expert"
        }
    }

    /// Generate level configuration for any level number
    static func make(level: Int) -> LevelConfig {
        // Theme cycles every 5 levels: level 1→amazon, 2→sahara, 3→himalayas, 4→coralReef, 5→arctic, 6→amazon...
        let themes: [BossRound] = [.amazon, .sahara, .himalayas, .coralReef, .arctic]
        let themeIndex = (level - 1) % themes.count
        let theme = themes[themeIndex]

        // Food target: 50 foods per level (fixed)
        let foodTarget = 50

        // Boss HP scales: 100 at level 1, +20 per level: 100, 120, 140, 160...
        let bossHP = 100 + (level - 1) * 20

        // Boss attack damage scales: 10 at level 1, +2 per level: 10, 12, 14, 16...
        let bossAttackDamage = 10 + (level - 1) * 2

        // Food speed increases over time: 1.0x at level 1, up to 2.5x at level 31+
        let foodSpeedMultiplier = 1.0 + Double(min(level - 1, 30)) * 0.05

        // Hazard spawn rate increases: 20% at level 1, caps at 60% around level 30
        let hazardBase = 0.2 + Double(min(level - 1, 40)) * 0.01
        let hazardSpawnRate = min(hazardBase, 0.6)

        // Cosmetics unlock every 5 levels: level 5→amazonExplorer, 10→saharaRider, etc.
        let cosmeticUnlocked: DuckCosmetic? = {
            let unlockedCount = level / 5
            switch unlockedCount {
            case 1: return .amazonExplorer
            case 2: return .saharaRider
            case 3: return .himalayaMonk
            case 4: return .coralDiver
            case 5: return .arcticParka
            default: return nil  // No new cosmetic at this level
            }
        }()

        return LevelConfig(
            levelNumber: level,
            theme: theme,
            foodTarget: foodTarget,
            bossHP: bossHP,
            bossAttackDamage: bossAttackDamage,
            foodSpeedMultiplier: foodSpeedMultiplier,
            hazardSpawnRate: hazardSpawnRate,
            cosmeticUnlocked: cosmeticUnlocked
        )
    }
}
