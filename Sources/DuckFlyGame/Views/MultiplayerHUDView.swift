import SwiftUI

/// HUD for multiplayer game showing scores and timer
struct MultiplayerHUDView: View {
    @ObservedObject var gameManager: MultiplayerGameManager

    var body: some View {
        ResponsiveHUD(gameManager: gameManager)
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
