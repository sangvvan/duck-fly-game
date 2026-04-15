import SwiftUI
#if os(iOS)
import UIKit
#endif

/// Accessibility support and features
struct AccessibilityModifier: ViewModifier {
    let label: String
    let hint: String?
    let value: String?

    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityValue(value ?? "")
    }
}

extension View {
    /// Add accessibility properties
    func accessibilityElement(
        label: String,
        hint: String? = nil,
        value: String? = nil
    ) -> some View {
        modifier(AccessibilityModifier(label: label, hint: hint, value: value))
    }
}

/// Haptic feedback helper
class HapticManager {
    static let shared = HapticManager()

    #if os(iOS)
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    #else
    func impact(_ style: Any = "medium") {}
    func selection() {}
    func notification(_ type: Any = "success") {}
    #endif
}

/// Accessibility-enhanced button
struct AccessibleButton: View {
    let title: String
    let action: () -> Void
    let style: AccessibleButtonStyle

    enum AccessibleButtonStyle {
        case primary
        case secondary
    }

    var body: some View {
        Button(action: {
            HapticManager.shared.impact(.medium)
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundColor(style == .primary ? .white : ColorTheme.textPrimary)
                .background(style == .primary ? ColorTheme.primaryAction : Color.white.opacity(0.8))
                .cornerRadius(12)
        }
        .accessibilityElement(
            label: title,
            hint: "Button"
        )
        .accessibilityAddTraits(.isButton)
    }
}

/// Dynamic type support for text
struct AccessibleText: View {
    let text: String
    let size: FontSize

    enum FontSize {
        case title
        case headline
        case body
        case caption

        var font: Font {
            switch self {
            case .title:
                return .system(.title, design: .default)
            case .headline:
                return .system(.headline, design: .default)
            case .body:
                return .system(.body, design: .default)
            case .caption:
                return .system(.caption, design: .default)
            }
        }
    }

    var body: some View {
        Text(text)
            .font(size.font)
            .lineLimit(nil)
            .truncationMode(.tail)
            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack(spacing: 20) {
            AccessibleText(text: "Accessibility Features", size: .title)
                .foregroundColor(ColorTheme.textPrimary)

            AccessibleButton(title: "Play Button", action: {
                HapticManager.shared.notification(.success)
            }, style: .primary)
            .padding(.horizontal)

            AccessibleButton(title: "Secondary Button", action: {}, style: .secondary)
                .padding(.horizontal)

            VStack(spacing: 8) {
                Text("Features:")
                    .font(.headline)
                    .foregroundColor(ColorTheme.textPrimary)

                Text("✓ VoiceOver support")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)

                Text("✓ Dynamic type support")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)

                Text("✓ Haptic feedback")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)

                Text("✓ High contrast colors")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textSecondary)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}
