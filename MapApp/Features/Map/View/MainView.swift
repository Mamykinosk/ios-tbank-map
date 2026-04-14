import SwiftUI

struct MainView: View {
    @Environment(AuthSessionStore.self) private var authSession
    @Environment(AppRouter.self) private var router

    @State private var errorMessage: String?
    @State private var isSigningOut = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 252 / 255, green: 249 / 255, blue: 244 / 255)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 24) {
                    Text("Вы вошли в приложение")
                        .font(.system(size: 30, weight: .bold))

                    VStack(alignment: .leading, spacing: 12) {
                        infoRow(title: "Email", value: authSession.currentUser?.email ?? "Не указан")
                        infoRow(title: "UID", value: authSession.currentUser?.uid ?? "Не найден")
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.red)
                    }

                    Button {
                        signOut()
                    } label: {
                        Group {
                            if isSigningOut {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Sign Out")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(red: 22 / 255, green: 52 / 255, blue: 41 / 255))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(isSigningOut)

                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Travel Memorize")
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.secondary)

            Text(value)
                .font(.system(size: 16, weight: .medium))
                .textSelection(.enabled)
        }
    }

    private func signOut() {
        errorMessage = nil
        isSigningOut = true

        do {
            try AuthService.shared.signOut()
            router.showAuth()
        } catch {
            errorMessage = error.localizedDescription
        }

        isSigningOut = false
    }
}
