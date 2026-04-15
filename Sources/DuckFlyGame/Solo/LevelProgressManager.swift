import Foundation
import Combine

class LevelProgressManager: ObservableObject {
    @Published var highestUnlockedLevel: Int = 1
    @Published var completedLevels: Set<Int> = []
    @Published var unlockedCosmetics: [DuckCosmetic] = []
    @Published var duckStats: DuckStats = DuckStats()
    @Published var currentLevel: Int = 1

    private let userDefaultsKeys = (
        highestUnlocked: "duck_game_highest_unlocked_level",
        completed: "duck_game_completed_levels",
        cosmetics: "duck_game_unlocked_cosmetics"
    )

    init() {
        load()
    }

    func unlockNextLevel() {
        let nextLevel = highestUnlockedLevel + 1
        if nextLevel > highestUnlockedLevel {
            highestUnlockedLevel = nextLevel
        }
        save()
    }

    func markCompleted(level: Int) {
        completedLevels.insert(level)
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
        save()
    }

    func unlockCosmetic(_ cosmetic: DuckCosmetic) {
        if !unlockedCosmetics.contains(cosmetic) {
            unlockedCosmetics.append(cosmetic)
            var updatedStats = duckStats
            updatedStats.apply(cosmetic: cosmetic)
            duckStats = updatedStats
        }
        save()
    }

    private func load() {
        if let saved = UserDefaults.standard.integer(
            forKey: userDefaultsKeys.highestUnlocked
        ) as Int?, saved > 0 {
            highestUnlockedLevel = saved
        }

        if let completed = UserDefaults.standard.array(
            forKey: userDefaultsKeys.completed
        ) as? [Int] {
            completedLevels = Set(completed)
        }

        if let cosmeticNames = UserDefaults.standard.stringArray(
            forKey: userDefaultsKeys.cosmetics
        ) {
            unlockedCosmetics = cosmeticNames.compactMap {
                DuckCosmetic(rawValue: $0)
            }
            for cosmetic in unlockedCosmetics {
                duckStats.apply(cosmetic: cosmetic)
            }
        }
    }

    private func save() {
        UserDefaults.standard.set(
            highestUnlockedLevel,
            forKey: userDefaultsKeys.highestUnlocked
        )
        UserDefaults.standard.set(
            Array(completedLevels),
            forKey: userDefaultsKeys.completed
        )
        UserDefaults.standard.set(
            unlockedCosmetics.map { $0.rawValue },
            forKey: userDefaultsKeys.cosmetics
        )
    }
}
