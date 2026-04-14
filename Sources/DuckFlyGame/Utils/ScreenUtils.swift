import UIKit

/// Helper to get screen bounds compatible with iOS 26+
/// Handles deprecation of UIScreen.main
func getScreenBounds() -> CGRect {
    if #available(iOS 26.0, *) {
        // For iOS 26+, try to get from window scene
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen.bounds
        }
    }
    // Fallback for earlier iOS versions (uses deprecated API but necessary for compatibility)
    return UIScreen.main.bounds
}
