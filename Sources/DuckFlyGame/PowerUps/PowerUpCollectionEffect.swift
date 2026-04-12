import SwiftUI

/// Visual effect when a power-up is collected
struct PowerUpCollectionEffect: View {
    let type: PowerUpType
    let position: CGPoint
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0

    var body: some View {
        VStack(spacing: 4) {
            Text(type.emoji)
                .font(.system(size: 32))

            Text(type.displayName)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(8)
        .background(type.primaryColor)
        .cornerRadius(8)
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                scale = 1.2
                opacity = 0
            }
        }
    }
}

/// Manager for power-up collection effects
class PowerUpEffectManager: ObservableObject {
    @Published var effects: [PowerUpEffect] = []

    struct PowerUpEffect: Identifiable {
        let id = UUID()
        let type: PowerUpType
        let position: CGPoint
        let createdAt: Date
    }

    func addEffect(type: PowerUpType, at position: CGPoint) {
        let effect = PowerUpEffect(type: type, position: position, createdAt: Date())
        withAnimation {
            effects.append(effect)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.effects.removeAll { $0.id == effect.id }
        }
    }
}

#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack(spacing: 40) {
            PowerUpCollectionEffect(type: .speedBoost, position: CGPoint(x: 100, y: 100))
            PowerUpCollectionEffect(type: .doublePoints, position: CGPoint(x: 200, y: 200))
            PowerUpCollectionEffect(type: .shield, position: CGPoint(x: 300, y: 300))
            PowerUpCollectionEffect(type: .starFood, position: CGPoint(x: 400, y: 400))
        }
    }
}
