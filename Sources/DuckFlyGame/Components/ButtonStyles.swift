import SwiftUI

/// Primary action button style (coral red)
struct PrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, GameConstants.UI.largeButtonVerticalPadding)
            .foregroundColor(.white)
            .background(
                isEnabled ?
                ColorTheme.primaryAction :
                ColorTheme.primaryAction.opacity(0.5)
            )
            .cornerRadius(GameConstants.UI.standardCornerRadius)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

/// Secondary button style (teal)
struct SecondaryButtonStyle: ButtonStyle {
    let isEnabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, GameConstants.UI.largeButtonVerticalPadding)
            .foregroundColor(.white)
            .background(
                isEnabled ?
                ColorTheme.secondary :
                ColorTheme.secondary.opacity(0.5)
            )
            .cornerRadius(GameConstants.UI.standardCornerRadius)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

/// Attack button style (red with gradient)
struct AttackButtonStyle: ButtonStyle {
    let isEnabled: Bool
    let icon: String

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Text(icon)
                .font(.system(size: 24))
            configuration.label
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .foregroundColor(.white)
        .background(
            isEnabled ?
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.red.opacity(0.9),
                    Color.orange.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ) :
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.gray.opacity(0.5),
                    Color.gray.opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
        )
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

// MARK: - Convenience Extensions

extension Button {
    func primaryButtonStyle(isEnabled: Bool = true) -> some View {
        self.buttonStyle(PrimaryButtonStyle(isEnabled: isEnabled))
    }

    func secondaryButtonStyle(isEnabled: Bool = true) -> some View {
        self.buttonStyle(SecondaryButtonStyle(isEnabled: isEnabled))
    }

    func attackButtonStyle(isEnabled: Bool = true, icon: String = "⚔️") -> some View {
        self.buttonStyle(AttackButtonStyle(isEnabled: isEnabled, icon: icon))
    }
}
