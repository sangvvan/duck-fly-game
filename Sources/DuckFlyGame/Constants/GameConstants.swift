import SwiftUI

/// Centralized game configuration constants
enum GameConstants {

    enum Physics {
        static let gravity: CGFloat = 0.4
        static let jumpForce: CGFloat = -10
        static let duckWidth: CGFloat = 50
        static let duckHeight: CGFloat = 50
    }

    enum Gameplay {
        static let baseGameSpeed: CGFloat = 5
        static let collisionRadius: CGFloat = 40
        static let maxFoodOnScreen = 3
        static let gameTimeLimit: TimeInterval = 60
        static let comboTimeout: TimeInterval = 1.5
        static let foodStartY: CGFloat = -30
        static let foodEdgeSpacing: CGFloat = 50
        static let duckStartOffsetY: CGFloat = 150
    }

    enum Timers {
        static let gameLoopInterval: TimeInterval = 1.0 / 60.0  // 60fps
        static let bossLoopInterval: TimeInterval = 0.03
        static let bossAttackCooldown: TimeInterval = 2.0
    }

    enum Colors {
        static let bossAttackIndicator = Color.red
        static let bossHealthEnraged = Color.red
        static let bossHealthNormal = Color.green
        static let fuelPointsText = Color.yellow
    }

    enum UI {
        static let standardPadding: CGFloat = 12
        static let largeButtonVerticalPadding: CGFloat = 16
        static let standardCornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 6
        static let standardIconSize: CGFloat = 18
        static let largeIconSize: CGFloat = 32
    }

    enum Audio {
        static let isEnabled: Bool {
            UserDefaults.standard.bool(forKey: "soundEnabled")
        }

        static func setSoundEnabled(_ enabled: Bool) {
            UserDefaults.standard.set(enabled, forKey: "soundEnabled")
        }
    }

    enum Boss {
        static let projectileSpeed: CGFloat = 8
        static let projectileSize: CGFloat = 12
        static let dodgeMoveDistance: CGFloat = 80
        static let bossGlowSize: CGFloat = 120
    }
}
