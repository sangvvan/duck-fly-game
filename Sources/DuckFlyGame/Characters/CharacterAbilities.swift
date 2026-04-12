import SwiftUI

/// Character special ability animations and effects
struct CharacterAbilityEffect: View {
    let character: AnimalCharacter
    let position: CGPoint
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            switch character {
            case .duck:
                duckComboEffect
            case .bunny:
                bunnyDoubleJumpEffect
            case .fox:
                foxMagnetEffect
            case .penguin:
                penguinWideCatchEffect
            case .squirrel:
                squirrelHoardEffect
            case .panda:
                pandaShieldEffect
            case .cat:
                catLuckyEffect
            case .frog:
                frogLeapEffect
            }
        }
        .position(position)
    }

    @ViewBuilder
    private var duckComboEffect: some View {
        // Combo glow that expands
        VStack {
            Circle()
                .stroke(ColorTheme.success, lineWidth: 2)
                .frame(width: isAnimating ? 120 : 60, height: isAnimating ? 120 : 60)
                .opacity(isAnimating ? 0 : 1)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }

    @ViewBuilder
    private var bunnyDoubleJumpEffect: some View {
        // Upward leap with bounce
        VStack {
            Circle()
                .fill(Color(red: 1.0, green: 0.529, blue: 0.808).opacity(0.6))
                .frame(width: 40, height: 40)
                .offset(y: isAnimating ? -80 : 0)

            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color(red: 1.0, green: 0.529, blue: 0.808).opacity(0.3))
                    .frame(width: 30 - CGFloat(index) * 8, height: 30 - CGFloat(index) * 8)
                    .offset(y: isAnimating ? CGFloat(-60 + index * 20) : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
    }

    @ViewBuilder
    private var foxMagnetEffect: some View {
        // Magnet pull arcs
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                Path { path in
                    let startAngle = CGFloat(index) * .pi / 2
                    path.addArc(
                        center: .zero,
                        radius: isAnimating ? 60 : 30,
                        startAngle: .degrees(Double(startAngle)),
                        endAngle: .degrees(Double(startAngle) + 45),
                        clockwise: false
                    )
                }
                .stroke(Color(red: 1.0, green: 0.549, blue: 0.0), lineWidth: 2)
                .opacity(isAnimating ? 0 : 1)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                isAnimating = true
            }
        }
    }

    @ViewBuilder
    private var penguinWideCatchEffect: some View {
        // Wide radius indicator
        Circle()
            .stroke(Color(red: 0.2, green: 0.2, blue: 0.2), lineWidth: 2)
            .frame(width: 120, height: 120)
            .opacity(isAnimating ? 0 : 0.6)
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    isAnimating = true
                }
            }
    }

    @ViewBuilder
    private var squirrelHoardEffect: some View {
        // Spinning coins/stars
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.545, green: 0.271, blue: 0.075))
                    .offset(x: 40 * cos(CGFloat(index) * .pi / 3), y: 40 * sin(CGFloat(index) * .pi / 3))
                    .opacity(isAnimating ? 0 : 1)
                    .scaleEffect(isAnimating ? 0.5 : 1.0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }

    @ViewBuilder
    private var pandaShieldEffect: some View {
        // Shield barrier
        ZStack {
            // Outer ring
            Circle()
                .stroke(Color(red: 0.0, green: 0.0, blue: 0.0), lineWidth: 3)
                .frame(width: 100, height: 100)

            // Inner glow
            Circle()
                .fill(Color(red: 0.0, green: 0.0, blue: 0.0).opacity(0.3))
                .frame(width: 90, height: 90)

            // Animated particles
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(Color(red: 0.0, green: 0.0, blue: 0.0).opacity(0.6))
                    .frame(width: 4, height: 4)
                    .offset(x: 50 * cos(CGFloat(index) * .pi / 4), y: 50 * sin(CGFloat(index) * .pi / 4))
                    .scaleEffect(isAnimating ? 0 : 1)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
    }

    @ViewBuilder
    private var catLuckyEffect: some View {
        // Lucky stars with sparkles
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 1.0, green: 0.843, blue: 0.0))
                    .offset(x: CGFloat.random(in: -50...50), y: CGFloat.random(in: -50...50))
                    .opacity(isAnimating ? 0 : 1)
                    .scaleEffect(isAnimating ? 0 : 1)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }

    @ViewBuilder
    private var frogLeapEffect: some View {
        // Teleport effect
        ZStack {
            // Circular waves
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(Color(red: 0.184, green: 0.843, blue: 0.451), lineWidth: 2)
                    .frame(width: isAnimating ? 100 + CGFloat(index) * 30 : 40, height: isAnimating ? 100 + CGFloat(index) * 30 : 40)
                    .opacity(isAnimating ? 0 : 1 - Double(index) * 0.3)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack(spacing: 40) {
            ForEach(AnimalCharacter.allCases, id: \.self) { character in
                HStack {
                    Text(character.emoji)
                        .font(.system(size: 24))
                    Text(character.displayName)
                        .font(.caption)
                    Spacer()
                    CharacterAbilityEffect(character: character, position: CGPoint(x: 0, y: 0))
                        .frame(width: 120, height: 120)
                }
                .padding()
                .background(ColorTheme.lightBackground)
                .cornerRadius(8)
            }
        }
        .padding()
    }
}
