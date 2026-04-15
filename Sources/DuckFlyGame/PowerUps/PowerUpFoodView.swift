import SwiftUI

/// Visual representation of power-up food items with animated effects
struct PowerUpFoodView: View {
    let type: PowerUpType
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.6

    var body: some View {
        ZStack {
            // Glow effect
            Circle()
                .fill(type.primaryColor.opacity(glowOpacity))
                .frame(width: type.size * 1.3, height: type.size * 1.3)
                .blur(radius: 4)

            // Main shape
            ZStack {
                switch type {
                case .speedBoost:
                    speedBoostView
                case .doublePoints:
                    doublePointsView
                case .shield:
                    shieldView
                case .starFood:
                    starFoodView
                }
            }
            .frame(width: type.size, height: type.size)
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(scale)

            // Particle ring
            Circle()
                .stroke(type.primaryColor.opacity(0.3), lineWidth: 1)
                .frame(width: type.size * 0.8, height: type.size * 0.8)
                .scaleEffect(scale)
        }
        .frame(width: type.size * 1.5, height: type.size * 1.5)
        .shadow(color: type.primaryColor.opacity(0.5), radius: 6, x: 0, y: 2)
        .onAppear {
            startAnimations()
        }
    }

    @ViewBuilder
    private var speedBoostView: some View {
        ZStack {
            // Lightning bolt
            Canvas { context, size in
                var path = Path()
                path.move(to: CGPoint(x: 0, y: -type.size * 0.4))
                path.addLine(to: CGPoint(x: type.size * 0.15, y: -type.size * 0.05))
                path.addLine(to: CGPoint(x: 0, y: type.size * 0.2))
                path.addLine(to: CGPoint(x: -type.size * 0.15, y: 0))
                path.addLine(to: CGPoint(x: 0, y: -type.size * 0.3))
                path.closeSubpath()

                context.stroke(
                    path,
                    with: .color(type.primaryColor),
                    lineWidth: type.size * 0.08
                )
            }

            // Inner glow
            Circle()
                .fill(type.primaryColor.opacity(0.3))
                .frame(width: type.size * 0.4, height: type.size * 0.4)
        }
    }

    @ViewBuilder
    private var doublePointsView: some View {
        ZStack {
            // Gem shape (hexagon approximation)
            Canvas { context, size in
                let sides = 6
                var path = Path()
                for i in 0..<sides {
                    let angle = CGFloat(i) * .pi * 2 / CGFloat(sides)
                    let x = type.size * 0.35 * cos(angle)
                    let y = type.size * 0.35 * sin(angle)

                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                path.closeSubpath()

                context.fill(path, with: .color(type.primaryColor))
                context.stroke(path, with: .color(.white.opacity(0.5)), lineWidth: 1)
            }

            // Shine effect
            Ellipse()
                .fill(Color.white.opacity(0.4))
                .frame(width: type.size * 0.2, height: type.size * 0.15)
                .offset(x: -type.size * 0.1, y: -type.size * 0.1)
        }
    }

    @ViewBuilder
    private var shieldView: some View {
        ZStack {
            // Shield hexagon
            Canvas { context, size in
                let path = createHexagonPath(size: type.size * 0.35)
                context.stroke(path, with: .color(type.primaryColor), lineWidth: 2)
            }

            // Shield interior
            Canvas { context, size in
                let path = createHexagonPath(size: type.size * 0.3)
                context.fill(path, with: .color(type.primaryColor.opacity(0.2)))
            }

            // Center dot
            Circle()
                .fill(type.primaryColor)
                .frame(width: type.size * 0.1, height: type.size * 0.1)
        }
    }

    @ViewBuilder
    private var starFoodView: some View {
        ZStack {
            // Star shape
            Canvas { context, size in
                let path = createStarPath(size: type.size * 0.35)
                context.fill(path, with: .color(type.primaryColor))
                context.stroke(path, with: .color(.white.opacity(0.6)), lineWidth: 1.5)
            }

            // Inner star for depth
            Canvas { context, size in
                let path = createStarPath(size: type.size * 0.15)
                context.fill(path, with: .color(.white.opacity(0.7)))
            }
        }
    }

    private func startAnimations() {
        // Continuous rotation
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotation = 360
        }

        // Pulsing scale
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            scale = 1.1
        }

        // Pulsing glow
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowOpacity = 0.9
        }
    }

    private func createHexagonPath(size: CGFloat) -> Path {
        var path = Path()
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi * 2 / 6
            let x = size * cos(angle)
            let y = size * sin(angle)

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }

    private func createStarPath(size: CGFloat) -> Path {
        var path = Path()
        let points = 5
        for i in 0..<points * 2 {
            let radius = (i % 2 == 0) ? size : size * 0.5
            let angle = CGFloat(i) * .pi / CGFloat(points) - .pi / 2
            let x = radius * cos(angle)
            let y = radius * sin(angle)

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack(spacing: 32) {
        Text("Power-Up Foods")
            .font(.title)
            .foregroundColor(ColorTheme.textPrimary)

        HStack(spacing: 24) {
            VStack(spacing: 8) {
                PowerUpFoodView(type: .speedBoost)
                Text("Speed Boost")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textPrimary)
            }

            VStack(spacing: 8) {
                PowerUpFoodView(type: .doublePoints)
                Text("2x Points")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textPrimary)
            }

            VStack(spacing: 8) {
                PowerUpFoodView(type: .shield)
                Text("Shield")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textPrimary)
            }

            VStack(spacing: 8) {
                PowerUpFoodView(type: .starFood)
                Text("Star")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textPrimary)
            }
        }
        .padding()
    }
    .padding()
    .background(ColorTheme.skyGradient())
}
