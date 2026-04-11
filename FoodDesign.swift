import SwiftUI

/// Food type enum with point values and properties
enum FoodType {
    case corn
    case berries
    case seeds

    /// Points awarded for collecting this food
    var points: Int {
        switch self {
        case .corn: return 10
        case .berries: return 25
        case .seeds: return 50
        }
    }

    /// Speed modifier for falling (1.0 = normal)
    var speedModifier: CGFloat {
        switch self {
        case .corn: return 1.0
        case .berries: return 1.0
        case .seeds: return 1.2  // Seeds fall faster
        }
    }

    /// Size of the food item
    var size: CGFloat {
        switch self {
        case .corn: return 32
        case .berries: return 28
        case .seeds: return 24
        }
    }

    /// Spawn probability
    var spawnWeight: Double {
        switch self {
        case .corn: return 0.40    // 40%
        case .berries: return 0.35 // 35%
        case .seeds: return 0.25   // 25%
        }
    }

    /// Color used for particles and feedback
    var primaryColor: Color {
        switch self {
        case .corn: return ColorTheme.cornYellow
        case .berries: return ColorTheme.berriesPink
        case .seeds: return ColorTheme.seedsBrown
        }
    }
}

/// Visual representation of food items
struct FoodItemView: View {
    let type: FoodType
    @State private var rotation: Double = 0

    var body: some View {
        Group {
            switch type {
            case .corn:
                cornView

            case .berries:
                berriesView

            case .seeds:
                seedsView
            }
        }
        .frame(width: type.size, height: type.size)
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1)
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }

    @ViewBuilder
    private var cornView: some View {
        ZStack {
            // Main corn body
            Ellipse()
                .fill(ColorTheme.cornYellow)
                .frame(width: type.size * 0.7, height: type.size * 0.9)

            // Corn husk
            UnevenRoundedRectangle(
                topLeadingRadius: type.size * 0.2,
                topTrailingRadius: type.size * 0.15,
                bottomLeadingRadius: type.size * 0.1,
                bottomTrailingRadius: type.size * 0.1
            )
            .fill(ColorTheme.cornHusk)
            .frame(width: type.size * 0.3, height: type.size * 0.5)
            .offset(x: type.size * 0.15)

            // Corn detail lines
            ForEach(0..<3, id: \.self) { index in
                Path { path in
                    path.move(to: CGPoint(x: -type.size * 0.2, y: CGFloat(index - 1) * type.size * 0.15))
                    path.addLine(to: CGPoint(x: type.size * 0.2, y: CGFloat(index - 1) * type.size * 0.15))
                }
                .stroke(ColorTheme.cornHusk, lineWidth: type.size * 0.03)
            }
        }
    }

    @ViewBuilder
    private var berriesView: some View {
        ZStack {
            // Berry cluster (3 berries)
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.berriesPink)
                    .frame(width: type.size * 0.45, height: type.size * 0.45)
                    .offset(
                        x: CGFloat(index - 1) * type.size * 0.25,
                        y: CGFloat(index == 0 ? -1 : 1) * type.size * 0.15
                    )
            }

            // Dark outline for depth
            Circle()
                .stroke(ColorTheme.berriesDarkRed, lineWidth: type.size * 0.04)
                .frame(width: type.size * 0.85, height: type.size * 0.85)
        }
    }

    @ViewBuilder
    private var seedsView: some View {
        ZStack {
            // Seed main body
            Ellipse()
                .fill(ColorTheme.seedsBrown)
                .frame(width: type.size * 0.6, height: type.size * 0.8)

            // Seed highlight
            Ellipse()
                .fill(ColorTheme.seedsAccent)
                .frame(width: type.size * 0.25, height: type.size * 0.4)
                .offset(x: -type.size * 0.1, y: -type.size * 0.15)

            // Seed texture lines
            ForEach(0..<2, id: \.self) { index in
                Path { path in
                    path.move(to: CGPoint(x: -type.size * 0.15, y: CGFloat(index - 0.5) * type.size * 0.2))
                    path.addLine(to: CGPoint(x: type.size * 0.15, y: CGFloat(index - 0.5) * type.size * 0.2))
                }
                .stroke(ColorTheme.seedsAccent, lineWidth: type.size * 0.02)
            }
        }
    }
}

#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack(spacing: 40) {
            Text("Food Types Preview")
                .font(.title)
                .foregroundColor(ColorTheme.textPrimary)

            HStack(spacing: 30) {
                VStack(spacing: 10) {
                    FoodItemView(type: .corn)
                    VStack(spacing: 4) {
                        Text("Corn")
                            .font(.caption)
                            .foregroundColor(ColorTheme.textPrimary)
                        Text("10 pts (40%)")
                            .font(.caption2)
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }

                VStack(spacing: 10) {
                    FoodItemView(type: .berries)
                    VStack(spacing: 4) {
                        Text("Berries")
                            .font(.caption)
                            .foregroundColor(ColorTheme.textPrimary)
                        Text("25 pts (35%)")
                            .font(.caption2)
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }

                VStack(spacing: 10) {
                    FoodItemView(type: .seeds)
                    VStack(spacing: 4) {
                        Text("Seeds")
                            .font(.caption)
                            .foregroundColor(ColorTheme.textPrimary)
                        Text("50 pts (25%)")
                            .font(.caption2)
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}
