import SwiftUI

/// Particle for burst effects
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let velocity: CGVector
    let color: Color
    var opacity: Double = 1.0
    var scale: CGFloat = 1.0
    let duration: TimeInterval = 0.6
}

/// Particle emitter for food collection
class ParticleEmitter: ObservableObject {
    @Published var particles: [Particle] = []

    func emit(at position: CGPoint, foodType: FoodType, count: Int = 10) {
        let color = foodType.primaryColor

        for _ in 0..<count {
            let angle = CGFloat.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: 50...150)
            let velocity = CGVector(
                dx: cos(angle) * speed,
                dy: sin(angle) * speed
            )

            let particle = Particle(
                position: position,
                velocity: velocity,
                color: color
            )

            withAnimation(.easeOut(duration: particle.duration)) {
                particles.append(particle)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + particle.duration) {
                self.particles.removeAll { $0.id == particle.id }
            }
        }
    }

    func updateParticles(deltaTime: TimeInterval) {
        for i in 0..<particles.count {
            let progress = min(1.0, deltaTime / particles[i].duration)
            particles[i].position.x += particles[i].velocity.dx * CGFloat(deltaTime)
            particles[i].position.y += particles[i].velocity.dy * CGFloat(deltaTime)
            particles[i].opacity = 1.0 - progress
            particles[i].scale = 1.0 - (progress * 0.5)
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack {
            Text("Particle Effects")
                .font(.title)
                .foregroundColor(ColorTheme.textPrimary)

            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 60, height: 60)

                ForEach(0..<10, id: \.self) { i in
                    Circle()
                        .fill(ColorTheme.success)
                        .frame(width: 6, height: 6)
                        .offset(
                            x: cos(CGFloat(i) * 0.628) * CGFloat(20 + i * 2),
                            y: sin(CGFloat(i) * 0.628) * CGFloat(20 + i * 2)
                        )
                }
            }

            Text("Burst animation on collection")
                .font(.caption)
                .foregroundColor(ColorTheme.textSecondary)
        }
        .padding()
    }
}
