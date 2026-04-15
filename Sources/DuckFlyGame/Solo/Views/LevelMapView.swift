import SwiftUI

struct LevelMapView: View {
    @ObservedObject var levelProgress: LevelProgressManager
    @Binding var gameState: GameScreenState
    @State private var scrollPosition: CGFloat = 0

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.3, green: 0.6, blue: 1.0),
                    Color(red: 0.6, green: 0.8, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text("DUCK FLY")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Level \(levelProgress.highestUnlockedLevel)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    Button(action: { gameState = .mainMenu }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.black.opacity(0.2))

                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(1...50, id: \.self) { level in
                                LevelRowView(
                                    level: level,
                                    levelProgress: levelProgress,
                                    gameState: $gameState
                                )
                            }
                            .id("level-\(levelProgress.highestUnlockedLevel)")
                        }
                        .padding()
                    }
                    .onAppear {
                        proxy.scrollTo("level-\(levelProgress.highestUnlockedLevel)", anchor: .center)
                    }
                }
            }
        }
    }
}

struct LevelRowView: View {
    let level: Int
    @ObservedObject var levelProgress: LevelProgressManager
    @Binding var gameState: GameScreenState

    var body: some View {
        HStack(spacing: 16) {
            // Levels in a row
            ForEach([level, level + 1], id: \.self) { lv in
                if lv <= 100 {
                    LevelNodeView(
                        levelNumber: lv,
                        levelProgress: levelProgress,
                        gameState: $gameState
                    )
                }
            }
            Spacer()
        }
    }
}

struct LevelNodeView: View {
    let levelNumber: Int
    @ObservedObject var levelProgress: LevelProgressManager
    @Binding var gameState: GameScreenState

    var isCompleted: Bool {
        levelProgress.completedLevels.contains(levelNumber)
    }

    var isCurrent: Bool {
        levelProgress.highestUnlockedLevel == levelNumber
    }

    var isLocked: Bool {
        levelNumber > levelProgress.highestUnlockedLevel
    }

    var nodeColor: Color {
        if isCompleted {
            return Color.green
        } else if isCurrent {
            return Color.yellow
        } else {
            return Color.gray.opacity(0.5)
        }
    }

    var body: some View {
        Button(action: {
            guard !isLocked else { return }
            levelProgress.currentLevel = levelNumber
            gameState = .menu
        }) {
            VStack(spacing: 4) {
                let config = LevelConfig.make(level: levelNumber)

                Text(config.theme.emoji)
                    .font(.system(size: 20))

                Text("\(levelNumber)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                if isCurrent {
                    Text("🦆")
                        .font(.system(size: 12))
                }
            }
            .frame(width: 60, height: 60)
            .background(nodeColor)
            .cornerRadius(10)
            .opacity(isLocked ? 0.5 : 1.0)
        }
        .disabled(isLocked)
    }
}

#Preview {
    LevelMapView(
        levelProgress: LevelProgressManager(),
        gameState: .constant(.levelMap)
    )
}
