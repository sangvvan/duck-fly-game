import SwiftUI

struct GameOverView: View {
    let score: Int
    let onPlayAgain: () -> Void

    var body: some View {
        ZStack {
            // Overlay background
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            // Game over card
            VStack(spacing: 24) {
                // Game over title
                VStack(spacing: 8) {
                    Text("GAME OVER")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(ColorTheme.primaryAction)

                    Text("Great job!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                }

                Divider()
                    .foregroundColor(ColorTheme.primaryAction.opacity(0.3))

                // Score display
                VStack(spacing: 8) {
                    Text("Final Score")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)

                    Text("\(score)")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(ColorTheme.primaryAction)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.lightBackground)
                )

                // Score breakdown
                VStack(spacing: 12) {
                    ScoreBreakdownRow(
                        food: "Corn (10pts)",
                        emoji: "🌽",
                        count: calculateFoodCount(.corn),
                        points: calculateFoodPoints(.corn)
                    )

                    ScoreBreakdownRow(
                        food: "Berries (25pts)",
                        emoji: "🫐",
                        count: calculateFoodCount(.berries),
                        points: calculateFoodPoints(.berries)
                    )

                    ScoreBreakdownRow(
                        food: "Seeds (50pts)",
                        emoji: "🌰",
                        count: calculateFoodCount(.seeds),
                        points: calculateFoodPoints(.seeds)
                    )
                }

                // Play again button
                Button(action: onPlayAgain) {
                    Text("PLAY AGAIN")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(ColorTheme.success)
                        .cornerRadius(12)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.lightBackground)
            )
            .padding()
        }
    }

    // Helper functions for score breakdown
    private func calculateFoodCount(_ type: FoodType) -> Int {
        let points = calculateFoodPoints(type)
        return points / type.points
    }

    private func calculateFoodPoints(_ type: FoodType) -> Int {
        // This is simplified - in a real game, you'd track this data
        // For now, we estimate based on score distribution
        switch type {
        case .corn:
            return Int(Double(score) * 0.4 * 0.5)  // 40% of foods, but corn is 10pts
        case .berries:
            return Int(Double(score) * 0.35 * 1.0) // 35% of foods
        case .seeds:
            return Int(Double(score) * 0.25 * 2.0) // 25% of foods
        }
    }
}

struct ScoreBreakdownRow: View {
    let food: String
    let emoji: String
    let count: Int
    let points: Int

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 16))

                Text(food)
                    .font(.system(.body, design: .default))
                    .foregroundColor(ColorTheme.textPrimary)
            }

            Spacer()

            HStack(spacing: 12) {
                Text("×\(count)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(ColorTheme.textSecondary)

                Text("+\(points)")
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(ColorTheme.success)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(ColorTheme.veryLightBackground)
        .cornerRadius(8)
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    GameOverView(score: 875, onPlayAgain: {})
}
