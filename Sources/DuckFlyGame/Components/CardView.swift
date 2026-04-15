import SwiftUI

/// Reusable card component with consistent styling
struct CardView<Content: View>: View {
    let content: Content
    var backgroundColor: Color = ColorTheme.lightBackground
    var borderColor: Color = ColorTheme.veryLightBackground
    var showBorder: Bool = true
    var shadowOpacity: CGFloat = 0.2

    init(
        backgroundColor: Color = ColorTheme.lightBackground,
        borderColor: Color = ColorTheme.veryLightBackground,
        showBorder: Bool = true,
        shadowOpacity: CGFloat = 0.2,
        @ViewBuilder content: () -> Content
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.showBorder = showBorder
        self.shadowOpacity = shadowOpacity
        self.content = content()
    }

    var body: some View {
        content
            .padding(GameConstants.UI.standardPadding)
            .background(backgroundColor)
            .cornerRadius(GameConstants.UI.standardCornerRadius)
            .overlay(
                showBorder ?
                RoundedRectangle(cornerRadius: GameConstants.UI.standardCornerRadius)
                    .stroke(borderColor, lineWidth: 1) :
                nil
            )
            .shadow(
                color: Color.black.opacity(shadowOpacity),
                radius: 4,
                x: 0,
                y: 2
            )
    }
}

/// Convenience wrapper for common card patterns
struct SimpleCardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        CardView {
            content
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack(spacing: 16) {
            CardView {
                VStack(spacing: 8) {
                    Text("Simple Card")
                        .font(.headline)
                        .foregroundColor(ColorTheme.textPrimary)
                    Text("This is a reusable card component")
                        .font(.caption)
                        .foregroundColor(ColorTheme.textSecondary)
                }
            }

            SimpleCardView {
                Text("Without border")
                    .font(.headline)
                    .foregroundColor(ColorTheme.textPrimary)
            }
        }
        .padding()
    }
}
#endif
