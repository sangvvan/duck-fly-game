import SwiftUI

/// Duck animation state
enum DuckAnimationState {
    case idle
    case flying
    case eating
    case impact

    var duration: TimeInterval {
        switch self {
        case .idle: return 0.8
        case .flying: return 0.3
        case .eating: return 0.3
        case .impact: return 0.2
        }
    }
}

/// Animated duck character with multiple states
struct AnimatedDuckCharacter: View {
    @State private var isAnimating = false
    @State private var animationState: DuckAnimationState = .idle
    var size: CGFloat = 60
    var rotation: CGFloat = 0

    var body: some View {
        ZStack {
            // Duck body
            Ellipse()
                .fill(ColorTheme.duckBody)
                .frame(width: size * 0.67, height: size * 0.42)
                .offset(y: bodyOffset)

            // Duck head
            Circle()
                .fill(ColorTheme.duckBody)
                .frame(width: size * 0.58, height: size * 0.58)
                .offset(y: headOffset)

            // Duck beak
            UnevenRoundedRectangle(
                topLeadingRadius: size * 0.08,
                bottomLeadingRadius: size * 0.08
            )
            .fill(ColorTheme.duckBeak)
            .frame(width: size * 0.2, height: size * 0.1)
            .offset(x: size * 0.2, y: -size * 0.05 + headOffset)

            // Duck eye
            Circle()
                .fill(Color.black)
                .frame(width: size * 0.1, height: size * 0.1)
                .offset(x: size * 0.08, y: -size * 0.12 + headOffset)

            // Eye highlight
            Circle()
                .fill(Color.white)
                .frame(width: size * 0.04, height: size * 0.04)
                .offset(x: size * 0.11, y: -size * 0.14 + headOffset)

            // Wing animation
            Path { path in
                path.move(to: CGPoint(x: size * 0.15, y: wingOffsetY))
                path.addQuadCurve(
                    to: CGPoint(x: size * 0.25, y: size * 0.2 + wingOffsetY),
                    control: CGPoint(x: size * 0.35 + wingOffsetX, y: size * 0.05)
                )
            }
            .stroke(ColorTheme.duckBeak, lineWidth: size * 0.04)
        }
        .frame(width: size, height: size)
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            startIdleAnimation()
        }
    }

    private var bodyOffset: CGFloat {
        switch animationState {
        case .idle:
            return isAnimating ? -size * 0.03 : size * 0.03
        case .eating:
            return isAnimating ? size * 0.05 : 0
        default:
            return 0
        }
    }

    private var headOffset: CGFloat {
        switch animationState {
        case .idle:
            return isAnimating ? -size * 0.02 : size * 0.02
        case .eating:
            return isAnimating ? -size * 0.1 : 0
        default:
            return 0
        }
    }

    private var wingOffsetX: CGFloat {
        switch animationState {
        case .flying:
            return isAnimating ? size * 0.1 : -size * 0.1
        default:
            return 0
        }
    }

    private var wingOffsetY: CGFloat {
        switch animationState {
        case .flying:
            return isAnimating ? -size * 0.05 : size * 0.05
        default:
            return 0
        }
    }

    func startIdleAnimation() {
        animationState = .idle
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }

    func startFlyingAnimation() {
        animationState = .flying
        withAnimation(.easeInOut(duration: 0.3).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }

    func startEatingAnimation() {
        animationState = .eating
        withAnimation(.easeInOut(duration: 0.3)) {
            isAnimating = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.3)) {
                isAnimating = false
            }
        }
    }

    func startImpactAnimation() {
        animationState = .impact
        withAnimation(.linear(duration: 0.2).repeatCount(2, autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack(spacing: 40) {
            Text("Duck Animation States")
                .font(.title)
                .foregroundColor(ColorTheme.textPrimary)

            AnimatedDuckCharacter()

            VStack(spacing: 10) {
                Text("Idle: Bobbing animation")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)
                Text("Flying: Wing flapping")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)
                Text("Eating: Head bob down")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)
            }
        }
        .padding()
    }
}
