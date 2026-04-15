import SwiftUI

struct BossArenaView: View {
    @ObservedObject var progressionManager: RoundProgressionManager
    let round: BossRound
    @State private var bossX: CGFloat = 0
    @State private var playerX: CGFloat = 0
    @State private var bossAttackTimer: Timer?
    @State private var gameTimer: Timer?

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

            // Game arena
            ZStack {
                // Boss
                if let boss = progressionManager.bossState {
                    VStack(spacing: 4) {
                        Text(round.bossEmoji)
                            .font(.system(size: 60))
                        Text("\(boss.hp)/\(boss.maxHP)")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                    .position(CGPoint(x: bossX, y: 80))
                }

                // Player
                VStack(spacing: 4) {
                    Text("🦆")
                        .font(.system(size: 50))
                    Text("❤️\(progressionManager.playerHP)")
                        .font(.caption2)
                        .foregroundColor(.white)
                }
                .position(CGPoint(x: playerX, y: screenHeight - 100))

                // Boss attack indicator (red pulsing circle)
                if progressionManager.bossState?.canAttack() == true {
                    Circle()
                        .stroke(Color.red, lineWidth: 3)
                        .frame(width: 100, height: 100)
                        .position(CGPoint(x: bossX, y: 80))
                        .opacity(0.5)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { location in
                playerX = location.x
                playerX = max(25, min(playerX, screenWidth - 25))
            }

            // HUD Overlay
            VStack {
                // Boss HP bar
                if let boss = progressionManager.bossState {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(round.bossName)
                            .font(.caption)
                            .foregroundColor(.white)
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.3))
                            RoundedRectangle(cornerRadius: 4)
                                .fill(boss.isEnraged ? Color.red : Color.green)
                                .frame(width: CGFloat(boss.hpPercentage) * (screenWidth - 40))
                        }
                        .frame(height: 16)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(6)
                    .padding(8)
                }

                Spacer()

                // Attack controls
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Food Ammo")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(progressionManager.foodBattlePoints)")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    .padding(8)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(6)

                    Spacer()

                    Button(action: {
                        let won = progressionManager.attackBoss(cost: 25)
                        if won {
                            progressionManager.phase = .roundComplete
                        }
                    }) {
                        Text("⚔️ ATTACK (25)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red.opacity(0.7))
                            .cornerRadius(6)
                    }
                    .disabled(progressionManager.foodBattlePoints < 25)
                }
                .padding(8)
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

        // Boss movement timer
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            // Boss moves side to side
            let movement = sin(Date().timeIntervalSince1970 * 2) * (screenWidth / 3)
            bossX = screenWidth / 2 + movement

            // Boss attacks every 2 seconds
            if let boss = progressionManager.bossState {
                boss.updateCooldown(0.05)
                if boss.canAttack() {
                    progressionManager.bossDamagesPlayer()
                    boss.triggerAttack()
                }
            }
        }
    }
}

#Preview {
    let manager = RoundProgressionManager()
    manager.createBossState()
    return BossArenaView(progressionManager: manager, round: .amazon)
}
