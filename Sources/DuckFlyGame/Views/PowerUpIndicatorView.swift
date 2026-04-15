import SwiftUI

/// Displays active power-up indicator with countdown
struct PowerUpIndicatorView: View {
    let powerUp: ActivePowerUp

    @State private var remainingTime: Double = 0
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: iconForPowerUp(powerUp.type))
                    .font(.system(size: 12, weight: .semibold))

                Text(powerUp.type.displayName)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(colorForPowerUp(powerUp.type))
            .cornerRadius(6)

            // Countdown ring
            ZStack {
                Circle()
                    .stroke(colorForPowerUp(powerUp.type).opacity(0.3), lineWidth: 2)

                Circle()
                    .trim(from: 0, to: min(1.0, remainingTime / powerUp.type.duration))
                    .stroke(colorForPowerUp(powerUp.type), style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                Text(String(format: "%.1f", max(0, remainingTime)))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
            }
            .frame(width: 32, height: 32)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startTimer() {
        remainingTime = powerUp.remainingTime
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            remainingTime = powerUp.remainingTime
            if remainingTime <= 0 {
                timer?.invalidate()
            }
        }
    }

    private func colorForPowerUp(_ type: PowerUpType) -> Color {
        switch type {
        case .speedBoost:
            return Color(red: 1.0, green: 0.843, blue: 0.0) // Yellow
        case .doublePoints:
            return Color(red: 1.0, green: 0.420, blue: 0.420) // Coral Red
        case .shield:
            return Color(red: 0.267, green: 0.608, blue: 0.859) // Blue
        case .starFood:
            return Color(red: 1.0, green: 0.843, blue: 0.0) // Gold
        }
    }

    private func iconForPowerUp(_ type: PowerUpType) -> String {
        switch type {
        case .speedBoost:
            return "bolt.fill"
        case .doublePoints:
            return "star.fill"
        case .shield:
            return "shield.fill"
        case .starFood:
            return "sparkles"
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    let powerUp = ActivePowerUp(type: .doublePoints, startTime: Date())
    return PowerUpIndicatorView(powerUp: powerUp)
        .padding()
        .background(ColorTheme.lightBackground)
}
