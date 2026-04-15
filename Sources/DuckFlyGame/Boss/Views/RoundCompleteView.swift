import SwiftUI

struct RoundCompleteView: View {
    @ObservedObject var progressionManager: RoundProgressionManager
    let round: BossRound
    var onContinue: () -> Void = {}

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: round.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Confetti effect (simple falling circles)
                ForEach(0..<20, id: \.self) { index in
                    Circle()
                        .fill(Color(hue: Double(index) / 20, saturation: 0.8, brightness: 0.9))
                        .frame(width: 8, height: 8)
                        .offset(
                            x: CGFloat.random(in: -100...100),
                            y: -CGFloat.random(in: 0...300)
                        )
                        .transition(.move(edge: .top))
                }

                Text("VICTORY!")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(1.2)

                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Text(round.bossEmoji)
                            .font(.system(size: 40))
                        Text("Defeated \(round.bossName)")
                            .font(.headline)
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Food Points:")
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text("+\(progressionManager.foodBattlePoints * 10)")
                                .font(.headline)
                                .foregroundColor(.yellow)
                        }
                        Divider()
                            .background(Color.white.opacity(0.3))
                        HStack {
                            Text("Total Score:")
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text("\(progressionManager.totalScore)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                }

                if let cosmetic = DuckCosmetic.forRound(round) {
                    VStack(spacing: 8) {
                        Text("NEW COSMETIC UNLOCKED!")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        HStack(spacing: 12) {
                            Text(cosmetic.hatEmoji)
                                .font(.system(size: 40))
                            VStack(alignment: .leading) {
                                Text(cosmetic.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(cosmetic.description)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                    }
                }

                Spacer()

                Button(action: {
                    progressionManager.advanceToNextRound()
                    onContinue()
                }) {
                    Text("NEXT")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.7))
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    RoundCompleteView(
        progressionManager: RoundProgressionManager(),
        round: .amazon
    )
}
