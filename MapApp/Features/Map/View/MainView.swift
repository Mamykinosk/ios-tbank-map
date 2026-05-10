import SwiftUI

struct MainView: View {
    @Environment(AuthSessionStore.self) private var authSession
    @Environment(AppCoordinator.self) private var router

    @Binding var selectedTab: AppTab

    @State private var errorMessage: String?
    @State private var isSigningOut = false

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                Text(L10n.Main.SignedIn.title)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(Color.appTitle)

                VStack(alignment: .leading, spacing: 12) {
                    infoRow(title: L10n.Main.email, value: authSession.currentUser?.email ?? L10n.Main.notSpecified)
                    infoRow(title: L10n.Main.uid, value: authSession.currentUser?.uid ?? L10n.Main.notFound)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                if let errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.appError)
                }

                Button {
                    signOut()
                } label: {
                    Group {
                        if isSigningOut {
                            ProgressView()
                                .tint(Color.appOnPrimary)
                        } else {
                            Text(L10n.Main.signOut)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .foregroundStyle(Color.appOnPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.appPrimary)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .disabled(isSigningOut)

                Spacer()
            }
            .padding(24)
            .padding(.bottom, 120)

            VStack {
                Spacer()

                AppBottomTabBar(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }

    private func infoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.secondary)

            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.appTitle)
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
