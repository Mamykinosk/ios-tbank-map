import SwiftUI
import Observation

enum AppScreen {
    case auth
    case main
}

enum AuthRoute: Hashable {
    case register
    case login
    case recovery
}

enum MainRoute: Hashable {
    case profile
    case settings
}

@Observable
final class AppRouter {
    var appScreen: AppScreen = .auth

    var authPath = NavigationPath()
    var mainPath = NavigationPath()

    func showAuth() {
        appScreen = .auth
        authPath = NavigationPath()
    }

    func showMain() {
        appScreen = .main
        authPath = NavigationPath()
    }

    func showLogin() {
        showAuth()
        authPath.append(AuthRoute.login)
    }

    func showRegister() {
        showAuth()
        authPath.append(AuthRoute.register)
    }

    func goToRegister() {
        authPath.append(AuthRoute.register)
    }
    
    func goToLogin() {
        authPath.append(AuthRoute.login)
    }
    
    func goToRecovery() {
        authPath.append(AuthRoute.recovery)
    }

    func goToProfile() {
        mainPath.append(MainRoute.profile)
    }

    func goToSettings() {
        mainPath.append(MainRoute.settings)
    }

    func backAuth() {
        guard !authPath.isEmpty else { return }
        authPath.removeLast()
    }
}
