import SwiftUI

/// Model for point popup animations
struct PointPopupModel: Identifiable {
    let id = UUID()
    let points: Int
    let position: CGPoint
    let foodType: FoodType
    var opacity: Double = 1.0
    var yOffset: CGFloat = 0
}

/// Animated point value popup
struct PointPopupView: View {
    let popup: PointPopupModel

    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 12))
                .foregroundColor(popup.foodType.primaryColor)

            Text("+\(popup.points)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(popup.foodType.primaryColor)
        }
        .opacity(popup.opacity)
        .offset(y: popup.yOffset)
    }
}

/// Container for managing point popups
class PointPopupManager: ObservableObject {
    @Published var popups: [PointPopupModel] = []
    private let animationDuration: TimeInterval = 0.6
    private let travelDistance: CGFloat = 30

    func addPopup(at position: CGPoint, points: Int, foodType: FoodType) {
        let popup = PointPopupModel(
            points: points,
            position: position,
            foodType: foodType
        )

        withAnimation(.easeInOut(duration: animationDuration)) {
            popups.append(popup)
        }

        // Animate and remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            var updatedPopup = popup
            withAnimation(.easeOut(duration: self.animationDuration)) {
                updatedPopup.opacity = 0
                updatedPopup.yOffset = -self.travelDistance

                // Update popup in array
                if let index = self.popups.firstIndex(where: { $0.id == popup.id }) {
                    self.popups[index] = updatedPopup
                }
            }
        }

        // Remove from array after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.1) {
            self.popups.removeAll { $0.id == popup.id }
        }
    }

    func clear() {
        popups.removeAll()
    }
}

#if DEBUG && os(iOS)
@available(iOS 17.0, *)
#Preview {
    ZStack {
        ColorTheme.skyGradient()
            .ignoresSafeArea()

        VStack {
            HStack(spacing: 40) {
                PointPopupView(popup: PointPopupModel(
                    points: 10,
                    position: CGPoint(x: 100, y: 100),
                    foodType: .corn
                ))

                PointPopupView(popup: PointPopupModel(
                    points: 25,
                    position: CGPoint(x: 200, y: 100),
                    foodType: .berries
                ))

                PointPopupView(popup: PointPopupModel(
                    points: 50,
                    position: CGPoint(x: 300, y: 100),
                    foodType: .seeds
                ))
            }
            .padding()

            Spacer()
        }
    }
}
