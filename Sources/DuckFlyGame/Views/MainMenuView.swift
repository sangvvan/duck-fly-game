import SwiftUI

/// Main menu for selecting between Solo and Multiplayer modes
struct MainMenuView: View {
    @Binding var gameState: GameScreenState

    var body: some View {
        ZStack {
            ColorTheme.skyGradient()
                .ignoresSafeArea()

            VStack(spacing: 40) {
                VStack(spacing: 16) {
                    Text("🦆")
                        .font(.system(size: 80))

                    Text("DUCK FLY")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)

                    Text("Multiplayer Edition")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .padding(.top, 40)

                VStack(spacing: 16) {
                    Button(action: { gameState = .levelMap }) {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Solo Play")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(.white)
                        .background(ColorTheme.primaryAction)
                        .cornerRadius(12)
                    }

                    Button(action: { gameState = .multiplayerSetup }) {
                        HStack {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Multiplayer")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(.white)
                        .background(ColorTheme.secondary)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 32)

                Spacer()
            }
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    MainMenuView(gameState: .constant(.mainMenu))
}
#endif
