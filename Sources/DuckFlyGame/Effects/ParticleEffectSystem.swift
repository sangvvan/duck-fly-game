import SwiftUI

/// Comprehensive particle effect system for visual feedback
class ParticleEffectSystem: ObservableObject {
    @Published var activeEffects: [ParticleEffect] = []

    struct ParticleEffect: Identifiable {
        let id = UUID()
        let type: EffectType
        let position: CGPoint
        let color: Color
        let duration: TimeInterval
        let createdAt: Date

        enum EffectType {
            case teamCombo
            case powerUpCollection
            case scoreMultiplier
            case shieldImpact
            case characterAbility
        }
    }

    func addTeamComboEffect(at position: CGPoint, teamColor: Color) {
        let effect = ParticleEffect(
            type: .teamCombo,
            position: position,
            color: teamColor,
            duration: 1.0,
            createdAt: Date()
        )
        withAnimation {
            activeEffects.append(effect)
        }
        removeAfter(effect, duration: 1.2)
    }

    func addPowerUpEffect(at position: CGPoint, powerUpType: PowerUpType) {
        let effect = ParticleEffect(
            type: .powerUpCollection,
            position: position,
            color: powerUpType.primaryColor,
            duration: 0.8,
            createdAt: Date()
        )
        withAnimation {
            activeEffects.append(effect)
        }
        removeAfter(effect, duration: 1.0)
    }

    func addScoreMultiplierEffect(at position: CGPoint) {
        let effect = ParticleEffect(
            type: .scoreMultiplier,
            position: position,
            color: ColorTheme.primaryAction,
            duration: 1.2,
            createdAt: Date()
        )
        withAnimation {
            activeEffects.append(effect)
        }
        removeAfter(effect, duration: 1.5)
    }

    func addShieldImpactEffect(at position: CGPoint) {
        let effect = ParticleEffect(
            type: .shieldImpact,
            position: position,
            color: Color(red: 0.267, green: 0.608, blue: 0.859),
            duration: 0.6,
            createdAt: Date()
        )
        withAnimation {
            activeEffects.append(effect)
        }
        removeAfter(effect, duration: 0.8)
    }

    func addCharacterAbilityEffect(at position: CGPoint, color: Color) {
        let effect = ParticleEffect(
            type: .characterAbility,
            position: position,
            color: color,
            duration: 0.7,
            createdAt: Date()
        )
        withAnimation {
            activeEffects.append(effect)
        }
        removeAfter(effect, duration: 0.9)
    }

    private func removeAfter(_ effect: ParticleEffect, duration: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.activeEffects.removeAll { $0.id == effect.id }
            }
        }
    }
}

/// Rendered particle burst effect
struct ParticleBurstView: View {
    let effect: ParticleEffectSystem.ParticleEffect
    @State private var particles: [Particle] = []
    @State private var isAnimating = false

    struct Particle: Identifiable {
        let id = UUID()
        let angle: Double
        let distance: CGFloat
        var offset: CGPoint = .zero
        var opacity: Double = 1.0
    }

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                ParticleView(
                    type: effect.type,
                    color: effect.color,
                    offset: particle.offset,
                    opacity: particle.opacity
                )
                .position(
                    CGPoint(
                        x: effect.position.x + particle.offset.x,
                        y: effect.position.y + particle.offset.y
                    )
                )
            }

            // Central burst effect
            CircleBurstView(color: effect.color)
                .position(effect.position)
        }
        .onAppear {
            generateParticles()
            startAnimation()
        }
    }

    private func generateParticles() {
        let particleCount: Int
        switch effect.type {
        case .teamCombo:
            particleCount = 16
        case .powerUpCollection:
            particleCount = 12
        case .scoreMultiplier:
            particleCount = 8
        case .shieldImpact:
            particleCount = 10
        case .characterAbility:
            particleCount = 12
        }

        particles = (0..<particleCount).map { index in
            let angle = Double(index) * 360.0 / Double(particleCount)
            let distance: CGFloat = effect.type == .teamCombo ? 120 : 80
            return Particle(angle: angle, distance: distance)
        }
    }

    private func startAnimation() {
        withAnimation(.easeOut(duration: effect.duration)) {
            isAnimating = true
            particles = particles.map { particle in
                let radians = particle.angle * .pi / 180.0
                let distance = particle.distance
                return Particle(
                    angle: particle.angle,
                    distance: distance,
                    offset: CGPoint(
                        x: distance * cos(radians),
                        y: distance * sin(radians)
                    ),
                    opacity: 0
                )
            }
        }
    }
}

/// Individual particle view
struct ParticleView: View {
    let type: ParticleEffectSystem.ParticleEffect.EffectType
    let color: Color
    let offset: CGPoint
    let opacity: Double

    var body: some View {
        Group {
            switch type {
            case .teamCombo:
                Image(systemName: "star.fill")
                    .font(.system(size: 8))
                    .foregroundColor(color)

            case .powerUpCollection:
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)

            case .scoreMultiplier:
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(color)

            case .shieldImpact:
                Image(systemName: "shield.fill")
                    .font(.system(size: 8))
                    .foregroundColor(color)

            case .characterAbility:
                Circle()
                    .fill(color)
                    .frame(width: 5, height: 5)
            }
        }
        .opacity(opacity)
    }
}

/// Central burst effect that radiates outward
struct CircleBurstView: View {
    let color: Color
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1.0

    var body: some View {
        Circle()
            .stroke(color, lineWidth: 2)
            .frame(width: 40 * scale, height: 40 * scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    scale = 3.0
                    opacity = 0
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
            // Team Combo effect
            let comboEffect = ParticleEffectSystem.ParticleEffect(
                type: .teamCombo,
                position: CGPoint(x: 100, y: 100),
                color: ColorTheme.primaryAction,
                duration: 1.0,
                createdAt: Date()
            )
            ParticleBurstView(effect: comboEffect)

            // Power-up effect
            let powerUpEffect = ParticleEffectSystem.ParticleEffect(
                type: .powerUpCollection,
                position: CGPoint(x: 100, y: 300),
                color: PowerUpType.doublePoints.primaryColor,
                duration: 0.8,
                createdAt: Date()
            )
            ParticleBurstView(effect: powerUpEffect)
        }
    }
}
#endif
