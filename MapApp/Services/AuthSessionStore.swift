import FirebaseAuth
import Observation

@MainActor
@Observable
final class AuthSessionStore {
    nonisolated(unsafe) private let auth = Auth.auth()
    nonisolated(unsafe) private var authStateHandle: AuthStateDidChangeListenerHandle?

    var currentUser: User?

    var isAuthenticated: Bool {
        currentUser != nil
    }

    init() {
        currentUser = auth.currentUser
        authStateHandle = auth.addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            Task { @MainActor in
                self.currentUser = user
            }
        }
        
        let service = MapboxService()

        service.searchPlace(query: "Moscow") { result in
            if let result = result {
                print("Место: \(result.name)")
                print("Lng: \(result.longitude)")
                print("Lat: \(result.latitude)")
            } else {
                print("Ничего не найдено или ошибка запроса")
            }
        }
    }

    deinit {
        if let authStateHandle {
            auth.removeStateDidChangeListener(authStateHandle)
        }
    }
}
