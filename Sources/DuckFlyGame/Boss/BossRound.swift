import SwiftUI

enum BossRound: Equatable {
    case amazon, sahara, himalayas, coralReef, arctic

    var name: String {
        switch self {
        case .amazon: "Amazon Rainforest"
        case .sahara: "Sahara Desert"
        case .himalayas: "Himalayas"
        case .coralReef: "Coral Reef"
        case .arctic: "Arctic"
        }
    }

    var emoji: String {
        switch self {
        case .amazon: "🌿"
        case .sahara: "🏜️"
        case .himalayas: "⛰️"
        case .coralReef: "🐚"
        case .arctic: "❄️"
        }
    }

    var bossName: String {
        switch self {
        case .amazon: "Giant Anaconda"
        case .sahara: "Sand Scorpion"
        case .himalayas: "Snow Yeti"
        case .coralReef: "Electric Eel"
        case .arctic: "Polar Bear"
        }
    }

    var bossEmoji: String {
        switch self {
        case .amazon: "🐍"
        case .sahara: "🦂"
        case .himalayas: "👹"
        case .coralReef: "⚡"
        case .arctic: "🐻‍❄️"
        }
    }

    var bossHP: Int {
        switch self {
        case .amazon: 100
        case .sahara: 120
        case .himalayas: 140
        case .coralReef: 160
        case .arctic: 180
        }
    }

    var bossAttackDamage: Int {
        switch self {
        case .amazon: 10
        case .sahara: 12
        case .himalayas: 14
        case .coralReef: 16
        case .arctic: 18
        }
    }

    var description: String {
        switch self {
        case .amazon: "Defeat the guardian of the rainforest"
        case .sahara: "Conquer the desert's mighty warrior"
        case .himalayas: "Challenge the mountain's keeper"
        case .coralReef: "Overcome the ocean's defender"
        case .arctic: "Survive the frozen lands' protector"
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .amazon: [Color(red: 0.2, green: 0.6, blue: 0.2), Color(red: 0.4, green: 0.8, blue: 0.2)]
        case .sahara: [Color(red: 0.9, green: 0.7, blue: 0.2), Color(red: 0.8, green: 0.6, blue: 0.1)]
        case .himalayas: [Color(red: 0.7, green: 0.8, blue: 1.0), Color(red: 0.8, green: 0.9, blue: 1.0)]
        case .coralReef: [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.3, green: 0.7, blue: 0.9)]
        case .arctic: [Color(red: 0.8, green: 0.9, blue: 1.0), Color(red: 0.9, green: 0.95, blue: 1.0)]
        }
    }
}
