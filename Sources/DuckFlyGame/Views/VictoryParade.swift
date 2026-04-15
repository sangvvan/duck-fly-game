import SwiftUI

/// Victory celebration and parade animation
struct VictoryParadeView: View {
    let winningTeam: TeamState
    @State private var scale: CGFloat = 0
    @State private var rotation: Double = 0
    @State private var confettiOpacity: Double = 1.0

    var body: some View {
        ZStack {
            // Confetti particles
            ForEach(0..<50, id: \.self) { index in
                ConfettiParticle(
                    color: TeamColorTheme.teamColor(winningTeam.teamIdentifier),
                    delay: Double(index) * 0.02,
                    opacity: confettiOpacity
                )
                .offset(
                    x: CGFloat.random(in: -200...200),
                    y: CGFloat.random(in: -150...400)
                )
            }

            VStack(spacing: 24) {
                // Trophy emoji
                Text("🏆")
                    .font(.system(size: 80))
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))

                // Victory text
                VStack(spacing: 8) {
                    Text("TEAM WINS!")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(TeamColorTheme.teamColor(winningTeam.teamIdentifier))

                    Text("Team \(winningTeam.teamIdentifier.rawValue)")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .scaleEffect(scale)

                // Celebration characters
                HStack(spacing: 16) {
                    ForEach(winningTeam.members, id: \.id) { player in
                        CharacterCelebrationView(character: player.character)
                            .scaleEffect(scale)
                    }
                }
                .padding()
                .background(ColorTheme.lightBackground)
                .cornerRadius(12)

                // Final score
                Text("Final Score: \(winningTeam.totalScore)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .scaleEffect(scale)
            }
            .padding()
        }
        .onAppear {
            startCelebration()
        }
    }

    private func startCelebration() {
        withAnimation(.easeOut(duration: 0.8)) {
            scale = 1.0
        }

        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
            rotation = 360
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 1.0)) {
                confettiOpacity = 0
            }
        }
    }
}

/// Single confetti particle
struct ConfettiParticle: View {
    let color: Color
    let delay: Double
    let opacity: Double
    @State private var yOffset: CGFloat = 0
    @State private var rotation: Double = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 8, height: 8)
            .rotationEffect(.degrees(rotation))
            .offset(y: yOffset)
            .opacity(opacity)
            .onAppear {
                startAnimation()
            }
    }

    private func startAnimation() {
        withAnimation(.easeIn(duration: 2.5).delay(delay)) {
            yOffset = 800
        }

        withAnimation(.linear(duration: 2.5).delay(delay).repeatForever(autoreverses: false)) {
            rotation = 720
        }
    }
}

/// Character celebration animation
struct CharacterCelebrationView: View {
    let character: AnimalCharacter
    @State private var isJumping = false

    var body: some View {
        VStack(spacing: 8) {
            Text(character.emoji)
                .font(.system(size: 40))
                .offset(y: isJumping ? -30 : 0)

            Text(character.displayName)
                .font(.caption)
                .foregroundColor(ColorTheme.textSecondary)
        }
        .onAppear {
            startJumping()
        }
    }

    private func startJumping() {
        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
            isJumping = true
        }
    }
}

/// Score counter animation
struct ScoreCounterView: View {
    let finalScore: Int
    @State private var displayedScore: Int = 0

    var body: some View {
        VStack(spacing: 12) {
            Text("Final Score")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(ColorTheme.textSecondary)

            Text("\(displayedScore)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(ColorTheme.primaryAction)
                .monospacedDigit()
        }
        .onAppear {
            animateScore()
        }
    }

    private func animateScore() {
        let step = max(1, finalScore / 50) // Animate over ~50 frames
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            if displayedScore < finalScore {
                displayedScore = min(displayedScore + step, finalScore)
            } else {
                displayedScore = finalScore
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            timer.invalidate()
        }
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    let team = TeamState(teamIdentifier: .red)
    team.addMember(PlayerState(playerNumber: 0, team: .red, character: .duck))
    team.addMember(PlayerState(playerNumber: 1, team: .red, character: .bunny))
    team.totalScore = 350

    return ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VictoryParadeView(winningTeam: team)
    }
}
