import SwiftUI

struct BossDeathView: View {
    @ObservedObject var progressionManager: RoundProgressionManager
    var onReturnToMap: () -> Void = {}

    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                Text("💀")
                    .font(.system(size: 80))

                Text("DEFEATED")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.red)

                Text("You ran out of HP")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                VStack(spacing: 12) {
                    Button(action: {
                        progressionManager.resetCurrentRound()
                    }) {
                        Text("Restart Round")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(10)
                    }

                    Button(action: {
                        progressionManager.phase = .gameOver
                        onReturnToMap()
                    }) {
                        Text("End Game")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.7))
                            .cornerRadius(10)
                    }
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
    BossDeathView(progressionManager: RoundProgressionManager())
}
#endif
