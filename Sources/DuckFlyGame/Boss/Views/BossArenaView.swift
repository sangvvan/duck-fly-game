import SwiftUI

struct BossArenaView: View {
    @ObservedObject var progressionManager: RoundProgressionManager
    let round: BossRound

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: round.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Boss HP bar
                if let boss = progressionManager.bossState {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(round.bossName)
                            .font(.headline)
                            .foregroundColor(.white)

                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 30)

                            RoundedRectangle(cornerRadius: 8)
                                .fill(boss.isEnraged ? Color.red : Color.green)
                                .frame(width: CGFloat(boss.hpPercentage) * (UIScreen.main.bounds.width - 40), height: 30)

                            Text("\(boss.hp) / \(boss.maxHP)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }

                        if boss.isEnraged {
                            HStack {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.red)
                                Text("ENRAGED!")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .padding()
                }

                Spacer()

                // Boss emoji
                if let boss = progressionManager.bossState {
                    Text(round.bossEmoji)
                        .font(.system(size: 100))
                        .offset(y: CGFloat(sin(Date().timeIntervalSince1970) * 10))
                }

                Spacer()

                // Player HP
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your HP")
                        .font(.headline)
                        .foregroundColor(.white)

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 30)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue)
                            .frame(width: CGFloat(progressionManager.playerHP) / 100.0 * (UIScreen.main.bounds.width - 40), height: 30)

                        Text("\(progressionManager.playerHP) HP")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .padding()

                // Food points / Attack button
                HStack {
                    VStack {
                        Text("Food Points")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text("\(progressionManager.foodBattlePoints)")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)

                    Spacer()

                    Button(action: {
                        let won = progressionManager.attackBoss(cost: 25)
                        if won {
                            progressionManager.phase = .roundComplete
                        }
                    }) {
                        VStack {
                            Text("⚔️")
                                .font(.system(size: 28))
                            Text("ATTACK")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(10)
                    }
                    .disabled(progressionManager.foodBattlePoints < 25)
                }
                .padding()
            }
            .padding()
        }
        .onAppear {
            progressionManager.phase = .bossFighting
        }
    }
}

#Preview {
    let manager = RoundProgressionManager()
    manager.createBossState()
    return BossArenaView(progressionManager: manager, round: .amazon)
}
