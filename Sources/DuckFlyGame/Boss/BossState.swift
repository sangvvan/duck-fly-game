import Foundation
import Combine
import UIKit

/// Manages the state and behavior of a boss during a boss fight
class BossState: ObservableObject {
    @Published var hp: Int
    @Published var maxHP: Int
    @Published var isEnraged: Bool = false
    @Published var position: CGPoint = CGPoint(x: getScreenBounds().midX, y: 100)
    @Published var attackCooldown: TimeInterval = 0
    @Published var attackDamage: Int

    private let baseAttackInterval: TimeInterval = 2.0
    private var enragedAttackInterval: TimeInterval { baseAttackInterval * 0.6 }

    var isAlive: Bool {
        hp > 0
    }

    var hpPercentage: Double {
        Double(hp) / Double(maxHP)
    }

    init(round: BossRound, bossHP: Int? = nil, bossAttackDamage: Int? = nil) {
        self.hp = bossHP ?? round.bossHP
        self.maxHP = bossHP ?? round.bossHP
        self.attackDamage = bossAttackDamage ?? round.bossAttackDamage
    }

    func takeDamage(_ amount: Int) {
        hp = max(0, hp - amount)
        if hpPercentage < 0.3 {
            isEnraged = true
        }
    }

    func updateCooldown(_ deltaTime: TimeInterval) {
        if attackCooldown > 0 {
            attackCooldown -= deltaTime
        }
    }

    func canAttack() -> Bool {
        attackCooldown <= 0
    }

    func triggerAttack() {
        attackCooldown = isEnraged ? enragedAttackInterval : baseAttackInterval
    }

    func reset(for round: BossRound) {
        hp = round.bossHP
        maxHP = round.bossHP
        isEnraged = false
        attackCooldown = baseAttackInterval
    }
}
