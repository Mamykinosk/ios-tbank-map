import SwiftUI

struct AppFloatingAddButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(Color.appFabIcon)
                .frame(width: 56, height: 56)
                .background(Color.appFabBackground)
                .clipShape(Circle())
                .shadow(color: Color.appFabBackground.opacity(0.4), radius: 24, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }
}

private extension Color {
    static let appFabBackground = Color(red: 189 / 255, green: 233 / 255, blue: 255 / 255)
    static let appFabIcon = Color(red: 0 / 255, green: 31 / 255, blue: 42 / 255)
}
