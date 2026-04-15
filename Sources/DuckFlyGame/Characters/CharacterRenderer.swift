import SwiftUI

/// Renders animal characters as SwiftUI views
struct CharacterView: View {
    let character: AnimalCharacter
    let teamColor: Color
    let size: CGFloat
    let showIdleAnimation: Bool

    @State private var isAnimating = false

    var body: some View {
        VStack {
            Text(character.emoji)
                .font(.system(size: size))
                .offset(y: showIdleAnimation && isAnimating ? -3 : 0)
                .onAppear {
                    if showIdleAnimation {
                        withAnimation(.easeInOut(duration: 0.8).repeatForever()) {
                            isAnimating = true
                        }
                    }
                }
        }
        .frame(width: size, height: size)
        .padding(8)
        .background(teamColor.opacity(0.2))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(teamColor, lineWidth: 2)
        )
    }
}

/// Character selection card
struct CharacterSelectionCard: View {
    let character: AnimalCharacter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Text(character.emoji)
                .font(.system(size: 48))

            Text(character.displayName)
                .font(.headline)
                .foregroundColor(ColorTheme.textPrimary)

            VStack(alignment: .leading, spacing: 4) {
                Label(
                    "Speed: \(String(format: "%.1f", character.stats.speedMultiplier))x",
                    systemImage: "hare.fill"
                )
                .font(.caption)
                .foregroundColor(ColorTheme.textSecondary)

                Label(
                    "Size: \(Int(character.stats.hitboxSize))pt",
                    systemImage: "circle.fill"
                )
                .font(.caption)
                .foregroundColor(ColorTheme.textSecondary)

                Label(
                    character.stats.specialAbility.description,
                    systemImage: "star.fill"
                )
                .font(.caption)
                .foregroundColor(ColorTheme.success)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
            .background(ColorTheme.veryLightBackground)
            .cornerRadius(8)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(ColorTheme.lightBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? ColorTheme.primaryAction : ColorTheme.secondary, lineWidth: 3)
        )
        .shadow(radius: 4)
        .onTapGesture(perform: action)
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    VStack(spacing: 16) {
        CharacterView(character: .duck, teamColor: ColorTheme.primaryAction, size: 60, showIdleAnimation: true)
        CharacterSelectionCard(character: .bunny, isSelected: true, action: {})
    }
    .padding()
    .background(ColorTheme.skyGradient())
}
#endif
