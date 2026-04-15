import SwiftUI

struct BossRoundIntroView: View {
    let round: BossRound
    @ObservedObject var progressionManager: RoundProgressionManager

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

                Text(round.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Text(round.emoji)
                    .font(.system(size: 80))

                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        Text(round.bossEmoji)
                            .font(.system(size: 60))
                        VStack(alignment: .leading) {
                            Text(round.bossName)
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("HP: \(round.bossHP)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                }

                Text(round.description)
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()

                Button(action: {
                    progressionManager.phase = .collecting
                }) {
                    Text("TAP TO START")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    BossRoundIntroView(
        round: .amazon,
        progressionManager: RoundProgressionManager()
    )
}
#endif
