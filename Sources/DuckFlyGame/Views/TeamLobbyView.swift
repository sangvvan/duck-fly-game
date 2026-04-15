import SwiftUI

/// Team lobby view showing lineups before game starts
struct TeamLobbyView: View {
    @ObservedObject var flowCoordinator: MultiplayerFlowCoordinator

    @State private var showCountdown = false
    @State private var countdown = 3

    var body: some View {
        ZStack {
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Text("Game Ready")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)

                HStack(spacing: 24) {
                    TeamLineupView(
                        team: .red,
                        players: flowCoordinator.gameManager?.teams
                            .first { $0.teamIdentifier == .red }?.members ?? []
                    )

                    Divider()
                        .frame(maxHeight: 200)

                    TeamLineupView(
                        team: .blue,
                        players: flowCoordinator.gameManager?.teams
                            .first { $0.teamIdentifier == .blue }?.members ?? []
                    )
                }
                .padding(.horizontal, 24)

                Spacer()

                if !showCountdown {
                    Button(action: {
                        withAnimation {
                            showCountdown = true
                            startCountdown()
                        }
                    }) {
                        Text("START MATCH")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundColor(.white)
                            .background(ColorTheme.primaryAction)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 24)
                } else {
                    Text("\(countdown)")
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(ColorTheme.primaryAction)
                }

                Spacer()
            }
            .padding(.top, 32)
        }
    }

    private func startCountdown() {
        countdown = 3
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdown -= 1
            if countdown <= 0 {
                timer.invalidate()
                flowCoordinator.startGame()
            }
        }
    }
}

struct TeamLineupView: View {
    let team: TeamIdentifier
    let players: [PlayerState]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Circle()
                    .fill(TeamColorTheme.teamColor(team))
                    .frame(width: 12, height: 12)

                Text("Team \(team.rawValue)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
            }

            VStack(spacing: 8) {
                ForEach(players, id: \.id) { player in
                    HStack(spacing: 8) {
                        Text(player.character.emoji)
                            .font(.system(size: 24))

                        Text(player.character.displayName)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ColorTheme.textPrimary)

                        Spacer()
                    }
                    .padding(8)
                    .background(ColorTheme.veryLightBackground)
                    .cornerRadius(8)
                }
            }
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    let coordinator = MultiplayerFlowCoordinator()
    coordinator.selectedMode = .oneVsOne
    coordinator.selectedDifficulty = .normal
    coordinator.playerSelections = [0: .duck, 1: .bunny]
    coordinator.startGame()
    return TeamLobbyView(flowCoordinator: coordinator)
}
