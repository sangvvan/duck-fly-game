import SwiftUI

/// View for players to select their characters
struct CharacterSelectionView: View {
    @ObservedObject var flowCoordinator: MultiplayerFlowCoordinator

    @State private var currentPlayerIndex = 0

    private var currentPlayer: Int {
        currentPlayerIndex
    }

    private var playerCount: Int {
        flowCoordinator.selectedMode?.playerCount ?? 0
    }

    private var teamForPlayer: TeamIdentifier {
        let playersPerTeam = flowCoordinator.selectedMode?.playersPerTeam ?? 1
        return currentPlayerIndex < playersPerTeam ? .red : .blue
    }

    var body: some View {
        ZStack {
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Player \(currentPlayer + 1) of \(playerCount)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorTheme.textSecondary)

                    Text("Select Your Character")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)

                    HStack {
                        Circle()
                            .fill(TeamColorTheme.teamColor(teamForPlayer))
                            .frame(width: 12, height: 12)

                        Text("Team \(teamForPlayer.rawValue)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(AnimalCharacter.allCases, id: \.self) { character in
                            CharacterSelectionCard(
                                character: character,
                                isSelected: flowCoordinator.playerSelections[currentPlayer] == character,
                                action: {
                                    flowCoordinator.selectCharacterForPlayer(currentPlayer, character: character)
                                    advanceToNextPlayer()
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
            .padding(.top, 24)
        }
    }

    private func advanceToNextPlayer() {
        if currentPlayerIndex < playerCount - 1 {
            currentPlayerIndex += 1
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    let coordinator = MultiplayerFlowCoordinator()
    coordinator.selectedMode = .oneVsOne
    return CharacterSelectionView(flowCoordinator: coordinator)
}
