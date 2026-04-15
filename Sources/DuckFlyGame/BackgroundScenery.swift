import SwiftUI

/// Animated cloud shape
struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height

        // Left bump
        path.addCurve(
            to: CGPoint(x: width * 0.3, y: height * 0.5),
            control1: CGPoint(x: 0, y: height * 0.3),
            control2: CGPoint(x: width * 0.1, y: height * 0.1)
        )

        // Middle bump
        path.addCurve(
            to: CGPoint(x: width * 0.7, y: height * 0.5),
            control1: CGPoint(x: width * 0.4, y: 0),
            control2: CGPoint(x: width * 0.6, y: 0)
        )

        // Right bump
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.4),
            control1: CGPoint(x: width * 0.8, y: height * 0.1),
            control2: CGPoint(x: width * 0.95, y: height * 0.2)
        )

        // Bottom
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }
}

/// Background with parallax clouds
struct BackgroundScenery: View {
    @State private var offset1: CGFloat = 0
    @State private var offset2: CGFloat = 0
    @State private var offset3: CGFloat = 0

    var body: some View {
        ZStack {
            // Back layer clouds (slowest)
            CloudShape()
                .fill(Color.white.opacity(0.15))
                .frame(height: 60)
                .offset(x: offset1)
                .ignoresSafeArea()

            // Middle layer clouds
            CloudShape()
                .fill(Color.white.opacity(0.25))
                .frame(height: 80)
                .offset(x: offset2, y: 100)
                .ignoresSafeArea()

            // Front layer clouds (fastest)
            CloudShape()
                .fill(Color.white.opacity(0.35))
                .frame(height: 100)
                .offset(y: 250, x: offset3)
                .ignoresSafeArea()
        }
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        // Slow cloud animation
        withAnimation(
            .linear(duration: 20)
                .repeatForever(autoreverses: false)
        ) {
            offset1 = 400
        }

        // Medium cloud animation
        withAnimation(
            .linear(duration: 15)
                .repeatForever(autoreverses: false)
        ) {
            offset2 = 400
        }

        // Fast cloud animation
        withAnimation(
            .linear(duration: 10)
                .repeatForever(autoreverses: false)
        ) {
            offset3 = 400
        }
    }
}

#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        BackgroundScenery()

        VStack {
            Text("Parallax Cloud Animation")
                .font(.title)
                .foregroundColor(ColorTheme.textPrimary)
                .padding()

            Spacer()
        }
    }
}
