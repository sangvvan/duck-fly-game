import Foundation

/// Game mode enumeration for multiplayer variants
enum GameMode: Equatable {
    case oneVsOne
    case twoVsTwo
    case threeVsThree

    var playerCount: Int {
        switch self {
        case .oneVsOne:
            return 2
        case .twoVsTwo:
            return 4
        case .threeVsThree:
            return 6
        }
    }

    var playersPerTeam: Int {
        switch self {
        case .oneVsOne:
            return 1
        case .twoVsTwo:
            return 2
        case .threeVsThree:
            return 3
        }
    }

    var displayName: String {
        switch self {
        case .oneVsOne:
            return "1v1"
        case .twoVsTwo:
            return "2v2"
        case .threeVsThree:
            return "3v3"
        }
    }
}

/// Team identifier
enum TeamIdentifier: String {
    case red = "Red"
    case blue = "Blue"

    var nextTeam: TeamIdentifier {
        self == .red ? .blue : .red
    }
}
