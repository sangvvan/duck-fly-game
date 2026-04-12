import SwiftUI

/// Main multiplayer game view with split-screen gameplay
struct MultiplayerGameView: View {
    @ObservedObject var gameManager: MultiplayerGameManager
    @Environment(\.verticalSizeClass) var verticalSizeClass

    private var zoneHeight: CGFloat {
        UIScreen.main.bounds.height / CGFloat(gameManager.gameMode.playersPerTeam)
    }

    private var zoneWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    var body: some View {
        ZStack {
            // Game zones
            VStack(spacing: 0) {
                ForEach(Array(gameManager.teams.flatMap { $0.members }.enumerated()), id: \.element.id) { index, player in
                    let zoneMinX: CGFloat = 0

                    PlayerZoneView(
                        player: player,
                        gameSimulation: gameManager.gameSimulation,
                        zoneWidth: zoneWidth,
                        zoneHeight: zoneHeight,
                        zoneMinX: zoneMinX
                    )

                    if index < gameManager.teams.flatMap({ $0.members }).count - 1 {
                        Divider()
                            .frame(height: 1)
                            .background(ColorTheme.textPrimary.opacity(0.2))
                    }
                }
            }

            // HUD overlay
            MultiplayerHUDView(gameManager: gameManager)
        }
        .ignoresSafeArea()
        .onAppear {
            // Initialize player positions if needed
            for team in gameManager.teams {
                for player in team.members {
                    if player.position == .zero {
                        player.position = CGPoint(
                            x: zoneWidth / 2,
                            y: zoneHeight - 100
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    let gameManager = MultiplayerGameManager(gameMode: .oneVsOne)
    gameManager.teams[0].addMember(PlayerState(playerNumber: 0, team: .red, character: .duck))
    gameManager.teams[1].addMember(PlayerState(playerNumber: 1, team: .blue, character: .bunny))

    MultiplayerGameView(gameManager: gameManager)
}
