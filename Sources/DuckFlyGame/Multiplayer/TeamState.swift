import Foundation

/// Represents the state of a team in multiplayer game
class TeamState: ObservableObject, Identifiable {
    let id: UUID
    let teamIdentifier: TeamIdentifier
    var members: [PlayerState] = []

    @Published var totalScore: Int = 0
    @Published var lastSyncTime: Date = Date()

    init(teamIdentifier: TeamIdentifier) {
        self.id = UUID()
        self.teamIdentifier = teamIdentifier
    }

    func addMember(_ player: PlayerState) {
        members.append(player)
        updateTotalScore()
    }

    func updateTotalScore() {
        totalScore = members.reduce(0) { $0 + $1.score }
        lastSyncTime = Date()
    }

    func resetForNewGame() {
        members.forEach { $0.resetForNewGame() }
        totalScore = 0
    }

    var displayName: String {
        "Team \(teamIdentifier.rawValue)"
    }
}
