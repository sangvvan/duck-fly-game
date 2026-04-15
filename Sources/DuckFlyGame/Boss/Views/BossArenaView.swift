import SwiftUI

struct BossArenaView: View {
    @ObservedObject var progressionManager: RoundProgressionManager
    let round: BossRound
    @State private var bossX: CGFloat = 0
    @State private var playerX: CGFloat = 0
    @State private var bossAttackTimer: Timer?
    @State private var gameTimer: Timer?
    @State private var bossProjectiles: [CGPoint] = []
    @State private var playerAttackFlash = false
    @State private var bossAttackFlash = false

    var screenWidth: CGFloat { getScreenBounds().width }
    var screenHeight: CGFloat { getScreenBounds().height }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: round.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Battle arena
            ZStack {
                // Boss with attack animation
                if let boss = progressionManager.bossState {
                    ZStack {
                        // Boss glow effect when attacking
                        if bossAttackFlash {
                            Circle()
                                .fill(Color.red.opacity(0.3))
                                .frame(width: GameConstants.Boss.bossGlowSize, height: GameConstants.Boss.bossGlowSize)
                        }

                        // Boss character
                        VStack(spacing: 8) {
                            Text(round.bossEmoji)
                                .font(.system(size: 80))
                                .scaleEffect(bossAttackFlash ? 1.1 : 1.0)

                            // Boss HP display
                            HStack(spacing: 4) {
                                Text("HP:")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                ForEach(0..<Int(boss.hpPercentage * 10), id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(boss.isEnraged ? Color.red : Color.green)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .padding(4)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(4)
                        }
                    }
                    .position(CGPoint(x: bossX, y: 100))
                }

                // Projectiles from boss
                ForEach(bossProjectiles.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.red.opacity(0.8))
                        .frame(width: GameConstants.Boss.projectileSize, height: GameConstants.Boss.projectileSize)
                        .position(bossProjectiles[index])
                }

                // Player with dodge mechanic
                VStack(spacing: 8) {
                    Text("🦆")
                        .font(.system(size: 70))
                        .scaleEffect(playerAttackFlash ? 1.15 : 1.0)

                    // Player HP display
                    HStack(spacing: 4) {
                        Text("HP:")
                            .font(.caption2)
                            .foregroundColor(.white)
                        ForEach(0..<progressionManager.playerHP, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(4)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(4)
                }
                .position(CGPoint(x: playerX, y: screenHeight - 120))

                // Dodge instruction
                Text("TAP to dodge left/right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .position(CGPoint(x: screenWidth / 2, y: screenHeight - 50))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { location in
                // Dodge mechanic - move away from projectiles
                if location.x < screenWidth / 3 {
                    playerX = max(40, playerX - GameConstants.Boss.dodgeMoveDistance)
                } else if location.x > 2 * screenWidth / 3 {
                    playerX = min(screenWidth - 40, playerX + GameConstants.Boss.dodgeMoveDistance)
                } else {
                    playerX = screenWidth / 2
                }
            }

            // Control HUD
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(round.bossName)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Round \(progressionManager.currentPhaseNumber)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Food: \(progressionManager.foodBattlePoints)")
                            .font(.headline)
                            .foregroundColor(.yellow)
                        Text("Cost: 25 per attack")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding(12)
                .background(Color.black.opacity(0.6))
                .cornerRadius(8)
                .padding(8)

                Spacer()

                // Attack button
                Button(action: {
                    playerAttackFlash = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        playerAttackFlash = false
                    }

                    let won = progressionManager.attackBoss(cost: 25)
                    if won {
                        progressionManager.phase = .roundComplete
                    }
                }) {
                    HStack {
                        Text("💥")
                            .font(.system(size: 24))
                        Text("ATTACK")
                            .font(.headline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("(\(max(0, 25 - progressionManager.foodBattlePoints)))")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .foregroundColor(.white)
                    .background(
                        progressionManager.foodBattlePoints >= 25 ?
                        LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.9), Color.orange.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing) :
                        LinearGradient(gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                }
                .disabled(progressionManager.foodBattlePoints < 25)
                .padding(12)
            }
            .padding(8)
        }
        .onAppear {
            setupGame()
        }
        .onDisappear {
            bossAttackTimer?.invalidate()
            gameTimer?.invalidate()
        }
    }

    private func setupGame() {
        playerX = screenWidth / 2
        bossX = screenWidth / 2

        progressionManager.phase = .bossFighting

        // Boss movement and attack timer
        gameTimer = Timer.scheduledTimer(withTimeInterval: GameConstants.Timers.bossLoopInterval, repeats: true) { _ in
            // Boss moves side to side in a sine wave
            let movement = sin(Date().timeIntervalSince1970 * 2) * (screenWidth / 3)
            bossX = screenWidth / 2 + movement

            // Update projectile positions
            bossProjectiles = bossProjectiles.filter { projectile in
                projectile.y < screenHeight
            }

            for i in 0..<bossProjectiles.count {
                bossProjectiles[i].y += GameConstants.Boss.projectileSpeed
            }

            // Boss attacks every 2 seconds
            if let boss = progressionManager.bossState {
                boss.updateCooldown(0.03)
                if boss.canAttack() {
                    // Create projectile from boss position
                    bossProjectiles.append(CGPoint(x: bossX, y: 140))

                    // Flash effect
                    bossAttackFlash = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        bossAttackFlash = false
                    }

                    boss.triggerAttack()

                    // Check if player was hit
                    if abs(bossProjectiles.last?.x ?? 0 - playerX) < 50 {
                        progressionManager.bossDamagesPlayer()
                    }
                }
            }
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    let manager = RoundProgressionManager()
    manager.createBossState()
    return BossArenaView(progressionManager: manager, round: .amazon)
}
#endif
