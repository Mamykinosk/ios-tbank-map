import Foundation
import SwiftUI

struct RootView: View {
    @Environment(AppCoordinator.self) var router
    @Environment(AppLanguageStore.self) var languageStore
    @Environment(AuthSessionStore.self) var authSession

    var body: some View {
        Group {
            if authSession.isAuthenticated {
                MainTabView()
            } else {
                AuthFlowView()
            }
        }
        .environment(router)
        .environment(authSession)
        .id(languageStore.refreshID)
    }
}
