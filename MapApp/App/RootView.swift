import Foundation
import SwiftUI

struct RootView: View {
    @Environment(AppCoordinator.self) var router
    @Environment(AppLanguageStore.self) var languageStore
    @Environment(AppThemeStore.self) var themeStore
    @Environment(AuthSessionStore.self) var authSession

    @State private var isShowingLaunchLoading = true

    var body: some View {
        ZStack {
            Group {
                if authSession.isAuthenticated {
                    MainTabView()
                } else {
                    AuthFlowView()
                }
            }
            .environment(router)
            .environment(authSession)
            .environment(themeStore)
            .id(languageStore.refreshID)

            if isShowingLaunchLoading {
                LaunchLoadingView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(1400))

            withAnimation(.easeInOut(duration: 0.3)) {
                isShowingLaunchLoading = false
            }
        }
    }
}
