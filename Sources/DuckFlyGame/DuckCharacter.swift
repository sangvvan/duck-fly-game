import SwiftUI

/// Duck character view with animations
struct DuckCharacter: View {
    @State private var isAnimating = false
    var size: CGFloat = 60

    var body: some View {
        ZStack {
            // Duck body
            Ellipse()
                .fill(ColorTheme.duckBody)
                .frame(width: size * 0.67, height: size * 0.42)
                .offset(y: size * 0.08)

            // Duck head
            Circle()
                .fill(ColorTheme.duckBody)
                .frame(width: size * 0.58, height: size * 0.58)

            // Duck beak
            if #available(iOS 16.0, *) {
                UnevenRoundedRectangle(
                    topLeadingRadius: size * 0.08,
                    bottomLeadingRadius: size * 0.08
                )
                .fill(ColorTheme.duckBeak)
                .frame(width: size * 0.2, height: size * 0.1)
                .offset(x: size * 0.2, y: -size * 0.05)
            } else {
                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(ColorTheme.duckBeak)
                    .frame(width: size * 0.2, height: size * 0.1)
                    .offset(x: size * 0.2, y: -size * 0.05)
            }

            // Duck eye
            Circle()
                .fill(Color.black)
                .frame(width: size * 0.1, height: size * 0.1)
                .offset(x: size * 0.08, y: -size * 0.12)

            // Eye highlight
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.04, height: size * 0.04)
                .offset(x: size * 0.11, y: -size * 0.14)

            // Wing suggestion (right side)
            Path { path in
                path.move(to: CGPoint(x: size * 0.15, y: 0))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.25, y: size * 0.2),
                    control: CGPoint(x: size * 0.35, y: size * 0.05)
                )
            }
            .stroke(ColorTheme.duckBeak, lineWidth: size * 0.04)
        }
        .frame(width: size, height: size)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
        // Idle animation - gentle bobbing
        .offset(y: isAnimating ? -size * 0.03 : size * 0.03)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack(spacing: 40) {
            Text("Duck Character Preview")
                .font(.title)
                .foregroundColor(ColorTheme.textPrimary)

            DuckCharacter()

            VStack(spacing: 10) {
                Text("Size: 60x60pt")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)
                Text("Animation: Idle bobbing")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)
            }
        }
        .padding()
    }
}
