import SwiftUI

struct GameHUD: View {
    let score: Int
    let comboCount: Int
    let isComboActive: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Score display
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(ColorTheme.primaryAction)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Score")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)

                    Text("\(score)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.lightBackground)
            )

            // Combo meter (shown only if active)
            if isComboActive && comboCount > 0 {
                VStack(spacing: 6) {
                    HStack {
                        Text("🔥 Combo ×\(comboCount)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryAction)

                        Spacer()
                    }

                    // Combo progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(ColorTheme.success.opacity(0.3))

                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            ColorTheme.success,
                                            ColorTheme.primaryAction
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * min(Double(comboCount) / 10.0, 1.0))
                        }
                        .frame(height: 6)
                    }
                    .frame(height: 6)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.lightBackground)
                )
                .transition(.opacity.combined(with: .scale))
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack {
            GameHUD(score: 250, comboCount: 5, isComboActive: true)

            Spacer()
        }
    }
}
