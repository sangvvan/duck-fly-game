import Foundation

/// Represents animal characters available for multiplayer selection
enum AnimalCharacter: String, CaseIterable, Identifiable {
    case duck = "Duck"
    case bunny = "Bunny"
    case fox = "Fox"
    case penguin = "Penguin"
    case squirrel = "Squirrel"
    case panda = "Panda"
    case cat = "Cat"
    case frog = "Frog"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .duck:
            return "🦆"
        case .bunny:
            return "🐰"
        case .fox:
            return "🦊"
        case .penguin:
            return "🐧"
        case .squirrel:
            return "🐿"
        case .panda:
            return "🐼"
        case .cat:
            return "🐱"
        case .frog:
            return "🐸"
        }
    }

    var stats: CharacterStats {
        switch self {
        case .duck:
            return CharacterStats(
                speedMultiplier: 1.0,
                hitboxSize: 60,
                specialAbility: .comboPlus1
            )
        case .bunny:
            return CharacterStats(
                speedMultiplier: 1.3,
                hitboxSize: 54,
                specialAbility: .doubleJump
            )
        case .fox:
            return CharacterStats(
                speedMultiplier: 1.1,
                hitboxSize: 57,
                specialAbility: .magnetPull
            )
        case .penguin:
            return CharacterStats(
                speedMultiplier: 0.8,
                hitboxSize: 72,
                specialAbility: .wideCatch
            )
        case .squirrel:
            return CharacterStats(
                speedMultiplier: 1.2,
                hitboxSize: 51,
                specialAbility: .hoardBonus
            )
        case .panda:
            return CharacterStats(
                speedMultiplier: 0.85,
                hitboxSize: 69,
                specialAbility: .autoShield
            )
        case .cat:
            return CharacterStats(
                speedMultiplier: 1.15,
                hitboxSize: 54,
                specialAbility: .luckyDouble
            )
        case .frog:
            return CharacterStats(
                speedMultiplier: 1.0,
                hitboxSize: 60,
                specialAbility: .leapToFood
            )
        }
    }

    var displayName: String {
        rawValue
    }
}
