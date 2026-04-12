import Foundation

/// Stats for a character
struct CharacterStats {
    let speedMultiplier: CGFloat
    let hitboxSize: CGFloat
    let specialAbility: SpecialAbility

    var hitboxRadius: CGFloat {
        hitboxSize / 2
    }
}

/// Special ability that each character has
enum SpecialAbility {
    case comboPlus1          // Duck: +1 combo per catch
    case doubleJump          // Bunny: jump upward to catch higher food
    case magnetPull          // Fox: pull food within 80pt radius
    case wideCatch           // Penguin: 1.5x catch radius
    case hoardBonus          // Squirrel: +50 bonus on catch
    case autoShield          // Panda: shield absorbs one miss
    case luckyDouble         // Cat: 50% chance 2x score
    case leapToFood          // Frog: teleport to nearest food

    var description: String {
        switch self {
        case .comboPlus1:
            return "Combo +1 per catch"
        case .doubleJump:
            return "Jump upward to catch higher"
        case .magnetPull:
            return "Pull food within 80pt"
        case .wideCatch:
            return "1.5x catch radius"
        case .hoardBonus:
            return "Bonus +50 on catch"
        case .autoShield:
            return "Shield absorbs one miss"
        case .luckyDouble:
            return "50% chance 2x score"
        case .leapToFood:
            return "Leap to nearest food"
        }
    }
}
