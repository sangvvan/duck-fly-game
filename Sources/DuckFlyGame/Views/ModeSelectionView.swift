import SwiftUI

/// View for selecting game mode (1v1, 2v2, 3v3)
struct ModeSelectionView: View {
    @ObservedObject var flowCoordinator: MultiplayerFlowCoordinator

    var body: some View {
        ZStack {
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Button(action: { flowCoordinator.returnToMainMenu() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryAction)
                    }
                    .padding(.bottom, 8)

                    Text("Select Game Mode")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)

                VStack(spacing: 12) {
                    ModeCard(
                        mode: .oneVsOne,
                        isSelected: flowCoordinator.selectedMode == .oneVsOne,
                        action: { flowCoordinator.selectMode(.oneVsOne) }
                    )

                    ModeCard(
                        mode: .twoVsTwo,
                        isSelected: flowCoordinator.selectedMode == .twoVsTwo,
                        action: { flowCoordinator.selectMode(.twoVsTwo) }
                    )

                    ModeCard(
                        mode: .threeVsThree,
                        isSelected: flowCoordinator.selectedMode == .threeVsThree,
                        action: { flowCoordinator.selectMode(.threeVsThree) }
                    )
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .padding(.top, 24)
        }
    }
}

struct ModeCard: View {
    let mode: GameMode
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.displayName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)

                    Text("\(mode.playerCount) players • \(mode.playersPerTeam) per team")
                        .font(.system(size: 14))
                        .foregroundColor(ColorTheme.textSecondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorTheme.success)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(ColorTheme.lightBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorTheme.success : ColorTheme.veryLightBackground, lineWidth: 2)
            )
        }
        .onTapGesture(perform: action)
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    ModeSelectionView(flowCoordinator: MultiplayerFlowCoordinator())
}
