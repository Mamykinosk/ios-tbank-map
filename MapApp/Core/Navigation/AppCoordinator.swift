import SwiftUI
import Observation


@Observable
final class AppCoordinator {
    var appScreen: AppScreen = .auth
    var selectedMainTab: MainTab = .map

    var authPath = NavigationPath()
    var mainPath = NavigationPath()

    func showAuth() {
        appScreen = .auth
        authPath = NavigationPath()
    }

    func showMain() {
        appScreen = .main
        authPath = NavigationPath()
        selectedMainTab = .map
        mainPath = NavigationPath()
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
        selectMainTab(.profile)
    }

    func goToSettings() {
        mainPath.append(MainRoute.settings)
    }

    func selectMainTab(_ tab: MainTab) {
        selectedMainTab = tab
        mainPath = NavigationPath()
    }

    func backAuth() {
        guard !authPath.isEmpty else { return }
        authPath.removeLast()
    }
}
