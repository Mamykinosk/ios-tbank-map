import SwiftUI

struct AppTopBar: View {
    let title: LocalizedStringKey
    var showsBackButton = true
    var showsSettingsButton = true
    var onBack: (() -> Void)?
    var onSettings: (() -> Void)?

    var body: some View {
        HStack(spacing: 0) {
            Button {
                onBack?()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.appDeepGreen)
                    .frame(width: 36, height: 44)
                    .opacity(showsBackButton ? 1 : 0)
            }
            .buttonStyle(.plain)
            .disabled(!showsBackButton)

            Spacer()

            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .tracking(-0.5)
                .foregroundStyle(Color.appDeepGreen)

            Spacer()

            Button {
                onSettings?()
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.appDeepGreen)
                    .frame(width: 36, height: 44)
                    .opacity(showsSettingsButton ? 1 : 0)
            }
            .buttonStyle(.plain)
            .disabled(!showsSettingsButton)
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
        .background(Color.white.opacity(0.82))
    }
}

private extension Color {
    static let appDeepGreen = Color(red: 6 / 255, green: 78 / 255, blue: 59 / 255)
}
