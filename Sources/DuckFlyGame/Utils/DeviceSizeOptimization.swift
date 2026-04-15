import SwiftUI

/// Device size detection and optimization
enum DeviceSize {
    case iPhone
    case iPad
    case unknown

    static func current() -> DeviceSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        // iPad typically wider than tall, or very large screens
        if screenWidth > 768 || screenHeight > 1000 {
            return .iPad
        }

        return .iPhone
    }

    var name: String {
        switch self {
        case .iPhone:
            return "iPhone"
        case .iPad:
            return "iPad"
        case .unknown:
            return "Unknown"
        }
    }
}

/// Device-specific layout adjustments
struct DeviceOptimizedGameView<Content: View>: View {
    let content: () -> Content
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        ZStack {
            content()

            // Warning banner for 2v2/3v3 on small screens
            if shouldShowDeviceWarning {
                DeviceWarningBanner()
            }
        }
    }

    private var shouldShowDeviceWarning: Bool {
        DeviceSize.current() == .iPhone &&
            horizontalSizeClass == .compact
    }
}

/// Warning banner for unsupported configurations
struct DeviceWarningBanner: View {
    @State private var isVisible = true

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Better on iPad")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    Text("2v2 and 3v3 play best on larger screens")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                Button(action: { withAnimation { isVisible = false } }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(12)
            .background(ColorTheme.danger)
            .cornerRadius(8)
            .padding(12)

            Spacer()
        }
        .opacity(isVisible ? 1 : 0)
        .animation(.easeOut(duration: 0.3), value: isVisible)
    }
}

/// Responsive HUD that adapts to screen size
struct ResponsiveHUD: View {
    let gameManager: MultiplayerGameManager

    var body: some View {
        let deviceSize = DeviceSize.current()

        switch deviceSize {
        case .iPad:
            iPadHUD
        case .iPhone:
            iPhoneHUD
        case .unknown:
            iPhoneHUD
        }
    }

    @ViewBuilder
    private var iPadHUD: some View {
        // Full-featured HUD with more information
        VStack {
            HStack(spacing: 20) {
                // Team Red
                VStack(spacing: 4) {
                    Text("Team Red")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    Text("\(gameManager.teams[0].totalScore)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)

                    Text("Players: \(gameManager.teams[0].members.count)")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(TeamColorTheme.teamColor(.red))
                .cornerRadius(12)

                // Timer
                VStack(spacing: 4) {
                    Text("TIME")
                        .font(.system(size: 12, weight: .semibold))

                    Text(String(format: "%.1f", max(0, gameManager.remainingTime)))
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(gameManager.remainingTime < 10 ? ColorTheme.danger : ColorTheme.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(ColorTheme.lightBackground)
                .cornerRadius(12)

                // Team Blue
                VStack(spacing: 4) {
                    Text("Team Blue")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)

                    Text("\(gameManager.teams[1].totalScore)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)

                    Text("Players: \(gameManager.teams[1].members.count)")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(TeamColorTheme.teamColor(.blue))
                .cornerRadius(12)
            }
            .padding(16)

            Spacer()
        }
    }

    @ViewBuilder
    private var iPhoneHUD: some View {
        // Compact HUD for smaller screens
        VStack {
            HStack(spacing: 12) {
                VStack(spacing: 2) {
                    Text("Red")
                        .font(.system(size: 10, weight: .semibold))
                    Text("\(gameManager.teams[0].totalScore)")
                        .font(.system(size: 20, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(TeamColorTheme.teamColor(.red))
                .foregroundColor(.white)
                .cornerRadius(8)

                VStack(spacing: 2) {
                    Text("TIME")
                        .font(.system(size: 10, weight: .semibold))
                    Text(String(format: "%.0f", max(0, gameManager.remainingTime)))
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(gameManager.remainingTime < 10 ? ColorTheme.danger : ColorTheme.textPrimary)
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(ColorTheme.lightBackground)
                .cornerRadius(8)

                VStack(spacing: 2) {
                    Text("Blue")
                        .font(.system(size: 10, weight: .semibold))
                    Text("\(gameManager.teams[1].totalScore)")
                        .font(.system(size: 20, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(TeamColorTheme.teamColor(.blue))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(8)

            Spacer()
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
            Text("Device Size: \(DeviceSize.current().name)")
                .font(.headline)
                .padding()

            Spacer()
        }
    }
}
