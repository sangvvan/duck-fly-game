import SwiftUI

struct StartMenuView: View {
    @Binding var gameState: GameScreenState
    @Binding var selectedDifficulty: GameDifficulty

    var body: some View {
        ZStack {
            // Background gradient
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Game title with duck
                VStack(spacing: 20) {
                    DuckCharacter(size: 120)

                    Text("DUCK FLY")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                }

                Spacer()

                // Difficulty selector
                VStack(spacing: 16) {
                    Text("Select Difficulty")
                        .font(.headline)
                        .foregroundColor(ColorTheme.textPrimary)

                    HStack(spacing: 12) {
                        ForEach(GameDifficulty.allCases, id: \.self) { difficulty in
                            VStack(spacing: 6) {
                                Text(difficulty.label)
                                    .font(.system(.caption, design: .default))
                                    .fontWeight(.semibold)

                                Text(difficulty.description)
                                    .font(.system(.caption2, design: .default))
                                    .foregroundColor(ColorTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        selectedDifficulty == difficulty
                                            ? ColorTheme.primaryAction
                                            : Color.white.opacity(0.8)
                                    )
                            )
                            .foregroundColor(
                                selectedDifficulty == difficulty
                                    ? .white
                                    : ColorTheme.textPrimary
                            )
                            .onTapGesture {
                                HapticManager.shared.selection()
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedDifficulty = difficulty
                                }
                            }
                            .accessibilityElement(
                                label: "\(difficulty.label) difficulty",
                                hint: difficulty.description
                            )
                        }
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Play button
                Button(action: {
                    HapticManager.shared.impact(.medium)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        gameState = .playing
                    }
                }) {
                    Text("PLAY")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ColorTheme.primaryAction)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .accessibilityElement(
                    label: "Play Game",
                    hint: "Start playing Duck Fly"
                )

                Spacer()
                    .frame(height: 40)
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var gameState: GameScreenState = .menu
    @Previewable @State var selectedDifficulty: GameDifficulty = .normal

    return ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        StartMenuView(gameState: $gameState, selectedDifficulty: $selectedDifficulty)
    }
}
