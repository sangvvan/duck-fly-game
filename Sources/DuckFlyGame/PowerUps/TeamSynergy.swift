import Foundation
import SwiftUI

/// Manages team synergy combo system
class TeamSynergy: ObservableObject {
    let teamIdentifier: TeamIdentifier
    @Published var comboCounter: Int = 0
    @Published var lastCatchTime: Date? = nil
    @Published var isBonusActive: Bool = false

    private let comboWindow: TimeInterval = 2.0 // 2 seconds to maintain combo
    private let comboThreshold: Int = 2 // Catches within window

    init(teamIdentifier: TeamIdentifier) {
        self.teamIdentifier = teamIdentifier
    }

    func recordCatch() {
        let now = Date()

        // Check if within combo window
        if let lastTime = lastCatchTime {
            let timeSinceLastCatch = now.timeIntervalSince(lastTime)
            if timeSinceLastCatch <= comboWindow {
                comboCounter += 1
            } else {
                comboCounter = 1
            }
        } else {
            comboCounter = 1
        }

        lastCatchTime = now

        // Trigger bonus if threshold reached
        if comboCounter >= comboThreshold && !isBonusActive {
            triggerSynergyBonus()
        }
    }

    private func triggerSynergyBonus() {
        isBonusActive = true

        // Bonus active for short duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                self.isBonusActive = false
            }
        }
    }

    func resetCombo() {
        comboCounter = 0
        lastCatchTime = nil
        isBonusActive = false
    }

    func getSynergyBonus() -> Int {
        return comboCounter >= comboThreshold ? 50 : 0
    }
}

/// Team synergy bonus effect
struct TeamSynergyBonusView: View {
    let team: TeamIdentifier
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 12) {
            Text("TEAM COMBO!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)

            Text("+50 Bonus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(TeamColorTheme.teamColor(team))
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(TeamColorTheme.teamColor(team))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
        )
        .scaleEffect(isVisible ? 1.0 : 0.5)
        .opacity(isVisible ? 1.0 : 0)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        TeamSynergyBonusView(team: .red)
        TeamSynergyBonusView(team: .blue)
    }
    .padding()
    .background(ColorTheme.skyGradient())
}
