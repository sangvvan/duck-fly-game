import SwiftUI

/// Game over screen for multiplayer
struct MultiplayerGameOverView: View {
    @ObservedObject var flowCoordinator: MultiplayerFlowCoordinator

    private var gameManager: MultiplayerGameManager? {
        flowCoordinator.gameManager
    }

    private var winningTeam: TeamState? {
        gameManager?.winningTeam
    }

    var body: some View {
        ZStack {
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            // Victory parade effect
            if let winningTeam = winningTeam {
                VictoryParadeView(winningTeam: winningTeam)
            }

            VStack(spacing: 32) {
                VStack(spacing: 12) {
                    if let winningTeam = winningTeam {
                        ScoreCounterView(finalScore: winningTeam.totalScore)
                    }
                }
                .padding(.top, 40)

                // Team scores
                VStack(spacing: 12) {
                    ForEach(gameManager?.teams ?? [], id: \.id) { team in
                        HStack {
                            Circle()
                                .fill(TeamColorTheme.teamColor(team.teamIdentifier))
                                .frame(width: 16, height: 16)

                            Text("Team \(team.teamIdentifier.rawValue)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(ColorTheme.textPrimary)

                            Spacer()

                            Text("\(team.totalScore)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(ColorTheme.textPrimary)
                        }
                        .padding(12)
                        .background(ColorTheme.lightBackground)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)

                // Player breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text("Player Stats")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)

                    ForEach(gameManager?.teams ?? [], id: \.id) { team in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Circle()
                                    .fill(TeamColorTheme.teamColor(team.teamIdentifier))
                                    .frame(width: 8, height: 8)

                                Text("Team \(team.teamIdentifier.rawValue)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(ColorTheme.textSecondary)
                            }

                            ForEach(team.members, id: \.id) { player in
                                HStack {
                                    Text(player.character.emoji)

                                    Text(player.character.displayName)
                                        .font(.system(size: 12))
                                        .foregroundColor(ColorTheme.textPrimary)

                                    Spacer()

                                    Text("\(player.score)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(ColorTheme.textPrimary)
                                }
                                .padding(.leading, 20)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(ColorTheme.veryLightBackground)
                .cornerRadius(12)
                .padding(.horizontal, 24)

                Spacer()

                VStack(spacing: 12) {
                    Button(action: { flowCoordinator.playAgain() }) {
                        Text("Play Again")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.white)
                            .background(ColorTheme.primaryAction)
                            .cornerRadius(12)
                    }

                    Button(action: { flowCoordinator.returnToMainMenu() }) {
                        Text("Main Menu")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(ColorTheme.textPrimary)
                            .background(ColorTheme.lightBackground)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    let coordinator = MultiplayerFlowCoordinator()
    coordinator.selectedMode = .oneVsOne
    coordinator.playerSelections = [0: .duck, 1: .bunny]
    coordinator.startGame()
    coordinator.gameManager?.teams[0].totalScore = 250
    coordinator.gameManager?.teams[1].totalScore = 180

    return MultiplayerGameOverView(flowCoordinator: coordinator)
}
