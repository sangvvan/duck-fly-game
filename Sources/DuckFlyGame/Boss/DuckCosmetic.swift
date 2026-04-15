import SwiftUI

enum DuckCosmetic: String, CaseIterable {
    case amazonExplorer
    case saharaRider
    case himalayaMonk
    case coralDiver
    case arcticParka

    var name: String {
        switch self {
        case .amazonExplorer: "Amazon Explorer"
        case .saharaRider: "Sahara Rider"
        case .himalayaMonk: "Himalaya Monk"
        case .coralDiver: "Coral Diver"
        case .arcticParka: "Arctic Parka"
        }
    }

    var hatEmoji: String {
        switch self {
        case .amazonExplorer: "🪖"
        case .saharaRider: "🧣"
        case .himalayaMonk: "☁️"
        case .coralDiver: "🤿"
        case .arcticParka: "🧥"
        }
    }

    var description: String {
        switch self {
        case .amazonExplorer: "Explore the jungle with style"
        case .saharaRider: "Ride through the desert"
        case .himalayaMonk: "Channel mountain wisdom"
        case .coralDiver: "Dive into the ocean"
        case .arcticParka: "Brave the frozen north"
        }
    }

    var bodyColor: Color {
        switch self {
        case .amazonExplorer: Color(red: 0.9, green: 0.8, blue: 0.6)
        case .saharaRider: Color(red: 0.95, green: 0.85, blue: 0.7)
        case .himalayaMonk: Color(red: 0.85, green: 0.85, blue: 0.95)
        case .coralDiver: Color(red: 0.8, green: 0.9, blue: 0.95)
        case .arcticParka: Color(red: 0.9, green: 0.95, blue: 1.0)
        }
    }

    var beakColor: Color {
        switch self {
        case .amazonExplorer: Color(red: 1.0, green: 0.7, blue: 0.2)
        case .saharaRider: Color(red: 1.0, green: 0.8, blue: 0.3)
        case .himalayaMonk: Color(red: 0.7, green: 0.7, blue: 0.9)
        case .coralDiver: Color(red: 0.2, green: 0.8, blue: 1.0)
        case .arcticParka: Color(red: 0.6, green: 0.8, blue: 1.0)
        }
    }

    var statBonus: DuckStats {
        switch self {
        case .amazonExplorer: DuckStats(attackPower: 0, defense: 5, speed: 0, maxHP: 0)
        case .saharaRider: DuckStats(attackPower: 0, defense: 0, speed: 0.3, maxHP: 0)
        case .himalayaMonk: DuckStats(attackPower: 0, defense: 0, speed: 0, maxHP: 10)
        case .coralDiver: DuckStats(attackPower: 5, defense: 0, speed: 0, maxHP: 0)
        case .arcticParka: DuckStats(attackPower: 0, defense: 0, speed: 0, maxHP: 10)
        }
    }

    static func forRound(_ round: BossRound) -> DuckCosmetic? {
        switch round {
        case .amazon: .amazonExplorer
        case .sahara: .saharaRider
        case .himalayas: .himalayaMonk
        case .coralReef: .coralDiver
        case .arctic: .arcticParka
        }
    }
}
