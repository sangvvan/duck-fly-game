import SwiftUI

/// HUD for multiplayer game showing scores and timer
struct MultiplayerHUDView: View {
    @ObservedObject var gameManager: MultiplayerGameManager

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                // Team Red Score
                VStack(spacing: 4) {
                    Text("Team Red")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)

                    Text("\(gameManager.teams[0].totalScore)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(TeamColorTheme.teamColor(.red))

                // Timer
                VStack(spacing: 4) {
                    Text("TIME")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(ColorTheme.textPrimary)

                    Text(String(format: "%.1f", max(0, gameManager.remainingTime)))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(gameManager.remainingTime < 10 ? ColorTheme.danger : ColorTheme.textPrimary)
                        .monospacedDigit()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(ColorTheme.lightBackground)

                // Team Blue Score
                VStack(spacing: 4) {
                    Text("Team Blue")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)

                    Text("\(gameManager.teams[1].totalScore)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(TeamColorTheme.teamColor(.blue))
            }
            .shadow(radius: 4)

            Spacer()
        }
    }
}

#Preview {
    let gameManager = MultiplayerGameManager(gameMode: .oneVsOne)
    gameManager.teams[0].totalScore = 150
    gameManager.teams[1].totalScore = 120
    gameManager.remainingTime = 45.5

    return MultiplayerHUDView(gameManager: gameManager)
        .background(ColorTheme.skyGradient())
}
