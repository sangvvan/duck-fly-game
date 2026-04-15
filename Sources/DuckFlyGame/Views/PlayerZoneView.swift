import SwiftUI

/// Single player's zone in multiplayer game
struct PlayerZoneView: View {
    @ObservedObject var player: PlayerState
    @ObservedObject var gameSimulation: GameSimulation
    let zoneWidth: CGFloat
    let zoneHeight: CGFloat
    let zoneMinX: CGFloat

    @GestureState private var dragLocation: CGPoint = .zero

    var body: some View {
        ZStack {
            // Background
            VStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        ColorTheme.skyGradientStart.opacity(0.8),
                        ColorTheme.skyGradientEnd.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }

            // Food items in this zone
            ForEach(gameSimulation.foodItems, id: \.id) { food in
                if food.position.x >= zoneMinX && food.position.x < zoneMinX + zoneWidth {
                    if #available(iOS 16.0, *) {
                        FoodItemView(type: food.type)
                            .position(food.position)
                    }
                }
            }

            // Power-up items in this zone
            ForEach(gameSimulation.powerUpItems, id: \.id) { powerUp in
                if powerUp.position.x >= zoneMinX && powerUp.position.x < zoneMinX + zoneWidth {
                    PowerUpFoodView(type: powerUp.type)
                        .position(powerUp.position)
                }
            }

            // Player character (duck)
            CharacterView(
                character: player.character,
                teamColor: TeamColorTheme.teamColor(player.team),
                size: 60,
                showIdleAnimation: false
            )
            .position(player.position)

            // Player HUD
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(player.character.emoji)
                            .font(.system(size: 20))

                        Text("P\(player.playerNumber + 1)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(ColorTheme.textSecondary)

                        Text("\(player.score)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                    }
                    .padding(8)
                    .background(ColorTheme.lightBackground.opacity(0.9))
                    .cornerRadius(8)

                    Spacer()

                    if let powerUp = player.activePowerUp {
                        PowerUpIndicatorView(powerUp: powerUp)
                    }
                }
                .padding(12)

                Spacer()
            }
        }
        .frame(width: zoneWidth, height: zoneHeight)
        .gesture(
            DragGesture(minimumDistance: 0)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
                .onChanged { value in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        player.position = CGPoint(
                            x: max(zoneMinX + 30, min(zoneMinX + zoneWidth - 30, value.location.x)),
                            y: max(zoneHeight - 100, min(zoneHeight, value.location.y))
                        )
                    }
                }
        )
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    let player = PlayerState(playerNumber: 0, team: .red, character: .duck)
    player.position = CGPoint(x: 150, y: 600)
    let simulation = GameSimulation()

    return PlayerZoneView(
        player: player,
        gameSimulation: simulation,
        zoneWidth: 200,
        zoneHeight: 800,
        zoneMinX: 0
    )
}
