import Observation
import SwiftUI

@Observable
final class AppThemeStore {
    private let storageKey = "app.isDarkModeEnabled"

    var isDarkModeEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isDarkModeEnabled, forKey: storageKey)
        }
    }

    var preferredColorScheme: ColorScheme? {
        isDarkModeEnabled ? .dark : .light
    }

    init() {
        isDarkModeEnabled = UserDefaults.standard.bool(forKey: storageKey)
    }
}
