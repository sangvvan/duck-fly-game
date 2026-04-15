import Foundation

struct DuckStats {
    var attackPower: Int = 10
    var defense: Int = 0
    var speed: CGFloat = 1.0
    var maxHP: Int = 100

    mutating func apply(cosmetic: DuckCosmetic) {
        attackPower += cosmetic.statBonus.attackPower
        defense += cosmetic.statBonus.defense
        speed += cosmetic.statBonus.speed
        maxHP += cosmetic.statBonus.maxHP
    }

    func calculateDamageTaken(_ incomingDamage: Int) -> Int {
        max(1, incomingDamage - defense)
    }

    mutating func reset() {
        attackPower = 10
        defense = 0
        speed = 1.0
        maxHP = 100
    }
}
